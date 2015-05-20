//
// Copyright 2014 Taptera Inc. All rights reserved.
//


#import <Accounts/Accounts.h>
#import <PromiseKit/Promise.h>
#import "LocalUsersProvidingService.h"
#import "BeaconManager.h"
#import "ParseService.h"
#import "LocalUser.h"

const NSInteger kMajorVersion = 1;

@interface LocalUsersProvidingService ()
@property(nonatomic, strong) ACAccount *account;
@property(nonatomic, strong) ParseService *parseService;
@property(nonatomic, strong) BeaconManager *beaconsManager;
@property(nonatomic, strong) NSArray *localUsers;
@end

@implementation LocalUsersProvidingService
@synthesize delegate;

- (id)initWithAccount:(ACAccount *)account {
    self = [super init];
    if (self) {
        self.localUsers = @[];

        self.account = account;
        self.beaconsManager = [BeaconManager sharedInstance];
        self.parseService = [ParseService new];

        [self registerForBeaconUpdates];
        [self registerAccountAndStartBroadcasting:self.account];
        [self.beaconsManager startMonitoring];
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

- (void)registerForBeaconUpdates {
    typeof(self) __weak __block weakSelf = self;
    self.beaconsManager.foundBeaconBlock = ^(NSUInteger majorVersion, NSUInteger minorVersion) {
        [weakSelf promiseForUpdatingLocalUsers:weakSelf.localUsers withFoundBeaconMinorVersion:minorVersion].then(^(NSArray *newLocalUsers) {
            if (newLocalUsers) {
                weakSelf.localUsers = newLocalUsers;
                [weakSelf.delegate twindrService:weakSelf didUpdateUsers:weakSelf.localUsers];
            }
        });
    };
}

- (Promise *)promiseForUpdatingLocalUsers:(NSArray *)localUsers withFoundBeaconMinorVersion:(NSUInteger)minorVersion {
    return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSUInteger index = [localUsers indexOfObjectPassingTest:^BOOL(LocalUser *user, NSUInteger idx, BOOL *stop) {
                return user.minorVersion == minorVersion;
            }];
            if (index != NSNotFound) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fulfiller(nil);
                });
                return;
            }

            [self.parseService promiseForUserWithMinorVersion:minorVersion].then(^(NSString *username) {
                LocalUser *localUser = [LocalUser new];
                localUser.username = username;
                localUser.minorVersion = minorVersion;
                NSArray *newLocalUsers = [localUsers arrayByAddingObject:localUser];
                newLocalUsers = [newLocalUsers sortedArrayUsingDescriptors:[self localUsersSortDescriptors]];
                fulfiller(newLocalUsers);
            });
        });
    }];
}

- (NSArray *)localUsersSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"username"
                                           ascending:YES]];
}

@end
