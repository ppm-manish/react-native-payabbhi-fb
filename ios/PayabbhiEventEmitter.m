
//
//  PayabbhiEventEmitter.m
//  PayabbhiFb
//
//  Created by Manish Kumar on 10/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "PayabbhiEventEmitter.h"
#import <Payabbhi/Payabbhi-Swift.h>

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>


@implementation PayabbhiEventEmitter

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
     @"Payabbhi::PAYMENT_SUCCESS",
     @"Payabbhi::PAYMENT_ERROR"
    ];
}

- (void)startObserving {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paymentSuccess:)
                                                 name:@"PAYMENT_SUCCESS"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paymentError:)
                                                 name:@"PAYMENT_ERROR"
                                               object:nil];
}

- (void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)paymentSuccess:(NSNotification *)notification {
    [self sendEventWithName:@"Payabbhi::PAYMENT_SUCCESS"
                       body:notification.userInfo];
}

- (void)paymentError:(NSNotification *)notification {
    [self sendEventWithName:@"Payabbhi::PAYMENT_ERROR"
                       body:notification.userInfo];
}

+ (void)onPaymentSuccess:(NSDictionary *)paymentResponse {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYMENT_SUCCESS"
                                                        object:nil
                                                      userInfo:paymentResponse];
}

+ (void)onPaymentError:(int)code
           andMessage:(NSString *)message {
    NSDictionary *payload = @{
      @"code" : @(code),
      @"message" : message
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYMENT_ERROR"
                                                        object:nil
                                                      userInfo:payload];
}

@end
