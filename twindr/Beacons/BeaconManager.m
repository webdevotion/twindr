//
//  Created by merowing on 16/05/2014.
//
//
//


#import "BeaconManager.h"
#import "BeaconMonitor.h"
#import "BeaconTransmitter.h"

static NSString *const identifier = @"pl.twindr";
static NSString *const uuid = @"2411CF47-9DFE-4E33-8BC7-0675AD06C2A5";

@interface BeaconManager ()
@property(nonatomic, strong) BeaconMonitor *monitor;
@property(nonatomic, strong) BeaconTransmitter *transmitter;
@end

@implementation BeaconManager

+ (instancetype)sharedInstance
{
  static dispatch_once_t onceToken;
  static BeaconManager *singleton;
  dispatch_once(&onceToken, ^{
    singleton = [[BeaconManager alloc] init];
  });

  return singleton;
}

- (void)startMonitoring
{
  self.monitor = [[BeaconMonitor alloc] initWithIdentifier:identifier uuid:[[NSUUID alloc] initWithUUIDString:uuid]];
}

- (void)startTransmittingWithMajorVersion:(NSUInteger)majorVersion minorVersion:(NSUInteger)minorVersion
{
  self.transmitter = [[BeaconTransmitter alloc] initWithIdentifier:identifier uuid:[[NSUUID alloc] initWithUUIDString:uuid] majorVersion:majorVersion minorVersion:minorVersion];
}

@end