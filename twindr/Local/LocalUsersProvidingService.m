//
// Copyright 2014 Taptera Inc. All rights reserved.
//


#import <Accounts/Accounts.h>
#import "LocalUsersProvidingService.h"
#import "BeaconManager.h"


@interface LocalUsersProvidingService ()
@property(nonatomic, strong) ACAccount *account;
@end

@implementation LocalUsersProvidingService
@synthesize delegate;

- (id)initWithAccount:(ACAccount *)account {
    self = [super init];
    if (self) {
        self.account = account;
    }
    return self;
}


@end
