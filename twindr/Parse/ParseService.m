//
// Copyright 2014 Taptera Inc. All rights reserved.
//


#import "ParseService.h"
#import <Parse-iOS-SDK/Parse.h>

NSString *const kParseApplicationId = @"Qd5Vtwn22VON98EhqWEh9Tfor5Ze1krzVFrbQIfc";
NSString *const kParseClientKey = @"6w7OZPLPGaIQlh8KAPFUmjjVVVdbvyFyI2lqvWzz";

@implementation ParseService

- (id)init {
    self = [super init];
    if (self) {
        [self configureParse];
    }
    return self;
}

- (void)configureParse {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [Parse setApplicationId:kParseApplicationId clientKey:kParseClientKey];
    });
}

@end
