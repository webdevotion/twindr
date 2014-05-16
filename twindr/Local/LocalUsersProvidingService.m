//
// Copyright 2014 Taptera Inc. All rights reserved.
//


#import <Accounts/Accounts.h>
#import <PromiseKit/Promise.h>
#import "LocalUsersProvidingService.h"
#import "BeaconManager.h"
#import "ParseService.h"

const NSInteger kMajorVersion = 1;

@interface LocalUsersProvidingService ()
@property(nonatomic, strong) ACAccount *account;
@property(nonatomic, strong) ParseService *parseService;
@property(nonatomic, strong) BeaconManager *beaconsManager;
@end

@implementation LocalUsersProvidingService
@synthesize delegate;

- (id)initWithAccount:(ACAccount *)account {
    self = [super init];
    if (self) {
        self.account = account;
        self.beaconsManager = [BeaconManager sharedInstance];
        self.parseService = [ParseService new];

        [self registerAccountAndStartBroadcasting:self.account];
    }
    return self;
}

- (void)registerAccountAndStartBroadcasting:(ACAccount *)account {
    Promise *userMinorVersionPromise = [self.parseService promiseForFindingMinorVersionForUser:account.username];
    userMinorVersionPromise.then(^(NSNumber *minorVersion) {
        [self.beaconsManager startTransmittingWithMajorVersion:kMajorVersion
                                                  minorVersion:[minorVersion unsignedIntegerValue]];
    });
}

@end
