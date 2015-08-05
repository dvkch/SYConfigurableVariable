//
//  SYInfoPlist.h
//  ConfigurableVariable
//
//  Created by Stan Chevallier on 04/08/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYInfoPlist : NSObject

+ (void)addBuildVarWithName:(NSString *)buildVarName toInfoPlistAtPath:(NSString *)infoPlistPath;

@end
