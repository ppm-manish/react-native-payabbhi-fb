//
//  PayabbhiEventEmitter.h
//  PayabbhiFb
//
//  Created by Manish Kumar on 10/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <React/RCTEventEmitter.h>

@interface PayabbhiEventEmitter : RCTEventEmitter

+ (void)onPaymentSuccess:(NSDictionary *)paymentResponse;

+ (void)onPaymentError:(int)code
            andMessage:(NSString *)message;

@end

