//
// Copyright 2014 webdevotion. All rights reserved.
//

#import "TwitterAccountViewController.h"
#import "PromiseKit+SocialFramework.h"
#import "FakeTwindrService.h"
#import "TwindrUsersCollectionViewController.h"
#import "FBShimmeringView.h"
#import "Promise.h"
#import "ACAccount+Twindr.h"
#import "LocalUsersProvidingService.h"
#import "TwindrAvatarView.h"

@interface TwitterAccountViewController () <TwindrServiceDelegate>

@property(nonatomic, strong) UIImageView *avatarImage;
@property(nonatomic, strong) FBShimmeringView *shimmeringView;

@property(nonatomic, strong) id <TwindrService> service;

@property(nonatomic, strong) TwindrUsersCollectionViewController *usersViewController;

@end

@implementation TwitterAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = YES;

    self.title = @"Twindr";

    self.usersViewController = [[TwindrUsersCollectionViewController alloc] init];
    [self addChildViewController:self.usersViewController];

    [self.view addSubview:self.usersViewController.view];

    [self.usersViewController didMoveToParentViewController:self];

    self.avatarImage = [[UIImageView alloc] init];
    [self.view addSubview:self.avatarImage];

    UIImage *logoImage = [UIImage imageNamed:@"app-logo-text-transparent-tint"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:logoImage];

    self.shimmeringView = [[FBShimmeringView alloc] initWithFrame:titleImageView.bounds];
    self.shimmeringView.contentView = titleImageView;
    self.shimmeringView.shimmering = YES;
    self.shimmeringView.shimmeringSpeed = 100;

    self.navigationItem.titleView = self.shimmeringView;

    UIBarButtonItem *followBatchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                       target:self
                                                                                       action:@selector(batchFollowUsers)];
    self.navigationItem.rightBarButtonItems = @[followBatchButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadAvatar];
}

- (void)batchFollowUsers {

}

- (void)loadAvatar {
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [store promiseForAccountsWithType:accountType options:nil].then(^(NSArray *accounts) {
        return accounts.lastObject;
    }).then(^(ACAccount *account) {
//        self.service = [[LocalUsersProvidingService alloc] initWithAccount:account];
        self.service = [[FakeTwindrService alloc] initWithAccount:account];
        self.service.delegate = self;

        self.usersViewController.account = account;

        return [account promiseForAvatarWithUsername:account.username];
    }).then(^(UIImage *image) {
        TwindrAvatarView *avatarView = [[TwindrAvatarView alloc] initWithSize:32];
        avatarView.image = image;

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:avatarView];

        [avatarView appear];
    });
}

#pragma mark - TwindrServiceDelegate

- (void)twindrService:(id <TwindrService>)twindrService didUpdateUsers:(NSArray *)users {
    self.usersViewController.users = users;
    self.shimmeringView.shimmering = NO;
}

@end
