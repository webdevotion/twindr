//
//  Created by merowing on 16/05/2014.
//
//
//


#import <Foundation/Foundation.h>


@interface BeaconManager : NSObject
@property(nonatomic, copy) void (^foundBeaconBlock)(NSUInteger minorVersion, NSUInteger majorVersion);

+ (instancetype)sharedInstance;

- (void)startMonitoring;

- (void)startTransmittingWithMajorVersion:(NSUInteger)majorVersion minorVersion:(NSUInteger)minorVersion;


@end