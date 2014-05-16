//
// Copyright 2014 webdevotion. All rights reserved.
//

#import "TwitterAccountViewController.h"
#import "PromiseKit+SocialFramework.h"
#import "Promise.h"
#import "FBShimmeringView.h"
#import "View+MASAdditions.h"


@interface TwitterAccountViewController ()

@property(nonatomic, strong) UIImageView *avatarImage;

@property(nonatomic, strong) UILabel *loadingLabel;
@end

@implementation TwitterAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadAvatar];
}

- (void)loadAvatar {
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [store promiseForAccountsWithType:accountType options:nil].then(^(NSArray *accounts) {
        return accounts.lastObject;
    }).then(^(ACAccount *account) {
        return [self avatarRequestForAccount:account].promise;
    }).then(^(NSData *responseData) {
        return [UIImage imageWithData:responseData];
    }).then(^(UIImage *image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:imageView];
    });
}

- (SLRequest *)avatarRequestForAccount:(ACAccount *)account {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:@"https://api.twitter.com/1/users/profile_image"]
                                               parameters:@{
                                                       @"screen_name" : account.username,
                                                       @"size" : @"bigger"
                                               }];
    request.account = account;
    return request;
}

@end