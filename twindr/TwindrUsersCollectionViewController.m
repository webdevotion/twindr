//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <PromiseKit/Promise.h>
#import "TwindrUsersCollectionViewController.h"
#import "TwindrUserCollectionViewCell.h"
#import "ACAccount+Twindr.h"
#import "TwindrUser.h"


@implementation TwindrUsersCollectionViewController

- (id)init {
    self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    if (self) {

    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

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

    id<TwindrUser> user = self.users[(NSUInteger) indexPath.row];

    [self.account promiseForAvatarWithUsername:user.username].then(^(UIImage *image) {
        cell.avatarImageView.image = image;
    });

    return cell;
}

- (void)setUsers:(NSArray *)users {
    _users = [users copy];
    [self.collectionView reloadData];
}

@end