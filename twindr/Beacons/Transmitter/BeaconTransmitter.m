//
//  Created by merowing on 16/05/2014.
//
//
//


#import "BeaconTransmitter.h"

@import CoreBluetooth;
@import CoreLocation;

@interface BeaconTransmitter () <CBPeripheralManagerDelegate>
@property(nonatomic, strong) CLBeaconRegion *iBeacon;
@property(nonatomic, strong) CBPeripheralManager *manager;
@property(nonatomic, strong) NSUUID *uuid;
@property(nonatomic, copy) NSString *identifier;

@end

@implementation BeaconTransmitter
- (instancetype)initWithIdentifier:(NSString *const)identifier uuid:(NSUUID *)uuid majorVersion:(NSUInteger)majorVersion minorVersion:(NSUInteger)minorVersion
{
  self = [super init];
  if (!self) {
    return nil;
  }

  _uuid = uuid;
  _identifier = identifier;
  _majorVersion = majorVersion;
  _minorVersion = minorVersion;
  [self startAdvertising];

  return self;
}

- (void)startAdvertising
{
  self.iBeacon = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:(CLBeaconMajorValue)self.majorVersion minor:(CLBeaconMinorValue)self.minorVersion identifier:self.identifier];
  self.manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
  NSLog(@"region created with %@ %@ %@ %@", self.iBeacon.proximityUUID, self.iBeacon.major, self.iBeacon.minor, self.identifier);
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
  if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
    NSLog(@"start broadcast");
    [self.manager startAdvertising:[self.iBeacon peripheralDataWithMeasuredPower:0]];
  }
  else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
    NSLog(@"stop broadcast");
    [self.manager stopAdvertising];
  }
  else if (peripheral.state == CBPeripheralManagerStateUnsupported) {
    NSLog(@"You are too poor for iBeacon");
  }
}
@end