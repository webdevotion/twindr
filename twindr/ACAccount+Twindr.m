//
// Copyright 2014 webdevotion. All rights reserved.
//

#import <PromiseKit/Promise.h>
#import <Social/Social.h>
#import "ACAccount+Twindr.h"
#import "PromiseKit+SocialFramework.h"
#import "NSString+RAInflections.h"


@implementation ACAccount (Twindr)

- (Promise *)promiseForAvatarWithUsername:(NSString *)username {
    return [self avatarRequestForUsername:username].promise.then(^(NSData *responseData) {
        return [UIImage imageWithData:responseData];
    });
}

- (Promise *)promiseForListCreation:(NSString *)listName {
    return [self createListForCurrentUser:listName].promise.then(^(NSData *responseData) {
        
        NSString *jsonString    = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSArray *jsonObject     = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];

        
        return [jsonObject valueForKey:@"name"];
    });
}

- (Promise *)promiseForListCheck:(NSString *)listName {
    return [self checkIfListExistsForCurrentUser:listName].promise.then(^(NSData *responseData) {
        
        NSString *jsonString    = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSArray *jsonObject     = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:0 error:NULL];

        
        return [jsonObject valueForKey:@"name"];
    });
}

- (Promise *)promiseToAddUser:(NSString *)username toList:(NSString *)listName {
    return [self addUser:username toList:listName].promise.then(^(NSData *responseData) {
        
        NSString *jsonString    = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSArray *jsonObject     = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:0 error:NULL];
        
        
        return [jsonObject valueForKey:@"name"];
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
                                                            URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"]
                                                     parameters:tempDict];

    [followRequest setAccount:self];
    [followRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
      NSLog(@"response from followUser: %@", urlResponse.description );
    }];
}

- (SLRequest *)createListForCurrentUser:(NSString *)listName {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST
                                                      URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/lists/create.json"]
                                               parameters:@{
                                                            @"name" : listName,
                                                            @"mode" : @"public",
                                                            @"description" : @""
                                                            }];
    request.account = self;
    return request;
}


- (SLRequest *)checkIfListExistsForCurrentUser:(NSString *)listName {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/lists/show.json"]
                                               parameters:@{
                                                            @"slug" : [listName slugalize],
                                                            @"owner_screen_name" : self.username
                                                            }];
    request.account = self;
    return request;
}

- (SLRequest *)addUser:(NSString *)username toList:(NSString *)listName {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST
                                                      URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/lists/members/create.json"]
                                               parameters:@{
                                                            @"slug" : [listName slugalize],
                                                            @"owner_screen_name" : self.username,
                                                            @"screen_name" : username
                                                            }];

    request.account = self;
    return request;
}

@end