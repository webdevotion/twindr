//
// Copyright 2014 webdevotion. All rights reserved.
//

#import "TwindrAvatarView.h"
#import "UIColor+Additions.h"


@implementation TwindrAvatarView

- (instancetype)initWithSize:(CGFloat)size {
    self = [super initWithFrame:CGRectMake(0, 0, size, size)];
    if (self) {
        self.layer.cornerRadius = (CGFloat) (size * 0.5);
        self.clipsToBounds = YES;
        self.layer.borderColor = [UIColor twindrTintColor].CGColor;
        self.layer.borderWidth = 1;
    }

    return self;
}

- (void)appear {
    self.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.3 delay:0
         usingSpringWithDamping:1 initialSpringVelocity:1
                        options:(UIViewAnimationOptions) 0
                     animations:^{
        self.transform = CGAffineTransformIdentity;
    }
                     completion:nil];
}

@end