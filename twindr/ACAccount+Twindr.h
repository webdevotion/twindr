//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@class Promise;

@interface ACAccount (Twindr)

- (Promise *)promiseForAvatarWithUsername:(NSString *)username;

- (void)followUser:(NSString *)userName;

@end
