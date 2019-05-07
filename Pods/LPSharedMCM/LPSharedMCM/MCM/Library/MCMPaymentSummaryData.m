//
//  MCMPaymentSummaryData.m
//  laposte
//
//  Created by Ricardo Suarez on 20/01/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMPaymentSummaryData.h"
#import "HYBCart.h"
#import "HYBorderEntry.h"
#import "HYBProduct.h"
#import "HYBPrice.h"
#import "HYBB2CServiceWrapper.h"
#import "HYBB2CService.h"
#import "HYBVoucher.h"
#import "NSString+MCMCustom.h"
#import "MCMManager.h"
#import "MCMUser.h"

static NSString *Transaction_Status_Accepted_Key = @"ACCEPTED";
static NSString *Transaction_Status_Rejected_Key = @"REJECTED";
static NSString *Transaction_Status_Error_Key = @"ERROR";
static NSString *Transaction_Status_Review_Key = @"REVIEW";

static NSString *Transaction_Status_Key = @"transactionStatus";
static NSString *Date_Key = @"paymentDate";
static NSString *Commerce_Id_Key = @"merchantId";
static NSString *Transaction_Id_Key = @"transactionId";
static NSString *Total_Amount_Key = @"totalAmount";
static NSString *Card_Number_Key = @"cardNumber";
static NSString *Authorization_Id_Key = @"authorisationId";
static NSString *Certificate_Transaction_Number_Key = @"paymentCertificate";
static NSString *Order_Id_Key = @"commandNumber";

static NSString *orderPaymentType_Key = @"paiymentMeans";
static NSString *orderCardType_Key = @"cartType";

static NSString *orderProducts_Key = @"ProductsForOrder";
static NSString *productName_Key = @"productName";
static NSString *productFamily_Key = @"famille";

@interface MCMPaymentSummaryData ()

@property (nonatomic, strong) NSDictionary *sourceData;
@property (nonatomic, strong) HYBCart *sourceCart;

@end

@implementation MCMPaymentSummaryData

#pragma mark - ---- LIFE CICLE

#pragma mark - ---- INTERNAL

- (HybrisPaymentFinishStatus) transactionStatus {
    if ([self.transactionStatusText isEqualToString:Transaction_Status_Accepted_Key]) {
        return Accepted;
    } else if ([self.transactionStatusText isEqualToString:Transaction_Status_Error_Key] ||
               self.transactionStatusText.length  == 0) {
        return Error;
    } else if ([self.transactionStatusText isEqualToString:Transaction_Status_Rejected_Key]) {
        return Rejected;
    } else if ([self.transactionStatusText isEqualToString:Transaction_Status_Review_Key]) {
        return Review;
    }
    return noStatus;
}

- (NSString *) transactionStatusText {
    return [self.sourceData valueForKey:Transaction_Status_Key];
}

- (NSString *) date {
    return [self.sourceData valueForKey:Date_Key];
}

- (NSString *) commerceId {
    return [self.sourceData valueForKey:Commerce_Id_Key];
}

- (NSString *) transactionId {
    return [self.sourceData valueForKey:Transaction_Id_Key];
}

- (NSString *) totalAmount {
    return [self.sourceData valueForKey:Total_Amount_Key];
}

- (NSString *) cardNumberText {
    return [self.sourceData valueForKey:Card_Number_Key];
}

- (NSString *) authorizationId {
    return [self.sourceData valueForKey:Authorization_Id_Key];
}

- (NSString *) certificateId {
    return [self.sourceData valueForKey:Certificate_Transaction_Number_Key];
}

- (NSString *) orderId {
    return [self.sourceData valueForKey:Order_Id_Key];
}

////

- (NSString *) orderDate {
    return [self generateOrderDateStringFromString:[self.sourceData valueForKey:Date_Key]];
}

- (NSString *) orderProductsId {
    return [self generateOrderProductsId];
}

- (NSString *) orderProductsName {
    return [self generateOrderProductsName];
}

- (NSString *) orderProductsGenre {
    return [self generateOrderProductsGenre];
}

- (NSString *) orderProductsPrice {
    return [self generateOrderProductsPrice];
}

- (NSString *) orderProductsNumber {
    return [self generateOrderProductsNumber];
}

- (NSString *) orderNumber {
    return [self.sourceData valueForKey:Transaction_Id_Key] ? : @"";
}

- (NSString *) orderPromotionCode {
    HYBVoucher *voucher = [self.sourceCart.appliedVouchers firstObject];
    return [self.sourceData valueForKey:voucher.descriptor] ? : @"";
}

- (NSString *) orderReturnsHT {
    return self.sourceCart.totalPrice.value.stringValue ? : @"";
}

- (NSString *) orderReturnsTTC {
    return self.sourceCart.totalPriceWithTax.value.stringValue ? : @"";
}

- (NSString *) orderPaymentType {
    return [self.sourceData valueForKey:orderPaymentType_Key] ? : @"";
}

- (NSString *) orderCardType {
    return [self.sourceData valueForKey:orderCardType_Key] ? : @"";
}

- (NSString *) orderClientId {
    
    MCMUser *user = [[MCMManager sharedInstance] user];
    return user.email.getSHA256 ? : @"";
}

- (NSString *) orderIsNewCient {
    
    MCMUser *user = [[MCMManager sharedInstance] user];
    //return userAccount.loginInAppFromRegister ? @"Yes" : @"No";
    return nil;

}

- (NSString *) orderCRMId {
    
    MCMUser *user = [[MCMManager sharedInstance] user];
    return user.customerIdentifier ? : @"";
    
}

- (NSString *) lastProductCategory {
    return [self generateLastProductCategory];
}

- (NSString *) generateOrderDateStringFromString:(NSString *) dateString {
// TODO REPLACE THIS DATE WITH THE CORRECT DATE SENT BY SERVER
    NSDateFormatter *newDateFormatter = [NSDateFormatter new];
    [newDateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [newDateFormatter stringFromDate:[NSDate date]];
}

- (NSString *) generateOrderProductsNumber {
    NSMutableString *result = [NSMutableString new];
    
    for (HYBOrderEntry *order in self.sourceCart.entries) {
        if (result.length > 0) {
            [result appendString:@"|"];
        }
        
        [result appendString:order.quantity.stringValue];
    }
    
    return result;
}

- (NSString *) generateOrderProductsPrice {
    NSMutableString *result = [NSMutableString new];
    
    for (HYBOrderEntry *order in self.sourceCart.entries) {
        if (result.length > 0) {
            [result appendString:@"|"];
        }
        
        if (order.product.price) [result appendString:order.product.price.value.stringValue];
    }
    
    return result;
}

- (NSString *) generateOrderProductsGenre {
    NSMutableString *result = [NSMutableString new];
    
    for (NSDictionary *product in [self.sourceData valueForKey:orderProducts_Key]) {
        if (result.length > 0) {
            [result appendString:@"|"];
        }
        NSString *familly = [product valueForKey:productFamily_Key];
        
        if(familly == nil || [familly isEqual:[NSNull null]])
            familly = @"vide";
        
        [result appendString:[familly stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    }
    
    return result;
}

- (NSString *) generateLastProductCategory {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *product in [self.sourceData valueForKey:orderProducts_Key]) {
        NSString *familly = [product valueForKey:productFamily_Key];
        if(familly == nil || [familly isEqual:[NSNull null]])
            familly = @"vide";
        
        [result addObject:[familly stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    }
    
    if(result)
        return [result lastObject];
    else
        return @"";
    
}

//- (NSString *) generateOrderProductsGenre {
//    NSMutableArray *result = [[NSMutableString alloc] init];
//    
//    for (HYBOrderEntry *order in self.sourceCart.entries) {
//
//        if (order.product.categories) {
//            [result addObject:[order.product.categories lastObject]];
//        }
//
//    }
//    
//
//    return result;
//}



- (NSString *) generateOrderProductsName {
    NSMutableString *result = [NSMutableString new];
    
    for (NSDictionary *product in [self.sourceData valueForKey:orderProducts_Key]) {
        if (result.length > 0) {
            [result appendString:@"|"];
        }
        NSString *productName = [product valueForKey:productName_Key] ;
        if(productName == nil || [productName isEqual:[NSNull null]])
            productName = @"vide";
        [result appendString:[productName stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    }
    
    return result;
}

- (NSString *) generateOrderProductsId {
    NSMutableString *result = [NSMutableString new];
    
    for (HYBOrderEntry *order in self.sourceCart.entries) {
        if (result.length > 0) {
            [result appendString:@"|"];
        }
        
        [result appendString:order.product.code];
    }
    
    return result;
}

#pragma mark - ---- PUBLIC

+ (instancetype)paymentSummaryWithParams:(NSDictionary*)params cart:(HYBCart *)cart {
    NSError *error = nil;
    MCMPaymentSummaryData *object = [MCMPaymentSummaryData new];
    object.sourceData = params;
    object.sourceCart = cart;
    if (error) {
        NSLog(@"Couldn't convert JSON to model MCMPaymentSummaryData");
        return nil;
    }
    
    return object;
}

@end
