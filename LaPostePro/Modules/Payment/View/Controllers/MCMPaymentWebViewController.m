//
//  MCMPaymentWebViewController.m
//  laposte
//
//  Created by Ricardo Suarez on 15/06/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMPaymentWebViewController.h"
#import "CardIO.h"
#import <UIKit/UIKit.h>
#import "LaPostePro-Swift.h"


//#import "CardIO.h"
//#import "EnvironmentURLs.h"

#define PAYMENT_URL1 @"https://payment.test.sips-atos.com"
#define PAYMENT_URL2 @"https://rcet-payment.sips-atos.com"


static NSString *const CANCEL_PAYMENT_PATTERN = @"post-payment/cancel";
static NSString *const FINISH_PAYMENT_PATTERN = @"post-payment/occ-confirmation";
static const NSInteger DELAY_IN_SECONDS = 5.0;
static const NSInteger certificateErrorCode = -1202;


static BOOL authenticated = NO;

@interface MCMPaymentWebViewController () <UIWebViewDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLConnectionDelegate, CardIOPaymentViewControllerDelegate> {
    BOOL isShowButtonOpenCardIo;
    BOOL isOnCallPaymentPage;
    UIButton *openCardIoButton;
}

//@property (nonatomic, strong) UIWebView *paymentWebview;
@property (weak, nonatomic) IBOutlet UIWebView *paymentWebview;

@property (nonatomic, strong) NSURLRequest *requestToSecurize;
@property (nonatomic, assign) NSInteger webViewLoads;
@property (nonatomic, assign) NSInteger loads;
@property (nonatomic, assign) NSString* string;
@end

@implementation MCMPaymentWebViewController
#pragma mark - ---- LIFE CICLE

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //[self createWebViewController];
    //[self setTitle:[MCMLocalizedStringHelper stringForKey:@"hybris_payment_webview_layout_title"]];
    
    self.webViewLoads = 0;
    self.debugMode = YES;
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self userAgent], @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
                                
    // Do any additional setup after loading the view.
    //[self addBackButton];
    self.paymentWebview.hidden =YES;
    
    if(_debugMode) {

        NSString *pattern = @"http.*.laposte.fr";
        NSError *error = nil;
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];

        // EnvironmentUrlsManager.sharedManager.getHybrisServiceHost()
        NSString *hybrisUrl = self.hybrisUrl;
        NSString * replacmentURL = [NSString stringWithFormat:@"https://" @"%@",  hybrisUrl];
        NSString * replacedHTML = [regex stringByReplacingMatchesInString:self.initalPaymentFormHTML options:0 range:NSMakeRange(0, [self.initalPaymentFormHTML length]) withTemplate:replacmentURL];
        [self.paymentWebview loadHTMLString:replacedHTML baseURL:nil];
    } else {
        [self.paymentWebview loadHTMLString:self.initalPaymentFormHTML baseURL:nil];
    }
    self.loads = 0;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [CardIOUtilities preloadCardIO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.paymentWebview stopLoading];
    self.requestToSecurize = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    // Dispose of any resources that can be recreated.
}

//- (void)createWebViewController {
//    self.paymentWebview = [[UIWebView alloc] init];
//    self.paymentWebview.delegate = self;
//    self.paymentWebview.frame = self.view.bounds;
//
//    [self.view addSubview:self.paymentWebview];
//}


- (void)transitionToCallbackStatusScreenWithStatus:(BOOL) success
{
    if (success) {
//        [[ATInternetTagManager sharedManager] sendTrackOrderWithPaymentSummaryData:self.finishSummary cart:self.cart];
        NSBundle *moduleBundle = [MCMBundleHelper moduleBundle];
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Payment" bundle:moduleBundle];
        PaymentConfirmationViewController * confirmationViewController = [storyboard  instantiateViewControllerWithIdentifier:@"PaymentConfirmationViewController"];
        
        
//        [[[CartViewModel sharedInstance] cart] hasOnlyEservice];
//        [[[CartViewModel sharedInstance] cartContainColissimo];
        

        
         [confirmationViewController setupWithDeliveryDateMessage:_cart.estimateShipmentDateLabel
                                                      orderNumber:_orderNumber
                                                    isOnlyService:[[[CartViewModel sharedInstance] cart] hasOnlyEservice]
                                                containsColissimo:[[CartViewModel sharedInstance] cartContainColissimo]
                                                      depositDate:[[CartViewModel sharedInstance] getDepositDate]
                                          isDepositModePostOffice:[[CartViewModel sharedInstance] isDepositModePostOffice]];
        
//        [confirmationViewController setupWithDeliveryDateMessage:_cart.estimateShipmentDateLabel orderInvoice:_orderNumber orderType:OrderTypeColissimo];
        
//        (PaymentConfirmationViewController *)confirmationViewController.isModeDepotBP
        
        //[self presentViewController:confirmationViewController animated:true completion:nil];
        // Need change
        [self.navigationController pushViewController:confirmationViewController animated:YES];
    }
    else {
        [[MCMLoadingManager sharedInstance] hideLoading];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Erreur de paiement"
                                                                      message:@"Votre commande n'a malheureusement pas pu aboutir. Nous vous confirmons que votre compte bancaire ne sera pas débité du montant de votre commande."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - ---- ---- NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"=== WebController Got auth challange via NSURLConnection");
    
    if ([challenge previousFailureCount] == 0) {
        authenticated = YES;
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        [self.paymentWebview stopLoading];
        [self.paymentWebview loadRequest:self.requestToSecurize];
        
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

#pragma mark - ---- ---- UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"=== shouldStartLoadWithRequest");
    NSLog(@"request = %@", [[request URL] absoluteString]);
    
    if ([request.URL.absoluteString rangeOfString:CANCEL_PAYMENT_PATTERN].location != NSNotFound) {
        //self.finishStatus = Canceled;
        [self transitionToCallbackStatusScreenWithStatus:NO];
        return NO;
    } else if ([request.URL.absoluteString rangeOfString:FINISH_PAYMENT_PATTERN].location != NSNotFound) {
        self.finishJsonSummaryURL = request.URL.absoluteString;
    
        NSString * confirmationURL = self.finishJsonSummaryURL;
        
        //Used only for debug
        //BOOL replaceHybrisHostConfirmation = NO;
        if (self.debugMode) {
        
        
        NSString * redirectionUrl = self.hybrisUrl;
        //NSString * redirectionUrl = [[EnvironmentURLs sharedInstance] hybrisServiceHost];
       //Trying to change host
        NSString * host = [[NSURL URLWithString:self.finishJsonSummaryURL] host];
        confirmationURL = [self.finishJsonSummaryURL stringByReplacingOccurrencesOfString:host withString:redirectionUrl];
        }

        [self determineFlowFromJsonFromResponse:confirmationURL];
        //        [self transitionToCallbackStatusScreenWithStatus:successPayment];
        return NO;
    }
    
    BOOL isSecureRequest = [request.URL.absoluteString rangeOfString:@"https"].location != NSNotFound;
    if (isSecureRequest && !authenticated) {
        self.requestToSecurize = request;
        [[MCMLoadingManager sharedInstance] showLoading];
        
        // Modified on 08/12/2016 -- using NSURLConnection instead of NSURLSession
        // Modified on 19/04/2017 -- Use NSURLConncetion on Recette and NSURLSession on Prod
        if([request.URL.absoluteURL.absoluteString containsString:PAYMENT_URL1])
        {
            NSURL *url = [NSURL URLWithString:PAYMENT_URL1];
            _urlConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
            [_urlConnection start];
        }
        if([request.URL.absoluteURL.absoluteString containsString:PAYMENT_URL2])
        {
            NSURL *url = [NSURL URLWithString:PAYMENT_URL2];
            _urlConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
            [_urlConnection start];
        }
        else
        {
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
            [[session dataTaskWithRequest:self.requestToSecurize] resume];
        }
        
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"=== webViewDidStartLoad");
    self.loads++;
    
    if (self.webViewLoads == 0) {
        [[MCMLoadingManager sharedInstance] showLoading];
    }
    self.webViewLoads++;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"=== webViewDidFinishLoad");
    //Added to inject javascript for skipping card choice form
    if(self.loads<=1){
        [self submitForm:webView :self.paymentMean];
        NSLog(@"JAVASCRIPT RETURN VALUE: %@", self.string);
    } else{
        self.paymentWebview.hidden = NO;
    }
   
    if ([webView.request.URL.absoluteString rangeOfString:@"about:blank"].location != NSNotFound) {
    }
    self.webViewLoads--;
    
    if (self.webViewLoads > 0) {
        return;
    } else {
        [[MCMLoadingManager sharedInstance] hideLoading];
    }
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    NSLog(@"=== didFailLoadWithError");
    self.webViewLoads--;
    if (self.webViewLoads == 0) {
       [[MCMLoadingManager sharedInstance] hideLoading];
    }
    
    if (error.code == certificateErrorCode) {
        authenticated = NO;
    }
}

- (void)determineFlowFromJsonFromResponse:(NSString *)summaryJsonUrl {
    NSURLSession *session = [NSURLSession sharedSession];
    self.webViewLoads = 10;
    // Modification La Poste 22/05/2017
    NSURLSessionConfiguration * configuration = session.configuration.copy;
    configuration.HTTPAdditionalHeaders = @{@"User-Agent" : [self userAgent]};
    NSURLSession * newSession = [NSURLSession sessionWithConfiguration:configuration delegate:session.delegate delegateQueue:session.delegateQueue];
    
    [[MCMLoadingManager sharedInstance] showLoading];
    [[newSession dataTaskWithURL:[NSURL URLWithString:summaryJsonUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[object class] isSubclassOfClass:[NSDictionary class]]) {
//                    paiymentMeans
                    NSDictionary *result = (NSDictionary *)object;
                    [result setValue:self.paymentMean forKey:@"paiymentMeans"];
                    self.finishSummary = [MCMPaymentSummaryData paymentSummaryWithParams:result cart:self.cart];
                    if (self.finishSummary.transactionStatus == Accepted) {
                        [self transitionToCallbackStatusScreenWithStatus:YES];
                        [self sendWeboramaTag];
                    } else {
                        [self transitionToCallbackStatusScreenWithStatus:NO];
                    }
                } else {
                    [self transitionToCallbackStatusScreenWithStatus:NO];
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self transitionToCallbackStatusScreenWithStatus:NO];
            });
            
        }
        
    }] resume];
}

#pragma mark - ---- ---- NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"WebController received response via NSURLConnection");
    
    authenticated = YES;
    [self.paymentWebview stopLoading];
    [self.paymentWebview loadRequest:self.requestToSecurize];
    
    [_urlConnection cancel];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ERREUR NSURLCONNECTION");
}

// Used to accept an untrusted certificate
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return (([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) &&
            ([[self.requestToSecurize.URL absoluteString] containsString:PAYMENT_URL1] || [[self.requestToSecurize.URL absoluteString] containsString:PAYMENT_URL2]) );
}



#pragma mark - ---- ---- NSURLSessionDataDelegate
// NOT USED ANYMORE SINCE 08/12/2016
- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if ([challenge previousFailureCount] == 0) {
        authenticated = YES;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        [self.paymentWebview stopLoading];
        [self.paymentWebview loadRequest:self.requestToSecurize];
        
        [task cancel];
    } else {
        [[MCMLoadingManager sharedInstance] hideLoading];
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        [task cancel];
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark - ---- ---- UIKeyboardWillShow

- (void) keyboardWillShow:(NSNotification *) notification {
    [self addOpenCardIoButton];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self removeOpenCardIoButton];
}

- (UIView *) getViewToAddCardIoButton {
    UIView *result = nil;
    UIView *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if (![[testWindow class] isEqual : [UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    // Locate UIWebFormView.
    for (UIView *possibleFormView in [keyboardWindow subviews]) {
        if ([[possibleFormView description] hasPrefix : @"<UIInputSetContainerView"]) {
            for (UIView* peripheralView in possibleFormView.subviews) {
                for (UIView* peripheralView_sub in peripheralView.subviews) {
                    // hides the accessory bar
                    if ([[peripheralView_sub description] hasPrefix : @"<UIWebFormAccessory"]) {
                        result = peripheralView_sub;
                        break;
                    }
                }
            }
        }
    }
    
    return result;
}

- (void) generateOpenCardIoButtonWithKeyboardView:(UIView *) keyboardView {
    if (!openCardIoButton) {
        openCardIoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [openCardIoButton setTitle:[MCMLocalizedStringHelper stringForKey:@"Scanner"] forState:UIControlStateNormal];
        [openCardIoButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        [openCardIoButton.titleLabel setTextColor:[[MCMStyles sharedInstance] cardIoButtonTitleColor]];
        CGFloat buttonWidth = 150.0f;
        // 80.0f for button Done
        CGFloat buttonX = keyboardView.bounds.size.width - buttonWidth - 80.0f;
        CGFloat buttonY = 0;
        buttonY = 5;
        [openCardIoButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, 30)];
        [openCardIoButton addTarget:self action:@selector(openCardIoButton_touch:)
                    forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) addOpenCardIoButton {
    UIView *keyboardView = [self getViewToAddCardIoButton];
    [self generateOpenCardIoButtonWithKeyboardView:keyboardView];
    [keyboardView addSubview:openCardIoButton];
}

- (void) removeOpenCardIoButton {
    [openCardIoButton removeFromSuperview];
    openCardIoButton = nil;
}

- (void)openCardIoButton_touch:(id)sender {
    
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [self presentViewController:scanViewController animated:YES completion:nil];
}

// Card.io delegate

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
//    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    // Use the card info...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
    	
   
    NSString *formattedNumber = [NSString stringWithFormat:@"document.getElementById('%@').value=\"%@\"", MCMCardIo_CardNumber, info.cardNumber];
    [self.paymentWebview stringByEvaluatingJavaScriptFromString:formattedNumber];
    
    NSString *monthString = [NSString stringWithFormat:@"%ld", info.expiryMonth];
    if (monthString.length == 1) {
        monthString = [NSString stringWithFormat:@"0%@", monthString];
    }
    NSString *formattedMonth  = [NSString stringWithFormat: @"document.getElementsByName('%@')[0].value=\"%@\"", MCMCardIo_CardMonth, monthString];
    [self.paymentWebview stringByEvaluatingJavaScriptFromString:formattedMonth];
    
    
    NSString *yearString = [NSString stringWithFormat:@"%ld", info.expiryYear];
    if (yearString.length == 4) {
        yearString = [yearString substringWithRange:NSMakeRange(yearString.length-2, 2)];
    }

    NSString *formattedYear = [NSString stringWithFormat:@"document.getElementsByName('%@')[0].value=\"%@\"", MCMCardIo_CardYear, yearString];
    [self.paymentWebview stringByEvaluatingJavaScriptFromString:formattedYear];
    
    NSString *formattedCVC = [NSString stringWithFormat:@"document.getElementById('%@').value=\"%@\"", MCMCardIo_CardVV, info.cvv];
    [self.paymentWebview stringByEvaluatingJavaScriptFromString:formattedCVC];
}

- (void)cardIOView:(CardIOView *)cardIOView didScanCard:(CardIOCreditCardInfo *)info {
    if (info) {
        // The full card number is available as info.cardNumber, but don't log that!
//        NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
        // Use the card info...
    }
    else {
        NSLog(@"User cancelled payment info");
        // Handle user cancellation here...
    }
    
    [cardIOView removeFromSuperview];
}

// Added on 01/18/2017 to force submitting form in first payment webview
-(void)submitForm:(UIWebView *)webView :(NSString*)paymentChoice {
    
    NSString *script = [NSString stringWithFormat:@"(function(){var f= document.getElementsByTagName('form')[0]; var X = document.createElement('input'); X.type='HIDDEN'; X.name = '%@.x'; X.value='20'; var Y = document.createElement('input'); Y.type ='HIDDEN'; Y.name='%@.y'; Y.value='29'; f.appendChild(X); f.appendChild(Y); f.submit();})();", paymentChoice, paymentChoice];

    [webView stringByEvaluatingJavaScriptFromString:script];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_IN_SECONDS * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.paymentWebview.hidden = NO;    });
    
}
                                
- (NSString *)userAgent {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *deviceModel = [[UIDevice currentDevice] model];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@;)", appName, appVersion, deviceModel, systemVersion];
    return userAgent;
}

-(void) sendWeboramaTag {
    for (HYBOrderEntry* entry in _cart.entries) {
        NSString *categoryId = ((HYBCategory *)entry.product.categories[0]).code;
        PixelWeboramaManager *manager = [[PixelWeboramaManager alloc] init];
        NSString *tag = [manager getKeyFrom:categoryId and:WeboramaActionTypeBuy];
        NSString *ccu = [manager getCcuId];
        [manager sendWeboramaTagWithTagToSend:tag ccuIDCryptedValue:ccu.getSHA256];
    }
}
    

@end
