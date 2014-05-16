//
// Copyright 2014 webdevotion. All rights reserved.
//

#import "TwitterAccountViewController.h"
#import "PromiseKit+SocialFramework.h"
#import "FakeTwindrService.h"
#import "TwindrUsersCollectionViewController.h"
#import "Promise.h"
#import "FBShimmeringView.h"
#import "View+MASAdditions.h"
#import "UIColor+Additions.h"
#import "ACAccount+Twindr.h"
#import "LocalUsersProvidingService.h"

@interface TwitterAccountViewController () <TwindrServiceDelegate>

@property(nonatomic, strong) UIImageView *avatarImage;
@property(nonatomic, strong) UILabel *loadingLabel;

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

    self.loadingLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.loadingLabel.text = @"Looking around";
    self.loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:32];
    [self.loadingLabel sizeToFit];

    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.loadingLabel.bounds];
    shimmeringView.contentView = self.loadingLabel;
    shimmeringView.shimmering = YES;
    shimmeringView.shimmeringSpeed = 100;

    [self.view addSubview:shimmeringView];

    [shimmeringView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.loadingLabel);
    }];

    UIImage* logoImage = [UIImage imageNamed:@"app-logo-text-transparent-tint"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];

    UIBarButtonItem *followBatchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(batchFollowUsers)];
    self.navigationItem.rightBarButtonItems = @[followBatchButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadAvatar];
}

- (void) batchFollowUsers {

}

- (void)loadAvatar {
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [store promiseForAccountsWithType:accountType options:nil].then(^(NSArray *accounts) {
        return accounts.lastObject;
    }).then(^(ACAccount *account) {
        self.service = [[LocalUsersProvidingService alloc] initWithAccount:account];
        self.service.delegate = self;

        self.usersViewController.account = account;

        return [account promiseForAvatarWithUsername:account.username];
    }).then(^(UIImage *image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 32, 32);
        imageView.layer.cornerRadius = 16;
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = [UIColor twindrTintColor].CGColor;
        imageView.layer.borderWidth = 1;

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];

        imageView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.3 delay:0
             usingSpringWithDamping:1 initialSpringVelocity:1
                            options:(UIViewAnimationOptions) 0
                         animations:^{
            imageView.transform = CGAffineTransformIdentity;
        }
                         completion:nil];
    });
}

#pragma mark - TwindrServiceDelegate

- (void)twindrService:(id <TwindrService>)twindrService didUpdateUsers:(NSArray *)users {
    self.usersViewController.users = users;
}

@end
