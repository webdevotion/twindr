//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <BlocksKit/UIActionSheet+BlocksKit.h>
#import "TwitterAccountViewController.h"
#import "PromiseKit+SocialFramework.h"
#import "FakeTwindrService.h"
#import "TwindrUsersCollectionViewController.h"
#import "FBShimmeringView.h"
#import "Promise.h"
#import "ACAccount+Twindr.h"
#import "LocalUsersProvidingService.h"
#import "TwindrAvatarView.h"
#import <CocoaLumberjack/CocoaLumberjack.h>


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

    UIBarButtonItem *followBatchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                       target:self
                                                                                       action:@selector(didPressActionButton:)];
    self.navigationItem.rightBarButtonItems = @[followBatchButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadAvatar];
}

- (void)didPressActionButton:(id)didPressActionButton
{
    
    //TODO: show all available lists
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Create new list" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self batchFollowUsers];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)batchFollowUsers
{
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    __block ACAccount *blockAccount = nil;

    [store promiseForAccountsWithType:accountType options:nil].then(^(NSArray *accounts) {
        
        if ([accounts count] > 0) {
            
            DDLogWarn(@"more than one account found!");
            
            blockAccount = accounts.lastObject;
            
        } else {
            
            blockAccount = accounts.lastObject;
            
        }
    
        return accounts.lastObject;
    }).then(^(ACAccount *account) {
        
        return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Create new list" message:@"Enter name for new list" preferredStyle:UIAlertControllerStyleAlert];
            
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                
            }];
            
            
            __block NSString *listName = nil;
            [alertController addAction:[UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                UITextField *textField = alertController.textFields.firstObject;
                listName = textField.text;
                
                fulfiller( listName );
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }].then(^(NSString *aListName){
            return [account promiseForListCheck:aListName].catch(^(NSError *error) {
                return [account promiseForListCreation:aListName];
            });
        });
        
        
    }).then(^(NSString *aListName) {
        NSLog(@"list exists with name: %@", aListName);

        NSArray *usernames = [self.usersViewController.users valueForKey:@"username"];
        for (NSString *username in usernames) {
            [blockAccount promiseToAddUser:username toList:@"UIKonf Hackers 2014"].then(^(NSString *addedUsername) {
                NSLog(@"username in list: %@", addedUsername);
            });

        }
    });
}

- (void)loadAvatar {
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [store promiseForAccountsWithType:accountType options:nil].then(^(NSArray *accounts) {
        return accounts.lastObject;
    }).then(^(ACAccount *account) {
        self.service = [[LocalUsersProvidingService alloc] initWithAccount:account];
//        self.service = [[FakeTwindrService alloc] initWithAccount:account];
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
