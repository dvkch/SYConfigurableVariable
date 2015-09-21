//
//  SYProject+UI.m
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYProject+UI.h"
#import "SYBuildVar+UI.h"
#import <AppKit/AppKit.h>
#import "SYConfigurableVariablePlugin.h"
#import "NSAlert+UI.h"
#import "SYConsts.h"
#import "SYTarget+UI.h"
#import "NSMenu+UI.h"

@implementation SYProject (UI)

- (NSMenuItem *)menuItem
{
    NSMenuItem *mainItem = [[NSMenuItem alloc] initWithTitle:self.name
                                                      action:nil
                                               keyEquivalent:@""];
    [mainItem setTarget:[SYConfigurableVariablePlugin sharedPlugin]];
    [mainItem setSubmenu:[[NSMenu alloc] initWithTitle:@""]];
    
    if (!self.targets)
    {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Can't open project"
                                                      action:nil
                                               keyEquivalent:@""];
        [item setTarget:[SYConfigurableVariablePlugin sharedPlugin]];
        [item setEnabled:NO];
        [[mainItem submenu] addItem:item];
    }
    else if (!self.targets.count)
    {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"No target found"
                                                      action:nil
                                               keyEquivalent:@""];
        [item setTarget:[SYConfigurableVariablePlugin sharedPlugin]];
        [item setEnabled:NO];
        [[mainItem submenu] addItem:item];
    }
    else if (self.targets.count == 1)
    {
        NSMenu *targetMenu = [[self.targets[0] menuItem] submenu];
        [[mainItem submenu] stealItemsFromMenu:targetMenu];
    }
    else
    {
        for (SYTarget *target in self.targets)
            [[mainItem submenu] addItem:[target menuItem]];
    }

    return mainItem;
}

@end
