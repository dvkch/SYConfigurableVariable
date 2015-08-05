//
//  SYConfig.m
//  SampleProject
//
//  Created by Stan Chevallier on 31/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYConfig.h"

// little trick to convert a preprocessor macro string value to a C string
#define str(s) #s
#define xstr(s) str(s)

// Possible cases
typedef enum : NSUInteger {
    SYConfigTypeUnknown,
    SYConfigTypeDev,
    SYConfigTypeStaging,
    SYConfigTypeProduction,
} SYConfigType;

@implementation SYConfig

// Determine the current environment
+ (SYConfigType)configType
{
    NSString *varConfig = [NSString stringWithUTF8String:xstr(ENVIRONMENT)];
    if ([varConfig isEqualToString:@"DEV"])         return SYConfigTypeDev;
    if ([varConfig isEqualToString:@"STAGING"])     return SYConfigTypeStaging;
    if ([varConfig isEqualToString:@"PRODUCTION"])  return SYConfigTypeProduction;
    return SYConfigTypeUnknown;
}

// Determine host based on the current configuration
+ (NSString *)host
{
    switch ([self configType]) {
        case SYConfigTypeDev:        return @"https://dev.server.com";
        case SYConfigTypeStaging:    return @"https://staging.server.com";
        case SYConfigTypeProduction: return @"https://production.server.com";
        case SYConfigTypeUnknown:    return @"Unknown server!";
    }
    return nil;
}

@end
