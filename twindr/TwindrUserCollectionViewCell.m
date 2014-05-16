//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "TwindrUserCollectionViewCell.h"
#import "TwindrAvatarView.h"


@implementation TwindrUserCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.avatarView = [[TwindrAvatarView alloc] initWithSize:76];
        [self.contentView addSubview:self.avatarView];

        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }

    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.avatarView.image = nil;
}

@end