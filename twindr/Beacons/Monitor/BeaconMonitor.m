//
//  Created by merowing on 16/05/2014.
//
//
//


#import "BeaconMonitor.h"

@import CoreBluetooth;
@import CoreLocation;

@interface BeaconMonitor () <CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLBeaconRegion *beaconRegion;
@property(nonatomic, strong) NSUUID *uuid;
@property(nonatomic, copy) NSString *identifier;
@end

@implementation BeaconMonitor

- (instancetype)initWithIdentifier:(NSString *const)identifier uuid:(NSUUID *)uuid
{
  self = [super init];
  if (!self) {
    return nil;
  }

  _uuid = uuid;
  _identifier = identifier;
  [self startMonitoring];

  return self;
}

- (void)startMonitoring
{
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid identifier:self.identifier];
  [self.locationManager startMonitoringForRegion:self.beaconRegion];
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];

  NSLog(@"start monitoring %@ %@", self.uuid, self.identifier);
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
  NSLog(@"locationManager:didEnter");
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
  NSLog(@"locationManager:didExit");
  [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
  // Beacon found!
  CLBeacon *foundBeacon = [beacons firstObject];

  // You can retrieve the beacon data from its properties
  NSString *uuid = foundBeacon.proximityUUID.UUIDString;
  NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
  NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
  NSLog(@"Beacons found, %@ %@ %@", uuid, major, minor);
}
@end