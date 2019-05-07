//
//  LPAddressEntity.h
//  AFNetworking
//
//  Created by LaPoste on 26/11/2018.
//
@protocol LPAddressTrackingProtocol
-(void)sendGenericFormViewControllerDisplayed;
-(void)sendGenericSarcadiaViewControllerDisplayed;
-(void)sendKeepAddressEntredAction;
-(void)sendModifyingAddressAction;
@end
//@objc protocol LPAddressTrackingProtocol {
//    func sendGenericFormViewControllerDisplayed()
//    func sendGenericSarcadiaViewControllerDisplayed()
//    func sendKeepAddressEntredAction()
//    func sendModifyingAddressAction()
//}
//
//@objc enum FormKeys: Int {
//case AddressKind = 0
//case Civility  = 1
//case CompanyName = 2
//case ServiceNameReciever = 3
//case ServiceNameSender = 4
//case FirstName = 5
//case LastName = 6
//case Email = 7
//case Tel = 8
//case ComplementaryAddress = 9
//case Steet = 10
//case PostalCode = 11
//case Locality = 12
//case Country = 13
//case EmailHeader = 14
//case Welcome = 15
//
//case CurrentPositionButton = 16
//case SaveAddress = 17
//case ValidateButton = 18
//}
enum forms {addressKind = 0, civility = 1 , companyName = 2 , serviceNameReciever = 3 , serviceNameSender = 4, firstName = 5, lastName = 6, email = 7, tel = 8, complementaryAddress = 9, steet = 10, postalCode = 11, locality = 12, country = 13 , emailHeader = 14 , welcome = 15, currentPositionButton = 16, saveAddress= 17, validateButton = 18
};
enum CLViewPresentation { push = 0 ,modal, modalWithViewDescription};
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPAddressEntity : NSObject

@property (nonatomic) NSString *civility;
@property (nonatomic) NSString *companyName;
@property (nonatomic) NSString *serviceName;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *complementaryAddress;
@property (nonatomic) NSString *street;
@property (nonatomic) NSString *postalCode;
@property (nonatomic) NSString *locality;
@property (nonatomic) NSString *countryName;
@property (nonatomic) NSString *countryIsoCode;
@property (nonatomic) NSString *formattedAddress;
@property (nonatomic) NSString *placeIDForGooglePlaces;
@property (nonatomic) NSString *isLocal;

-(NSString *) toString;
-(NSDictionary *) dictionary;
@end

NS_ASSUME_NONNULL_END
