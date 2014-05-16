//
// Copyright 2014 webdevotion. All rights reserved.
//

#import "FakeTwindrService.h"

@interface FakeTwindrUser ()

@property(nonatomic, strong, readwrite) NSString *username;

+ (instancetype)userWithUsername:(NSString *)username;

@end

@implementation FakeTwindrService

@synthesize delegate;

- (instancetype)initWithAccount:(ACAccount *)account {
    self = [super init];
    if (self) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self fakeUpdate1];
        });
    }

    return self;
}

- (void)updateUsersWithUsernames:(NSArray *)usernames {
    NSMutableArray *users = [NSMutableArray array];

    for (NSString *username in usernames) {
        [users addObject:[FakeTwindrUser userWithUsername:username]];
    }

    [users sortUsingDescriptors:@[
            [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES]
    ]];

    [self.delegate twindrService:self didUpdateUsers:users];
}

- (void)fakeUpdate1 {
    [self updateUsersWithUsernames:@[@"uikonf", @"warcholuke", @"marcoarment", @"_davidsmith"]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fakeUpdate2];
    });
}

- (void)fakeUpdate2 {
    [self updateUsersWithUsernames:@[@"warcholuke", @"_davidsmith"]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fakeUpdate3];
    });
}

- (void)fakeUpdate3 {
    [self updateUsersWithUsernames:@[]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fakeUpdate4];
    });
}

- (void)fakeUpdate4 {
    [self updateUsersWithUsernames:@[@"uikonf", @"warcholuke", @"_davidsmith"]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fakeUpdate5];
    });
}

- (void)fakeUpdate5 {
    [self updateUsersWithUsernames:@[@"uikonf", @"warcholuke", @"_davidsmith", @"robertwijas"]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fakeUpdate1];
    });
}

@end

@implementation FakeTwindrUser

+ (instancetype)userWithUsername:(NSString *)username {
    return [[FakeTwindrUser alloc] initWithUsername:username];
}

- (id)initWithUsername:(NSString *)username {
    self = [super init];
    if (self) {
        self.username = username;
    }

    return self;
}


@end