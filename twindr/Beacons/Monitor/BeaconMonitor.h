//
//  Created by merowing on 16/05/2014.
//
//
//


#import <Foundation/Foundation.h>


@interface BeaconMonitor : NSObject
@property(nonatomic, copy) void (^foundBeaconBlock)(NSUInteger majorVersion, NSUInteger minorVersion);

- (instancetype)initWithIdentifier:(NSString *const)identifier uuid:(NSUUID *)uuid;
@end