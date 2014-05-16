//
// Copyright 2014 Taptera Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Promise;


@interface ParseService : NSObject
- (Promise *)promiseForFindingMinorVersionForUser:(NSString *)userName;
@end
