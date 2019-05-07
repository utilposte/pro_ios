//
//  REXConstant.m
//  laposte
//
//  Created by Mohamed Helmi Ben Jabeur on 14/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "REXConstant.h"

@implementation REXConstant

NSString *const REXContatct_Id_Key = @"id";
NSString *const REXContatct_Title_Key = @"title";
NSString *const REXContatct_Firstname_Key = @"firstName";
NSString *const REXContatct_LastName_Key = @"lastName";
NSString *const REXContatct_MiddleName_Key = @"middleName";

NSString *const REXAddress_Ligne2_Key = @"adresseL2";
NSString *const REXAddress_Ligne3_Key = @"adresseL3";
NSString *const REXAddress_Ligne4_Key = @"adresseL4";
NSString *const REXAddress_Ligne5_Key = @"adresseL5";
NSString *const REXAddress_Ligne6_CP_Key = @"adresseL6CP";
NSString *const REXAddress_Ligne6_Localite_Key = @"adresseL6Localite";
NSString *const REXAddress_VerifMascadiz_Key = @"verifMascadia";
NSString *const REXAddress_Country_Key = @"country";
NSString *const REXAddress_Country_Name_Key = @"name";
NSString *const REXAddress_Country_Isocode_Key = @"isocode";
NSString *const REXAddress_Ligne6_Code_Localite_key = @"adresseL6CodeLocalite";
NSString *const REXAddress_Quartier_Lettre_Key = @"ql";

//Params keys for add to cart request
NSString *const REXActivation_Time_Key = @"activationTime";
NSString *const REXAll_Person_Key = @"allPersons";
NSString *const REXContacts_Key = @"contacts";
NSString *const REXDead_Person_Key = @"deadPerson";
NSString *const REXAyant_Droit_Name_Key = @"ayantDroitNom";
NSString *const REXAyant_Droit_Prenom_Key = @"ayantDroitPrenom";
NSString *const REXDh_Civility_Key = @"dhCivilite";
NSString *const REXDh_Name_Key = @"dhName";
NSString *const REXDh_Optins_Key =@"dhOptins";
NSString *const REXDuration_Key = @"duration";
NSString *const REXNew_Address_Key = @"newAddress";
NSString *const REXOld_Address_Key = @"oldAddress";
NSString *const REXRenewed_Key = @"renewed";
NSString *const REXCan_Be_Newed_Key = @"canBeRenewed";
NSString *const REXStart_Date_Key = @"startDate";
NSString *const REXEnd_Date_Key = @"endDate";
NSString *const REXStatus_Key = @"status";
NSString *const REXType_Parcours_Key = @"typeParcours";
NSString *const REXUse_Addresses_Key = @"useAddresses";

NSString *const REXAlready_Left_Home_Activation_Key = @"alreadyLeftOldAddress";
NSString *const REXHas_Already_Left_Activation_Key = @"hasAlreadyLeft";
NSString *const REXPostOffice_Activation_Key = @"bdpActivation";
NSString *const REXOnline_Activation_Key = @"onlineActivation";

//Color for recap view controller
NSString *const REXCompleted_Date_background_Color = @"f74c4c";
NSString *const REXCompleted_Origin_address_background_Color = @"ff8436";
NSString *const REXCompleted_Destination_address_background_Color = @"008a90";
NSString *const REXCompleted_Beneficiary_background_Color = @"00afc4";
NSString *const REXCompleted_Activation_background_Color = @"038cb9";
NSString *const REXCompleted_Declaration_background_Color = @"374877";

NSString *const REX_ID_DHDECEDEE                  = @"DHDECEDEE";
NSString *const REX_ID_DHENFANTMINEUR             = @"DHENFANTMINEUR";
NSString *const REX_ID_DHMAJEURSOUSTUT            = @"DHMAJEURSOUSTUT";
NSString *const REX_ID_DHENFANTPARENTSDIVORCES    = @"DHENFANTPARENTSDIVORCES";
NSString *const REX_ID_DHATORT                    = @"DHATORT";
NSString *const REX_ID_DHDEMENAGEMENTENTREPRISE   = @"DHDEMENAGEMENTENTREPRISE";


@end
