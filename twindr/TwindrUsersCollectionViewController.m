//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <PromiseKit/Promise.h>
#import "TwindrUsersCollectionViewController.h"
#import "TwindrUserCollectionViewCell.h"
#import "ACAccount+Twindr.h"
#import "TwindrUser.h"
#import "PromiseKit+UIKit.h"
#import "TwindrAvatarView.h"
#import "UIActionSheet+BlocksKit.h"


@implementation TwindrUsersCollectionViewController

- (id)init {
    self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    if (self) {

    }

    return self;
}

- (UICollectionViewFlowLayout *)flowLayout {
    return (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.flowLayout.itemSize = CGSizeMake(80, 80);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);

    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.collectionView registerClass:[TwindrUserCollectionViewCell class]
            forCellWithReuseIdentifier:@"Cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.users.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TwindrUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                                   forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];

    id <TwindrUser> user = self.users[(NSUInteger) indexPath.row];

    [self.account promiseForAvatarWithUsername:user.username].then(^(UIImage *image) {
        cell.avatarView.image = image;
        [cell.avatarView appear];
    });

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id <TwindrUser> user = self.users[(NSUInteger) indexPath.row];
    UIActionSheet* actionSheet = [UIActionSheet bk_actionSheetWithTitle:[NSString stringWithFormat:@"@%@", user.username]];
    [actionSheet bk_addButtonWithTitle:@"Follow" handler:^{
        [self.account followUser:user.username];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
    [actionSheet showInView:self.view];
}

- (void)setUsers:(NSArray *)users {
    _users = [users copy];
    [self.collectionView reloadData];
}

@end
