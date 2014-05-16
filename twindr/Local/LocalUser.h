//
// Copyright 2014 Taptera Inc. All rights reserved.
//


#import "TwindrUser.h"


@interface LocalUser : NSObject<TwindrUser>

@property(nonatomic, strong) NSString *username;

@property(nonatomic, assign) NSUInteger minorVersion;

@end
