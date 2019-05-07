//
//  REXConstant.h
//  laposte
//
//  Created by Mohamed Helmi Ben Jabeur on 14/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REXConstant : NSObject

extern NSString *const REXContatct_Id_Key;
extern NSString *const REXContatct_Title_Key;
extern NSString *const REXContatct_Firstname_Key;
extern NSString *const REXContatct_LastName_Key;
extern NSString *const REXContatct_MiddleName_Key;
extern NSString *const REXAddress_Ligne2_Key;
extern NSString *const REXAddress_Ligne3_Key;
extern NSString *const REXAddress_Ligne4_Key;
extern NSString *const REXAddress_Ligne5_Key;
extern NSString *const REXAddress_Ligne6_CP_Key;
extern NSString *const REXAddress_Ligne6_Localite_Key;
extern NSString *const REXAddress_VerifMascadiz_Key;
extern NSString *const REXAddress_Country_Key;
extern NSString *const REXAddress_Country_Name_Key;
extern NSString *const REXAddress_Country_Isocode_Key;
extern NSString *const REXAddress_Ligne6_Code_Localite_key;
extern NSString *const REXAddress_Quartier_Lettre_Key;

//Params keys for add to cart request
extern NSString *const REXActivation_Time_Key;
extern NSString *const REXAll_Person_Key;
extern NSString *const REXContacts_Key;
extern NSString *const REXDead_Person_Key;
extern NSString *const REXAyant_Droit_Name_Key;
extern NSString *const REXAyant_Droit_Prenom_Key;
extern NSString *const REXDh_Civility_Key;
extern NSString *const REXDh_Name_Key;
extern NSString *const REXDh_Optins_Key;
extern NSString *const REXDuration_Key;
extern NSString *const REXNew_Address_Key;
extern NSString *const REXOld_Address_Key;
extern NSString *const REXRenewed_Key;
extern NSString *const REXCan_Be_Newed_Key;
extern NSString *const REXStart_Date_Key;
extern NSString *const REXEnd_Date_Key;
extern NSString *const REXStatus_Key;
extern NSString *const REXType_Parcours_Key;
extern NSString *const REXUse_Addresses_Key;
extern NSString *const REXPostOffice_Activation_Key;
extern NSString *const REXOnline_Activation_Key;
extern NSString *const REXAlready_Left_Home_Activation_Key;
extern NSString *const REXHas_Already_Left_Activation_Key;

//Color for recap view controller
extern NSString *const REXCompleted_Activation_background_Color;
extern NSString *const REXCompleted_Date_background_Color;
extern NSString *const REXCompleted_Origin_address_background_Color;
extern NSString *const REXCompleted_Destination_address_background_Color;
extern NSString *const REXCompleted_Beneficiary_background_Color;
extern NSString *const REXCompleted_Declaration_background_Color;

extern NSString *const REX_ID_DHDECEDEE;
extern NSString *const REX_ID_DHENFANTMINEUR;
extern NSString *const REX_ID_DHMAJEURSOUSTUT;
extern NSString *const REX_ID_DHENFANTPARENTSDIVORCES;
extern NSString *const REX_ID_DHATORT;
extern NSString *const REX_ID_DHDEMENAGEMENTENTREPRISE;

@end
