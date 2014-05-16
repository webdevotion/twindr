//
//  Created by merowing on 16/05/2014.
//
//
//


#import <Foundation/Foundation.h>


@interface BeaconTransmitter : NSObject
@property(nonatomic, assign) NSUInteger majorVersion;
@property(nonatomic, assign) NSUInteger minorVersion;

- (instancetype)initWithIdentifier:(NSString *const)identifier uuid:(NSUUID *)uuid majorVersion:(NSUInteger)majorVersion minorVersion:(NSUInteger)minorVersion;
@end