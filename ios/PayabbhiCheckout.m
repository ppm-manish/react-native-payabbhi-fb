//
//  PayabbhiCheckout.m
//  PayabbhiFb
//
//  Created by Manish Kumar on 10/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "PayabbhiCheckout.h"
#import "PayabbhiEventEmitter.h"

#import <Payabbhi/Payabbhi-Swift.h>
#import <React/RCTLog.h>

@interface PayabbhiCheckout() <PaymentCallback>

@end

@implementation PayabbhiCheckout

Payabbhi *payabbhi;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(open:(NSDictionary *)options) {
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSString *accessID = (NSString *)[options objectForKey:@"access_id"];
    
    NSLog(@"AccessID %@", accessID);
    
    payabbhi = [[Payabbhi alloc] initWithAccessID:accessID delegate:self.viewController pluginDelegate:self];
    
    NSLog(@"Options: %@", options);

    PayabbhiError *error = nil;

    error = [payabbhi openWithOptions: options];
    if (error != nil) {
      NSLog(@"%@", error.getMessage);
      NSLog(@"%ld", (long)error.getCode);
      /**
      * Add logic here to handle any error while opening the Checkout form
      */
    }
  });
}

- (void)onPaymentSuccessWithPaymentResponse:(PaymentResponse *)paymentResponse {
  NSDictionary *payload = @{
    @"order_id" : paymentResponse.getOrderID,
    @"payment_id" : paymentResponse.getPaymentID,
    @"payment_signature" : paymentResponse.getPaymentSignature,
  };
  [PayabbhiEventEmitter onPaymentSuccess:payload];
}

- (void)onPaymentErrorWithCode:(NSInteger)code message:(NSString *)message {
  [PayabbhiEventEmitter onPaymentError:(int)code andMessage:message];
}

//RCTUtils.m
- (UIViewController *__nullable) viewController {
  if (RCTRunningInAppExtension()) {
    return nil;
  }

  UIViewController *controller = RCTKeyWindow().rootViewController;
  UIViewController *presentedController = controller.presentedViewController;
  while (presentedController && ![presentedController isBeingDismissed]) {
    controller = presentedController;
    presentedController = controller.presentedViewController;
  }

  return controller;
}

@end
