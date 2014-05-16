//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Accounts;

@protocol TwindrServiceDelegate;

@protocol TwindrService <NSObject>

- (instancetype)initWithAccount:(ACAccount *)account;

@property(nonatomic, weak) id <TwindrServiceDelegate> delegate;

@end

@protocol TwindrServiceDelegate <NSObject>

/// Delivers the list of users conforming to TwindrUser protocol.
- (void)twindrService:(id <TwindrService>)twindrService didUpdateUsers:(NSArray *)users;

@end
