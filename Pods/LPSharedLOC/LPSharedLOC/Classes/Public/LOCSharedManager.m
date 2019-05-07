//
//  LOCWebServiceManager.m
//  laposte
//
//  Created by Issam DAHECH on 21/07/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "LOCSharedManager.h"
#import "NSString+Crypting.h"
#import "LOCConstant.h"
#import "LOCPostalOffice.h"
#import "LOCPostBox.h"
#import "AFNetworking.h"

#define isPostalCodeKey @"containPostalCode"
#define searchStringKey @"searchString"

@interface LOCSharedManager() {
    AFHTTPRequestOperationManager *restManager;
}

@end

@implementation LOCSharedManager

+ (id)sharedManager {
    static LOCSharedManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
       restManager =  [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
    }
    return self;
}

#pragma mark - Post Office List
- (void)getPostOfficeListNearby:(double)latitude longitude:(double)longitude withBlock:(void (^)(NSArray *list))completionBlock {
    
    [self getToken:kLOC_list_bureaux_token completion:^(NSString *session) {
        if (session) {
            NSLog(@"GET Token : %@", session);
            NSString *md5Key = [[NSString stringWithFormat:@"%@%@", kLOC_generic_key,session] MD5];
            NSString *urlString = [NSString stringWithFormat:@"%@/%f/%f",kLOC_list_bureaux_nearby,latitude,longitude];
            NSDictionary *params = @{@"session":md5Key,
                                     @"id":@"4",
                                     @"range":@"5",};
//            [self->restManager.operationQueue cancelAllOperations];
            [self->restManager GET:urlString
                  parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSDictionary *data = (NSDictionary *)responseObject;
                         NSArray *officeList = [self getListOfPostOfficeFromDictionary:data[@"bureaux"]];
                         completionBlock(officeList);
                         if (officeList.count == 0) {
                             [self showNoDataError];
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         // WS KO
                         completionBlock(nil);
                         [self showServerError];
                     }];
        }
        else {
            completionBlock(nil);
            [self showServerError];
        }
    }];
}

- (void)getPostOfficeListByText:(NSString *)searchText withBlock:(void (^)(NSArray *list))completionBlock {
    [self getToken:kLOC_list_bureaux completion:^(NSString *session) {
        if (session) {
            NSLog(@"GET Token : %@", session);
            
            NSDictionary *dic = [self retrievePostalCodeIfExist:searchText];
            NSString *key = [[dic objectForKey:isPostalCodeKey] isEqualToString:@"YES"] ? @"code_postal" : @"ville";

            
            NSString *md5Key = [[NSString stringWithFormat:@"%@%@", kLOC_generic_key,session] MD5];
            NSDictionary *params = @{@"session":md5Key,
                                     @"id":@"4",
                                     key:[dic objectForKey:searchStringKey]};
//            [self->restManager.operationQueue cancelAllOperations];
            [self->restManager GET:kLOC_list_bureaux
                  parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSDictionary *data = (NSDictionary *)responseObject;
                         NSArray *officeList = [self getListOfPostOfficeFromDictionary:data[@"bureaux"]];
                         completionBlock(officeList);
                         if (officeList.count == 0) {
                             [self showNoDataError];
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         // WS KO
                         completionBlock(nil);
                         [self showServerError];
                     }];
        }
        else {
            completionBlock(nil);
            [self showServerError];
        }
    }];
}
#pragma mark - Post Office Detail

- (void)getPostOfficeDetailByKey:(NSString *)codeSite withBlock:(void (^)(LOCPostalOffice *detailPostOffice))completionBlock {
    NSString *getDetailPostOfficeUrl = [NSString stringWithFormat:@"%@/%@",kLOC_detailPostOffice,codeSite];
    [self getToken:getDetailPostOfficeUrl completion:^(NSString *session) {
        if (session) {
            NSLog(@"GET Token : %@", session);
            NSString *md5Key = [[NSString stringWithFormat:@"%@%@", kLOC_generic_key,session] MD5];
            NSDictionary *params = @{@"session":md5Key,
                                     @"id":@"4",
                                     @"codeSite":codeSite};
//            [self->restManager.operationQueue cancelAllOperations];
            [self->restManager GET:getDetailPostOfficeUrl
                  parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSDictionary *data = (NSDictionary *)responseObject;
                         if (data[@"bureaux"]) {
                             LOCPostalOffice *detailOffice = [[LOCPostalOffice alloc] initFromDetailDictionary:data[@"bureaux"][codeSite]];
                             completionBlock(detailOffice);
                         }
                         else {
                             completionBlock(nil);
                             [self showServerError];
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         // WS KO
                         completionBlock(nil);
                         [self showServerError];
                     }];
        }
        else {
            completionBlock(nil);
            [self showServerError];
        }
    }];
}

#pragma mark - retrait/depot List
- (void)getRetraitDepotList:(BOOL)isDepot nearbyList:(double)latitude longitude:(double)longitude withBlock:(void (^)(NSArray *list))completionBlock {
    
    [self getCityNamePostalCodeFromPosition:latitude longitude:longitude withBlock:^(NSDictionary *result) {
        if (result) {
            [self getRetraitDepotList:isDepot byText:result[@"value"] withBlock:^(NSArray *list) {
                completionBlock(list);
            }];
        }
        else {
            completionBlock(nil);
        }
    }];
}

- (void)getRetraitDepotList:(BOOL)isDepot byText:(NSString *)searchText withBlock:(void (^)(NSArray *list))completionBlock {
    
    [self getToken:kLOC_list_depot_retrait completion:^(NSString *session) {
        if (session) {
            NSLog(@"GET Token : %@", session);
            NSString *md5Key = [[NSString stringWithFormat:@"%@%@", kLOC_generic_key,session] MD5];
            NSString *type = isDepot?@"depot":@"retrait";

            NSDictionary *dic = [self retrievePostalCodeIfExist:searchText];
            
            NSString *key = [[dic objectForKey:isPostalCodeKey] isEqualToString:@"YES"] ? @"code_postal" : @"ville";

            
            NSDictionary *params = @{@"session":md5Key,
                                     @"id":@"4",
                                     key:[dic objectForKey:searchStringKey],
                                     @"ret_dep":type};
//            [self->restManager.operationQueue cancelAllOperations];
            [self->restManager GET:kLOC_list_depot_retrait
                  parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSDictionary *data = (NSDictionary *)responseObject;
                         NSArray *officeList = [self getListOfPostOfficeFromDictionary:data[@"bureaux"]];
                         completionBlock(officeList);
                         if (officeList.count == 0) {
                             [self showNoDataError];
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         // WS KO
                         completionBlock(nil);
                         [self showServerError];
                     }];
        }
        else {
            completionBlock(nil);
            [self showServerError];
        }
    }];
}

- (void)getRetraitDepotList:(BOOL)isDepot nearbyList:(double)latitude longitude:(double)longitude byDay:(NSString*)day byHour:(NSString*)hour byType:(NSString*)type withBlock:(void (^)(NSArray *list))completionBlock {
    
    
    [self getCityNamePostalCodeFromPosition:latitude longitude:longitude withBlock:^(NSDictionary *result) {
        if (result) {
            [self getRetraitDepotList:isDepot byText:result[@"value"] byDay:day  byHour:hour byType:type withBlock:^(NSArray *list) {
                completionBlock(list);
            }];
        }
        else {
            completionBlock(nil);
        }
    }];
}

- (void)getRetraitDepotList:(BOOL)isDepot byText:(NSString *)searchText byDay:(NSString*)day byHour:(NSString*)hour byType:(NSString*)type withBlock:(void (^)(NSArray *list))completionBlock {
    
    [self getToken:kLOC_list_depot_retrait completion:^(NSString *session) {
        if (session) {
            NSLog(@"GET Token : %@", session);
            NSString *md5Key = [[NSString stringWithFormat:@"%@%@", kLOC_generic_key,session] MD5];
            NSString *retType = isDepot?@"depot":@"retrait";

            NSDictionary *dic = [self retrievePostalCodeIfExist:searchText];
            
            NSString *key = [[dic objectForKey:isPostalCodeKey] isEqualToString:@"YES"] ? @"code_postal" : @"ville";

            NSDictionary *params = @{@"session":md5Key,
                                     @"id":@"4",
                                     key:[dic objectForKey:searchStringKey],
                                     @"ret_dep":retType,
                                     @"jour":day,
                                     @"heure":hour,
                                     @"type":type};
//            [self->restManager.operationQueue cancelAllOperations];
            [self->restManager GET:kLOC_list_depot_retrait
                  parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSDictionary *data = (NSDictionary *)responseObject;
                         NSArray *officeList = [self getListOfPostOfficeFromDictionary:data[@"bureaux"]];
                         completionBlock(officeList);
                         if (officeList.count == 0) {
                             [self showNoDataError];
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         // WS KO
                         completionBlock(nil);
                         [self showServerError];
                     }];
        }
        else {
            completionBlock(nil);
            [self showServerError];
        }
    }];
}

#pragma mark - post box
- (void)getPostBoxListNearby:(double)latitude longitude:(double)longitude withBlock:(void (^)(NSArray *list))completionBlock {
    
    
    [self getCityNamePostalCodeFromPosition:latitude longitude:longitude withBlock:^(NSDictionary *result) {
        if (result) {
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@", kLOC_postal_box_search, result[@"value"]];
//            [self->restManager.operationQueue cancelAllOperations];
            [self->restManager GET:urlString
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSDictionary *data = (NSDictionary *)responseObject;
                         NSArray *postBoxList = [self getListOfPostBoxFromDictionary:data[@"records"]];
                         completionBlock(postBoxList);
                         if (postBoxList.count == 0) {
                             [self showNoDataError];
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         // WS KO
                         completionBlock(nil);
                         [self showServerError];
                     }];
        }
        else {
            completionBlock(nil);
        }
    }];

 
}

- (void)getPostBoxList:(NSString *)searchText withBlock:(void (^)(NSArray *list))completionBlock {
    
    
    NSDictionary *dic = [self retrievePostalCodeIfExist:searchText];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLOC_postal_box_search, [dic objectForKey:searchStringKey]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" "
                                         withString:@"%20"];

//    [restManager.operationQueue cancelAllOperations];
    [restManager GET:urlString
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *data = (NSDictionary *)responseObject;
                 NSArray *postBoxList = [self getListOfPostBoxFromDictionary:data[@"records"]];
                 completionBlock(postBoxList);
                 if (postBoxList.count == 0) {
                     [self showNoDataError];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 // WS KO
                 completionBlock(nil);
                 [self showServerError];
             }];
}

#pragma mark - GenericPostOfficeList
- (NSArray *)getListOfPostOfficeFromDictionary:(NSDictionary *)dict {
    NSMutableArray *officePostList = [[NSMutableArray alloc] init];
    
    NSArray *listKeys = [dict allKeys];
    
    for (NSString *key in listKeys) {
        LOCPostalOffice *postalOffice = [[LOCPostalOffice alloc] initFromList:dict[key][@"general"]];
        [officePostList addObject:postalOffice];
    }
    
    return officePostList;
}

#pragma mark - GenericPostBox
- (NSArray *)getListOfPostBoxFromDictionary:(NSArray *)array {
    NSMutableArray *officePostList = [[NSMutableArray alloc] init];

    for (NSDictionary *dic in array) {
        LOCPostBox *postalOffice = [[LOCPostBox alloc] initWithDictionary:dic];
        [officePostList addObject:postalOffice];
    }
    
    return officePostList;
}

#pragma mark - GenericToken

- (void)getToken:(NSString *)baseUrl
      completion:(void (^)(NSString *session))completionBlock
{
    //set MD5 key
    NSString *md5Key = [kLOC_generic_key MD5];
    //set params
    NSString *urlString = [NSString stringWithFormat:@"%@?session=%@&id=%@&range=%@", baseUrl,md5Key,@"4",@"5"];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (responseDic && responseDic[@"token"]) { // token OK
                completionBlock(responseDic[@"token"]);
            }
            else {
                // token KO
                completionBlock(nil);
            }
        }
        
        else {
            // DATA KO
            completionBlock(nil);
        }
    }];
    [dataTask resume];
}



#pragma mark - Utils
- (BOOL)isPostalCode:(NSString *)string {
    
    NSString *pinRegex = @"^[0-9]{5}$";
    NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];

    BOOL pinValidates = [pinTest evaluateWithObject:string];
    return pinValidates;
}

- (NSDictionary *)retrievePostalCodeIfExist:(NSString *)string {

    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *pinRegex = @"^[0-9]{5}$";
    NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];
    
    
    if ([string containsString:@" "]) {
        // extract all string separated with " "
        NSArray* subStrings = [string componentsSeparatedByString: @" "];
        
        for (NSString *subString in subStrings) {
            // check if a string is zipcode
            if ([pinTest evaluateWithObject:subString]) {
                
                // zip code found. set it in the dic and quit
                [dic setObject:@"YES" forKey:isPostalCodeKey];
                [dic setObject:subString forKey:searchStringKey];

                return dic;
            }
            
        }
        
        // no zipcode found

        [dic setObject:@"NO" forKey:isPostalCodeKey];
        [dic setObject:string forKey:searchStringKey];

        
    } else {
    
        // the string does not contain " "
        if ([self isPostalCode:string]) {
            [dic setObject:@"YES" forKey:isPostalCodeKey];
        } else {
            [dic setObject:@"NO" forKey:isPostalCodeKey];
        }

        [dic setObject:string forKey:searchStringKey];
    }

    return dic;
}


- (void)getCityNamePostalCodeFromPosition:(double)latitude longitude:(double)longitude withBlock:(void (^)(NSDictionary *result))completionBlock {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *currentLocation =[[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             if (placemark.locality != nil && placemark.postalCode != nil) {
                 NSString *town = [[NSString alloc]initWithString:placemark.locality];
                 NSString *zipCode = [[NSString alloc]initWithString:placemark.postalCode];
                 NSDictionary *result;
                 if (zipCode != nil) {
                     NSString *value = zipCode;
                     NSString *key = @"postal_code";
                     result = @{@"key"      : key,
                                @"value"    :value};
                     completionBlock(result);
                     return;
                 }
                 if (town != nil) {
                     NSString *value = town;
                     NSString *key = @"ville";
                     result = @{@"key"      : key,
                                @"value"    :value};
                     completionBlock(result);
                     return;
                 } else {
                     completionBlock(nil);
                 }
             } else {
                 completionBlock(nil);
             }
         } else {
             completionBlock(nil);
         }
     }];
    
////    // HACK
////    double lat = 48.855712;
////    double lng = 2.271361;
}

- (void)showNetworkError {
    [self showErrorAlertViewWithTitle:LOCLocalizedString(@"office_detail_error_network_title",@"") message:LOCLocalizedString(@"office_detail_error_network_text",@"") buttonText:LOCLocalizedString(@"office_detail_error_ok",@"")];
}

- (void)showNoDataError {
    [self showErrorAlertViewWithTitle:LOCLocalizedString(@"office_detail_error_no_data_title",@"") message:LOCLocalizedString(@"office_detail_error_no_data_text",@"") buttonText:LOCLocalizedString(@"office_detail_error_ok",@"")];
}

- (void)showServerError {
    [self showErrorAlertViewWithTitle:LOCLocalizedString(@"office_detail_error_server_title",@"") message:LOCLocalizedString(@"office_detail_error_server_text",@"") buttonText:LOCLocalizedString(@"office_detail_error_close",@"")];
}
- (void)showErrorAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonText:(NSString *)buttonText {
//    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonText otherButtonTitles:nil, nil] show];
}
@end
