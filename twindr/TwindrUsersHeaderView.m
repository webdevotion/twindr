//
//  TwindrUsersHeaderView.m
//  Twindr
//
//  Created by same on 20.05.15.
//  Copyright (c) 2015 webdevotion. All rights reserved.
//

#import "TwindrUsersHeaderView.h"


@interface TwindrUsersHeaderView ()

@property (nonatomic) BOOL didLayoutSubviews;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *titleContainerView;
@property (nonatomic) UILabel *indicatorLabel;

@end


@implementation TwindrUsersHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.didLayoutSubviews) {
        
        [self setupViews];
        
        self.didLayoutSubviews = YES;
    }
}

- (void)setupViews
{
    self.titleContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.titleContainerView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.titleContainerView addSubview:self.titleLabel];

    self.indicatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.indicatorLabel.textColor = [UIColor whiteColor];
    self.indicatorLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    self.indicatorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorLabel.text = @"\u25BE";

    [self.titleContainerView addSubview:self.indicatorLabel];
    
    
    self.titleLabel.text = self.title;

    
    [self.titleContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-[indicatorLabel]-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:@{@"titleLabel" : self.titleLabel,
                                                                           @"indicatorLabel" : self.indicatorLabel}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=5)-[titleContainerView]-(>=5)-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:@{@"titleContainerView" : self.titleContainerView}]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleContainerView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleContainerView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];

    
    [self.titleContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.titleContainerView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [self.titleContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorLabel
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.titleContainerView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1
                                                                         constant:0]];
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = [title stringByAppendingString:@"\u25BE"];
}

@end
