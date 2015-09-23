//
//  SYProject+List.h
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYProject.h"

@interface SYProject (List)

+ (NSArray *)projectsPathInCurrentWorkspace;
+ (NSArray *)projectsInCurrentWorkspace;

@end
