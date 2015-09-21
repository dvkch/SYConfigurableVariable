//
//  SYBuildVar.h
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYTarget;

@interface SYBuildVar : NSObject

@property (nonatomic, strong) SYTarget      *target;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSArray       *values;
@property (nonatomic, strong) NSString      *defaultValue;
@property (nonatomic, strong) NSDictionary  *valueByConfigurations;

- (NSString *)valueForConfigurationName:(NSString *)configName;

@end
