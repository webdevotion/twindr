//
//  Created by merowing on 16/05/2014.
//
//
//


#import <Foundation/Foundation.h>


@interface BeaconTransmitter : NSObject
- (instancetype)initWithIdentifier:(NSString *const)identifier uuid:(NSUUID *)uuid majorVersion:(NSUInteger)majorVersion minorVersion:(NSUInteger)minorVersion;
@end