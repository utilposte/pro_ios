//
//  MCMTrackingHelper.m
//  Pods
//
//  Created by Ricardo Suarez on 05/09/16.
//
//

#import "MCMTrackingHelper.h"

#import "MCMTrackingConstants.h"
#import "MCMPaymentSummaryData.h"
#import "HYBCart.h"
#import "HYBPrice.h"
#import "HYBVoucher.h"
#import "HYBOrderEntry.h"
#import "HYBProduct.h"

@implementation MCMTrackingHelper


#pragma mark - INTERNAL

+ (NSArray *)composeProductsTrackingInfoWithCart:(HYBCart *)cart {
    
    NSMutableArray *products = [NSMutableArray new];
    
    for (HYBOrderEntry *entry in cart.entries) {
        NSMutableDictionary *product = [NSMutableDictionary new];
        
        [product setObject:entry.product.name ? : @"" forKey:MCMTracking_Data_Product_Name];
        [product setObject:[entry.product.categories firstObject] ? : @"" forKey:MCMTracking_Data_Product_Category];
        [product setObject:entry.quantity ? : @"" forKey:MCMTracking_Data_Product_Quantity];
        [product setObject:entry.basePrice.value ? : @"" forKey:MCMTracking_Data_Product_Base_Price];
        
        [products addObject:product];
    }
    
    return [NSArray arrayWithArray:products];
}

#pragma mark - PUBLIC

+ (NSDictionary *)composeTrackingInfoWithOrder:(MCMPaymentSummaryData *)summary cart:(HYBCart *)cart {
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    [result setObject:summary.orderId ? :@"" forKey:MCMTracking_Data_Order_Id];
    [result setObject:cart.totalPrice.value ? :@"" forKey:MCMTracking_Data_Order_Subtotal];
    [result setObject:cart.totalTax.value ? :@"" forKey:MCMTracking_Data_Order_Total_Tax];
    [result setObject:summary.orderIsNewCient ? :@"" forKey:MCMTracking_Data_Order_Is_New_Client];
    [result setObject:cart.deliveryCost.value ? :@"" forKey:MCMTracking_Data_Order_Delivery_Cost];
    [result setObject:summary.orderDate ? :@"" forKey:MCMTracking_Data_Order_Date];
    [result setObject:summary.orderProductsId ? :@"" forKey:MCMTracking_Data_Order_Products_Id];
    [result setObject:summary.orderProductsName ? :@"" forKey:MCMTracking_Data_Order_Products_Name];
    [result setObject:summary.orderProductsGenre ? :@"" forKey:MCMTracking_Data_Order_Products_Genre];
    [result setObject:summary.orderProductsPrice ? :@"" forKey:MCMTracking_Data_Order_Products_Price];
    [result setObject:summary.orderProductsNumber ? :@"" forKey:MCMTracking_Data_Order_Products_Number];
    [result setObject:summary.orderPromotionCode ? :@"" forKey:MCMTracking_Data_Order_Promotion_Code];
    [result setObject:summary.orderReturnsHT ? :@"" forKey:MCMTracking_Data_Order_Returns_HT];
    [result setObject:summary.orderReturnsTTC ? :@"" forKey:MCMTracking_Data_Order_Returns_TTC];
    [result setObject:summary.orderPaymentType ? :@"" forKey:MCMTracking_Data_Order_Payment_Type];
    [result setObject:summary.orderClientId ? :@"" forKey:MCMTracking_Data_Order_Client_Id];
    [result setObject:summary.orderCRMId ? :@"" forKey:MCMTracking_Data_Order_Commerce_Id];
    [result setObject:summary.orderCardType ? :@"" forKey:MCMTracking_Data_Order_Card_Type];
    //Added for accengage tracking
    [result setObject:summary.lastProductCategory ? :@"" forKey:MCMTracking_Data_Product_Last_Category];
    
    HYBVoucher *voucher = [cart.appliedVouchers firstObject];
    NSString *voucherCode = voucher.voucherCode ? : @"";
    [result setObject:voucher.appliedValue.value ? :@"" forKey:MCMTracking_Data_Order_Applied_Voucher_Value];
    [result setObject:voucherCode ? :@"" forKey:MCMTracking_Data_Order_Applied_Voucher_Code];
    
    [result setObject:cart.code ? :@"" forKey:MCMTracking_Data_Cart_Code];
    [result setObject:[MCMTrackingHelper composeProductsTrackingInfoWithCart:cart] forKey:MCMTracking_Data_Cart_Products];
    
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
