//
//  SYBuildVar.m
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYBuildVar.h"

@implementation SYBuildVar

- (NSString *)valueForConfigurationName:(NSString *)configName
{
    return self.valueByConfigurations[configName] ?: self.defaultValue;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, name: %@, default: %@, byConfig: %@, possibilies: %@>",
            [self class],
            self,
            self.name,
            self.defaultValue,
            self.valueByConfigurations,
            [self.values componentsJoinedByString:@"|"]];
}

@end
