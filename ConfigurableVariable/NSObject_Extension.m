//
//  NSObject_Extension.m
//  ConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//


#import "NSObject_Extension.h"
#import "SYConfigurableVariablePlugin.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            [SYConfigurableVariablePlugin setSharedPlugin:[[SYConfigurableVariablePlugin alloc] initWithBundle:plugin]];
        });
    }
}
@end
