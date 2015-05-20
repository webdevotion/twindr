//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <PromiseKit/Promise.h>
#import "TwindrUsersCollectionViewController.h"
#import "TwindrUserCollectionViewCell.h"
#import "ACAccount+Twindr.h"
#import "TwindrUser.h"
#import "TwindrAvatarView.h"
#import "UIActionSheet+BlocksKit.h"



@interface TwindrUsersCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end



@implementation TwindrUsersCollectionViewController

- (id)init {
    self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    if (self) {
        self.collectionView.dataSource = self;
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
    
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"HeaderView"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        

        headerView.backgroundColor = [UIColor greenColor];
        reusableview = headerView;
    }
    
    return reusableview;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 50);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.users.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TwindrUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                                   forIndexPath:indexPath];

    id <TwindrUser> user = self.users[(NSUInteger) indexPath.row];

    [self.account promiseForAvatarWithUsername:user.username].then(^(UIImage *image) {
        NSIndexPath *currentIndexPath = [self indexPathForUsername:user.username];

        if (currentIndexPath) {
            TwindrUserCollectionViewCell *currentCell = (TwindrUserCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:currentIndexPath];

            currentCell.avatarView.image = image;
            [currentCell.avatarView appear];
        }
    });

    return cell;
}

- (NSIndexPath *)indexPathForUsername:(NSString *)username {
    for (id <TwindrUser> user in self.users) {
        if ([user.username isEqualToString:username]) {
            return [NSIndexPath indexPathForRow:[self.users indexOfObject:user] inSection:0];
        }
    }

    return nil;
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

    [self.collectionView performBatchUpdates:^{
        NSUInteger i = 0, j = 0;

        while (i < _users.count && j < users.count) {
            id <TwindrUser> old = _users[i];
            id <TwindrUser> new = users[j];

            switch ([old.username compare:new.username]) {
                case NSOrderedAscending: {
                    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
                    i++;
                    break;
                }
                case NSOrderedDescending: {
                    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:j inSection:0]]];
                    j++;
                    break;
                }
                case NSOrderedSame: {
                    i++, j++;
                    break;
                }
            }
        }

        for (NSUInteger k = i; k < _users.count; k++) {
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:k inSection:0]]];
        }

        for (NSUInteger k = j; k < users.count; k++) {
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:k inSection:0]]];
        }

        _users = [users copy];
    }
                                  completion:nil];
}

@end
