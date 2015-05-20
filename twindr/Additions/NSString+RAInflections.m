//
//  NSString+RAInflections.m
//  twindr
//
//  Created by same on 20.05.15.
//  Copyright (c) 2015 webdevotion. All rights reserved.
//

#import "NSString+RAInflections.h"

@implementation NSString (RAInflections)

/**
 * Port of the slugalized helper created by @henrik
 * https://github.com/RobertAudi/slugalizer
 */
- (NSString *)slugalize
{
    NSString        *separator        = @"-";
    NSMutableString *slugalizedString = nil;
    NSRange         replaceRange      = NSMakeRange(0, self.length);
    
    // Remove all non ASCII characters
    NSError *nonASCIICharsRegexError = nil;
    NSRegularExpression *nonASCIICharsRegex = [NSRegularExpression regularExpressionWithPattern:@"[^\\x00-\\x7F]+"
                                                                                        options:0
                                                                                          error:&nonASCIICharsRegexError];
    slugalizedString = [[nonASCIICharsRegex stringByReplacingMatchesInString:self
                                                                     options:0
                                                                       range:replaceRange
                                                                withTemplate:@""] mutableCopy];
    
    // Turn non-slug characters into separators
    NSError *nonSlugCharactersError = nil;
    NSRegularExpression *nonSlugCharactersRegex = [NSRegularExpression regularExpressionWithPattern:@"[^a-z0-9\\-_\\+]+"
                                                                                            options:NSRegularExpressionCaseInsensitive
                                                                                              error:&nonSlugCharactersError];
    slugalizedString = [[nonSlugCharactersRegex stringByReplacingMatchesInString:slugalizedString
                                                                         options:0
                                                                           range:replaceRange
                                                                    withTemplate:separator] mutableCopy];
    
    // No more than one of the separator in a row
    NSError *repeatingSeparatorsError = nil;
    NSRegularExpression *repeatingSeparatorsRegex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"%@{2,}", separator]
                                                                                              options:0
                                                                                                error:&repeatingSeparatorsError];
    
    slugalizedString = [[repeatingSeparatorsRegex stringByReplacingMatchesInString:slugalizedString
                                                                           options:0
                                                                             range:replaceRange
                                                                      withTemplate:separator] mutableCopy];
    
    // Remove leading/trailing separator
    slugalizedString = [[slugalizedString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:separator]] mutableCopy];
    
    return [slugalizedString lowercaseString];
}

@end
