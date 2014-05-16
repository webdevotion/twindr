//
//  AppDelegate.m
//  twindr
//
//  Created by Krzysztof Zabłocki on 16/05/2014.
//  Copyright (c) 2014 webdevotion. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate () <CLLocationManagerDelegate, CBPeripheralManagerDelegate>
@property(nonatomic, strong) CBPeripheralManager *manager;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLBeaconRegion *beaconRegion;
@property(nonatomic, strong) CLBeaconRegion *iBeacon;
@property(nonatomic, strong) NSUUID *const uuid;
@property(nonatomic, strong) NSString *const identifier;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [UIViewController new];
  [self.window addSubview:self.window.rootViewController.view];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];


  [self setupBeacons];
  return YES;
}

- (void)setupBeacons
{
  self.identifier = @"pl.twindr";
  self.uuid = [[NSUUID alloc] initWithUUIDString:@"2411CF47-9DFE-4E33-8BC7-0675AD06C2A5"];
  [self startAdvertising];
  [self startMonitoring];
}

- (void)startAdvertising
{
  self.iBeacon = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:1 minor:(CLBeaconMinorValue)arc4random_uniform(1000) identifier:self.identifier];
  NSLog(@"region created with %@ %@ %@", self.iBeacon.proximityUUID, self.iBeacon.major, self.iBeacon.minor);
  self.manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
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

- (void)startMonitoring
{
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid identifier:self.identifier];
  [self.locationManager startMonitoringForRegion:self.beaconRegion];
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];

  NSLog(@"start monitoring");
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
  NSLog(@"did Enter");
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
  [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
  NSLog(@"exit region");
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

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
