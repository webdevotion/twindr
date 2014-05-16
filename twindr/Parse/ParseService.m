//
// Copyright 2014 Taptera Inc. All rights reserved.
//


#import "ParseService.h"
#import "Promise.h"
#import <Parse-iOS-SDK/Parse.h>

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

- (Promise *)promiseForFindingMinorVersionForUser:(NSString *)userName
{
  return [Promise new:^(PromiseResolver fulfiller, PromiseResolver rejecter) {
    PFQuery *query = [PFQuery queryWithClassName:@"TUser"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
          rejecter(error);
          return;
        }

        const NSUInteger userNameIndex = [[objects valueForKeyPath:@"username"] indexOfObject:userName];
        if (userNameIndex != NSNotFound) {
          fulfiller([objects[userNameIndex] objectForKey:@"minor"]);
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
  minor = [[[sortedUsers lastObject] valueForKeyPath:@"minor"] integerValue] + 1;

  PFObject *query = [PFObject objectWithClassName:@"TUser"];
  query[@"username"] = userName;
  query[@"minor"] = @(minor);
  [query save];
  return @(minor);
}

@end
