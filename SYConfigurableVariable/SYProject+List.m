//
//  SYProject+List.m
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYProject+List.h"
#import <AppKit/AppKit.h>

@implementation SYProject (List)

+ (NSArray *)projectsPathInCurrentWorkspace
{
    // See https://github.com/luisobo/Xcode-RuntimeHeaders/blob/master/IDEKit/IDEWorkspaceWindowController.h
    
    Class IDEWorkspaceWindowControllerClass = NSClassFromString(@"IDEWorkspaceWindowController");
    if (!IDEWorkspaceWindowControllerClass)
        return nil;
    
    if (![(id<NSObject>)IDEWorkspaceWindowControllerClass respondsToSelector:NSSelectorFromString(@"workspaceWindowControllers")])
        return nil;
    
    NSArray *workspaceWindowControllers = [IDEWorkspaceWindowControllerClass valueForKey:@"workspaceWindowControllers"];
    
    id currentWorkspace;
    for (id controller in workspaceWindowControllers)
    {
        @try {
            NSWindow *window = [controller valueForKey:@"window"];
            if ([window isEqual:[NSApp keyWindow]])
                currentWorkspace = [controller valueForKey:@"_workspace"];
        }
        @catch (NSException *exception) {
            NSLog(@"Caught exception: %@", exception);
            continue;
        }
    }
    
    NSString *currentDocument;
    @try {
        id representingFilePath = [currentWorkspace valueForKey:@"representingFilePath"];
        currentDocument = [representingFilePath valueForKey:@"_pathString"];
    }
    @catch (NSException *exception) {
        NSLog(@"Caught exception: %@", exception);
    }
    
    if (!currentDocument)
        return nil;
    
    if ([currentDocument hasSuffix:@"xcodeproj"])
        return @[currentDocument];
    
    NSURL *currentDir = [[[NSURL alloc] initFileURLWithPath:currentDocument] URLByDeletingLastPathComponent];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fm enumeratorAtURL:currentDir
                                 includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                    options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
                                               errorHandler:nil];
    
    NSMutableArray *projects = [NSMutableArray array];
    for (NSURL *fileURL in enumerator)
    {
        NSString *filename;
        [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
        
        NSNumber *isDirectory;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        if ([isDirectory boolValue] && [filename hasSuffix:@"xcodeproj"])
            [projects addObject:[fileURL path]];
    }
    
    return [projects copy];
}

+ (NSArray *)projectsInCurrentWorkspace
{
    NSMutableArray *projects = [NSMutableArray array];
    for (NSString *path in [self projectsPathInCurrentWorkspace])
    {
        [projects addObject:[[self alloc] initWithPath:path]];
    }
    return [projects copy];
}

@end
