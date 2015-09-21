//
//  SYConsts.m
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYConsts.h"

@implementation SYConsts

+ (NSString *)valuesVariableNameSuffix
{
    return @"_VALUES";
}

+ (NSString *)valuesSeparator
{
    return @";";
}

+ (NSCharacterSet *)allowedVariableNameCharacterSet
{
    NSMutableCharacterSet *allowedSet = [[NSCharacterSet letterCharacterSet] mutableCopy];
    [allowedSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [allowedSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
    return allowedSet;
}

@end
