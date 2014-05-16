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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self fakeUpdate];
        });
    }

    return self;
}

- (void)fakeUpdate {
    NSArray *users = @[
            [FakeTwindrUser userWithUsername:@"uikonf"],
            [FakeTwindrUser userWithUsername:@"warcholuke"],
            [FakeTwindrUser userWithUsername:@"marcoarment"],
            [FakeTwindrUser userWithUsername:@"_davidsmith"]
    ];

    [self.delegate twindrService:self didUpdateUsers:users];
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