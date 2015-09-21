//
//  SYProject.m
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYProject.h"
#import "XcodeEditor.h"
#import "XCProjectBuildConfig.h"
#import "SYBuildVar.h"
#import "SYConsts.h"
#import "SYTarget.h"

@implementation SYProject

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self)
    {
        self.path = path;
        self.name = [[path lastPathComponent] stringByDeletingPathExtension];
        
        XCProject *xcProject = [XCProject projectWithFilePath:self.path];
        NSMutableArray *targets = [NSMutableArray array];
        for (XCTarget *xcTarget in [xcProject targets])
            [targets addObject:[[SYTarget alloc] initWithProject:self name:xcTarget.name]];

        self.targets = [targets copy];
    }
    return self;
}

@end
