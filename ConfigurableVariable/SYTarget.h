//
//  SYTarget.h
//  ConfigurableVariable
//
//  Created by Stan Chevallier on 04/08/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYProject;

@interface SYTarget : NSObject

@property (nonatomic, strong) SYProject *project;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *vars;

- (instancetype)initWithProject:(SYProject *)project name:(NSString *)name;

- (void)setValue:(NSString *)value
     forBuildVar:(NSString *)buildVar
andConfiguration:(NSString *)configuration;

- (void)addNewBuildVarWithName:(NSString *)name
                        values:(NSArray *)values;


@end
