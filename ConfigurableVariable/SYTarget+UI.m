//
//  SYTarget+UI.m
//  ConfigurableVariable
//
//  Created by Stan Chevallier on 04/08/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYTarget+UI.h"
#import <AppKit/AppKit.h>
#import "SYConfigurableVariablePlugin.h"
#import "SYBuildVar+UI.h"
#import "NSAlert+UI.h"
#import "SYConsts.h"

@implementation SYTarget (UI)

- (NSMenuItem *)menuItem
{
    NSMenuItem *mainItem = [[NSMenuItem alloc] initWithTitle:self.name
                                                      action:nil
                                               keyEquivalent:@""];
    [mainItem setTarget:[SYConfigurableVariablePlugin sharedPlugin]];
    [mainItem setSubmenu:[[NSMenu alloc] initWithTitle:@""]];
    
    if (!self.vars)
    {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Can't open project"
                                                      action:nil
                                               keyEquivalent:@""];
        [item setTarget:[SYConfigurableVariablePlugin sharedPlugin]];
        [item setEnabled:NO];
        [[mainItem submenu] addItem:item];
    }
    else if (!self.vars.count)
    {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"No configurable variable found"
                                                      action:nil
                                               keyEquivalent:@""];
        [item setTarget:[SYConfigurableVariablePlugin sharedPlugin]];
        [item setEnabled:NO];
        [[mainItem submenu] addItem:item];
    }
    else
    {
        for (SYBuildVar *buildVar in self.vars)
            [[mainItem submenu] addItem:[buildVar menuItem]];
    }
    
    // Create new variable
    if (self.vars)
    {
        __weak SYTarget *wSelf = self;
        [[mainItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *itemHelp = [[NSMenuItem alloc] initWithTitle:@"New variable" action:@selector(menuItemTapped:) keyEquivalent:@""];
        [itemHelp setTarget:[SYConfigurableVariablePlugin sharedPlugin]];
        [itemHelp setRepresentedObject:^{
            [wSelf openNewVarDialog];
        }];
        [[mainItem submenu] addItem:itemHelp];
    }
    
    return mainItem;
}

- (void)openNewVarDialog
{
    [NSAlert sy_showNewVariablePromptInWindow:[NSApp keyWindow] completion:^(NSString *name, NSArray *values)
     {
         NSRange range = [name rangeOfCharacterFromSet:[[SYConsts allowedVariableNameCharacterSet] invertedSet]];
         if (range.location != NSNotFound || name.length == 0 || values.count == 0)
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [NSAlert sy_showInvalidVariableNameInWindow:[NSApp keyWindow] completion:^{
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self openNewVarDialog];
                     });
                 }];
             });
             return;
         }
         
         [self addNewBuildVarWithName:name values:values];
     }];
}

@end
