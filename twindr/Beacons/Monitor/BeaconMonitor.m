//
//  Created by merowing on 16/05/2014.
//
//
//


#import "BeaconMonitor.h"
#import "NSArray+BlocksKit.h"

@import CoreBluetooth;
@import CoreLocation;

@interface BeaconMonitor () <CLLocationManagerDelegate,UIAlertViewDelegate>
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

- (void)requestAlwaysAuthorization
{
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  
  // If the status is denied or only granted for when in use, display an alert
  if (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusNotDetermined ) {
    NSString *title;
    title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
    NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Settings", nil];
    [alertView show];
  }
  // The user has not enabled any location services. Request background authorization.
  else if (status == kCLAuthorizationStatusNotDetermined) {
    [self.locationManager requestAlwaysAuthorization];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    // Send the user to the Settings for this app
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:settingsURL];
  }
}

- (void)startMonitoring
{
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid identifier:self.identifier];
  [self.locationManager startMonitoringForRegion:self.beaconRegion];
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];

  NSLog(@"start monitoring %@ %@", self.uuid, self.identifier);
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self alive];
  });
}

- (void) alive;
{
  NSLog(@"I am alive in %@ = %@", self, self.foundBeaconBlock );
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self alive];
  });
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    // If you get locationManager:rangingBeaconsDidFailForRegion:withError: kCLErrorDomain 16 on iOS 7.1
    // you might need to reboot your device in order to get rid of this problem.
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
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
               inRegion:(CLBeaconRegion *)region {
    [beacons bk_each:^(CLBeacon *beacon) {
        // You can retrieve the beacon data from its properties
        NSString *uuid = beacon.proximityUUID.UUIDString;
        NSString *major = [NSString stringWithFormat:@"%@", beacon.major];
        NSString *minor = [NSString stringWithFormat:@"%@", beacon.minor];
        NSLog(@"Beacons found, %@ %@ %@", uuid, major, minor);

        if (self.foundBeaconBlock) {
            self.foundBeaconBlock(major.integerValue, minor.integerValue);
        }
    }];
}

@end
