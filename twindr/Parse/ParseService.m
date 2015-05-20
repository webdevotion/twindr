//
// Copyright 2014 Taptera Inc. All rights reserved.
//


#import "ParseService.h"
#import "Promise.h"
#import <Parse/Parse.h>

NSString *const kParseApplicationId = @"Qd5Vtwn22VON98EhqWEh9Tfor5Ze1krzVFrbQIfc";
NSString *const kParseClientKey = @"6w7OZPLPGaIQlh8KAPFUmjjVVVdbvyFyI2lqvWzz";

@implementation ParseService

- (id)init
{
  self = [super init];
  if (self) {
    [self configureParse];
  }
  return self;
}

- (void)configureParse
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [Parse setApplicationId:kParseApplicationId clientKey:kParseClientKey];
  });
}

- (Promise *)promiseForUserWithMinorVersion:(NSUInteger)minorVersion
{
  return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
    PFQuery *query = [PFQuery queryWithClassName:@"TUser"];
    [query whereKey:@"minor" equalTo:@(minorVersion)];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
      if (!object) {
        rejecter(error);
        return;
      }

      fulfiller(object[@"username"]);
    }];
  }];
}

- (Promise *)promiseForFindingMinorVersionForUser:(NSString *)userName
{
  return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
    PFQuery *query = [PFQuery queryWithClassName:@"TUser"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (!objects) {
          rejecter(error);
          return;
        }

        const NSUInteger userNameIndex = [[objects valueForKeyPath:@"username"] indexOfObject:userName];
        if (userNameIndex != NSNotFound) {
          fulfiller(objects[userNameIndex][@"minor"]);
          return;
        }

        fulfiller([self findAndRegisterFreeMinorFromObjects:objects username:userName]);
      });
    }];
  }];
}

- (NSNumber *)findAndRegisterFreeMinorFromObjects:(NSArray *)users username:(NSString *)userName
{
  NSUInteger minor = 0;
  NSArray *sortedUsers = [users sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"minor" ascending:YES]]];
  minor = ([[sortedUsers lastObject][@"minor"] unsignedIntegerValue] + 1);

  PFObject *object = [PFObject objectWithClassName:@"TUser"];
  object[@"username"] = userName;
  object[@"minor"] = @(minor);
  //! TODO: maybe sync?
  [object saveEventually];
  return @(minor);
}

@end
