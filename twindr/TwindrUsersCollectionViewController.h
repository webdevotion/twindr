//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Accounts;

@interface TwindrUsersCollectionViewController : UICollectionViewController

@property(nonatomic, copy) NSArray *users;

@property(nonatomic, strong) ACAccount *account;

@end