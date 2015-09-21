//
//  SYTarget.m
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 04/08/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYTarget.h"
#import <XcodeEditor.h>
#import <XcodeEditor/XCProjectBuildConfig.h>
#import "SYBuildVar.h"
#import "SYConsts.h"
#import "SYProject.h"

@implementation SYTarget

- (instancetype)initWithProject:(SYProject *)project name:(NSString *)name
{
    self = [super init];
    if (self)
    {
        self.project = project;
        self.name = name;
        [self updateVars];
    }
    return self;
}

- (void)updateVars
{
    self.vars = nil;
    XCProject *project = [XCProject projectWithFilePath:self.project.path];
    XCTarget *target = [project targetWithName:self.name];
    self.vars = [self buildVarsWithTarget:target];
}

- (void)setValue:(NSString *)newValue
     forBuildVar:(NSString *)buildVar
andConfiguration:(NSString *)configuration
{
    if (!newValue || !buildVar.length)
        return;
    
    XCProject *project = [XCProject projectWithFilePath:self.project.path];
    XCTarget *target = [project targetWithName:self.name];
    if (!target)
        return;
    
    NSMutableDictionary *currentValues = [NSMutableDictionary dictionary];
    for (NSString *buildConfigName in [[target configurations] allKeys])
    {
        XCProjectBuildConfig *buildConfig = [target configurationWithName:buildConfigName];
        id value = [[buildConfig specifiedBuildSettings] objectForKey:buildVar];
        [currentValues setObject:(value ?: [NSNull null]) forKey:buildConfigName];
    }
    
    if (configuration.length)
        currentValues[configuration] = newValue;
    else
    {
        for (NSString *key in [[currentValues allKeys] copy])
            [currentValues setObject:newValue forKey:key];
    }
    
    for (NSString *buildConfigName in [[target configurations] allKeys])
    {
        XCProjectBuildConfig *buildConfig = [target configurationWithName:buildConfigName];
        id value = currentValues[buildConfigName];
        if (value && ![value isEqualTo:[NSNull null]])
            [buildConfig addOrReplaceSetting:value forKey:buildVar];
    }
    
    [project save];
    [self updateVars];
}

- (void)addNewBuildVarWithName:(NSString *)name
                        values:(NSArray *)values
{
    if (!name.length || !values.count)
        return;
    
    XCProject *project = [XCProject projectWithFilePath:self.project.path];
    XCTarget *target = [project targetWithName:self.name];
    if (!target)
        return;
    
    for (XCProjectBuildConfig *buildConfig in [[target configurations] allValues])
    {
        [buildConfig addOrReplaceSetting:values[0] forKey:name];
        [buildConfig addOrReplaceSetting:[values componentsJoinedByString:[SYConsts valuesSeparator]]
                                  forKey:[name stringByAppendingString:[SYConsts valuesVariableNameSuffix]]];
        
        NSString *preprocDefinition = [NSString stringWithFormat:@"%@=$(%@)", name, name];
        NSArray *preprocDefinitions = [[buildConfig specifiedBuildSettings] objectForKey:@"GCC_PREPROCESSOR_DEFINITIONS"];
        
        // if there is only one line it will be understood as a string
        if ([preprocDefinitions isKindOfClass:[NSString class]])
            preprocDefinitions = @[preprocDefinitions];
        
        if (!preprocDefinitions.count)
        {
            preprocDefinitions = @[@"$(inherited)", preprocDefinition];
        }
        else if (preprocDefinitions.count && ![preprocDefinitions containsObject:preprocDefinition])
        {
            preprocDefinitions = [preprocDefinitions arrayByAddingObject:preprocDefinition];
        }
        [buildConfig addOrReplaceSetting:preprocDefinitions forKey:@"GCC_PREPROCESSOR_DEFINITIONS"];
    }
    
    [project save];
    [self updateVars];
}

// Find all variables that have a "name_SUFFIX" counterpart
- (NSArray *)configurableVariablesWithTarget:(XCTarget *)target
{
    NSMutableArray *candidates = [NSMutableArray array];
    for (NSString *name in [[[target defaultConfiguration] specifiedBuildSettings] allKeys])
    {
        if ([name hasSuffix:[SYConsts valuesVariableNameSuffix]])
            [candidates addObject:name];
    }
    
    NSMutableSet *varNames = [NSMutableSet set];
    for (NSString *nameValues in candidates)
    {
        NSString *name = [nameValues substringToIndex:nameValues.length - 7];
        for (XCProjectBuildConfig *conf in [[target configurations] allValues])
            if ([[conf specifiedBuildSettings] objectForKey:name])
                [varNames addObject:name];
    }
    
    return [varNames allObjects];
}

// For each configurable value: retrieve current value in each build configuration and possible values from project build settings
- (NSArray *)buildVarsWithTarget:(XCTarget *)target
{
    NSArray *varNames = [self configurableVariablesWithTarget:target];
    
    NSMutableArray *vars = [NSMutableArray array];
    for (NSString *varName in varNames)
    {
        NSDictionary *buildSettings = [[target defaultConfiguration] specifiedBuildSettings];
        SYBuildVar *var = [[SYBuildVar alloc] init];
        [var setTarget:self];
        [var setName:varName];
        [var setDefaultValue:[buildSettings objectForKey:varName]];
        
        NSString *valuesString = [buildSettings objectForKey:[varName stringByAppendingString:[SYConsts valuesVariableNameSuffix]]];
        [var setValues:[valuesString componentsSeparatedByString:[SYConsts valuesSeparator]]];
        
        NSMutableDictionary *valuesByConfig = [NSMutableDictionary dictionary];
        for (NSString *configName in [[target configurations] allKeys])
        {
            XCProjectBuildConfig *config = (id)[target configurationWithName:configName];
            NSString *value = [[config specifiedBuildSettings] objectForKey:varName];
            valuesByConfig[configName] = (value ?: @"");
        }
        
        if ([valuesByConfig count])
            [var setValueByConfigurations:[valuesByConfig copy]];
        
        [vars addObject:var];
    }
    
    return [vars copy];
}

@end
