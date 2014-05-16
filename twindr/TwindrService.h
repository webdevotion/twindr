//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TwindrServiceDelegate;

@protocol TwindrService <NSObject>

- (instancetype)initWithAccount:(ACAccount *)account;

@property(nonatomic, weak) id <TwindrServiceDelegate> delegate;

@end

@protocol TwindrServiceDelegate <NSObject>

- (void)twindrService:(id <TwindrService>)twindrService didUpdateUsers:(NSArray *)users;

@end
