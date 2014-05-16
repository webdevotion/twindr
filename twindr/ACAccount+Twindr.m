//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <PromiseKit/Promise.h>
#import <Social/Social.h>
#import "ACAccount+Twindr.h"
#import "PromiseKit+SocialFramework.h"

@implementation ACAccount (Twindr)

- (Promise *)promiseForAvatarWithUsername:(NSString *)username {
    return [self avatarRequestForUsername:username].promise.then(^(NSData *responseData) {
        return [UIImage imageWithData:responseData];
    });
}

- (SLRequest *)avatarRequestForUsername:(NSString *)username {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:@"https://api.twitter.com/1/users/profile_image"]
                                               parameters:@{
                                                   @"screen_name" : username,
                                                   @"size" : @"bigger"
                                               }];
    request.account = self;
    return request;
}

- (void)followUser:(NSString *)userName {
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:userName forKey:@"screen_name"];
    [tempDict setValue:@"true" forKey:@"follow"];

    SLRequest *followRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST
                                                            URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"]
                                                     parameters:tempDict];

    [followRequest setAccount:self];
    [followRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    }];
}

@end
