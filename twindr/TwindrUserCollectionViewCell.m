//
// Copyright 2014 webdevotion. All rights reserved.
//

#import "TwindrUserCollectionViewCell.h"


@implementation TwindrUserCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.avatarImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.avatarImageView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.avatarImageView.frame = self.contentView.bounds;
}

@end