//
//  SYBuildVar+UI.m
//  ConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYBuildVar+UI.h"
#import <AppKit/AppKit.h>
#import "SYConfigurableVariablePlugin.h"
#import "SYTarget.h"

@implementation SYBuildVar (UI)

- (NSMenuItem *)menuItem
{
    if (![self.valueByConfigurations count])
    {
        // TODO: think of a better return value
        return nil;
    }
    
    NSMenuItem *(^createMenuItem)(NSString *, BOOL) = ^NSMenuItem *(NSString *name, BOOL checked)
    {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:(name.length ? name : @"<empty>")
                                                      action:@selector(menuItemTapped:)
                                               keyEquivalent:@""];
        [item setTarget:[SYConfigurableVariablePlugin sharedPlugin]];
        [item setState:(checked ? NSOnState : NSOffState)];
        return item;
    };
    
    __weak SYBuildVar *wSelf = self;
    NSMenuItem *mainItem = [[NSMenuItem alloc] initWithTitle:self.name
                                                      action:nil
                                               keyEquivalent:@""];
    [mainItem setSubmenu:[[NSMenu alloc] initWithTitle:@""]];
    
    
    // All configs
    {
        NSMenuItem *itemConfig = [[NSMenuItem alloc] initWithTitle:@"<All configs>" action:nil keyEquivalent:@""];
        [itemConfig setSubmenu:[[NSMenu alloc] initWithTitle:@""]];
        
        NSSet *values = [NSSet setWithArray:[self.valueByConfigurations allValues]];
        for (NSString *value in self.values)
        {
            BOOL allConfigsHaveThisValue = ([values count] == 1 && [[values allObjects][0] isEqualToString:value]);
            
            NSMutableArray *configsWithThisValue = [NSMutableArray array];
            for (NSString *configName in [self.valueByConfigurations allKeys])
            {
                if ([self.valueByConfigurations[configName] isEqualToString:value])
                    [configsWithThisValue addObject:configName];
            }
            
            NSString *name = [NSString stringWithFormat:@"%@%@%@%@",
                              value,
                              configsWithThisValue.count ? @" (" : @"",
                              [configsWithThisValue componentsJoinedByString:@", "],
                              configsWithThisValue.count ? @")" : @""];
            
            NSMenuItem *itemValue = createMenuItem(allConfigsHaveThisValue ? value : name, allConfigsHaveThisValue);
            [itemValue setRepresentedObject:^{
                [wSelf.target setValue:value forBuildVar:wSelf.name andConfiguration:nil];
            }];
            [[itemConfig submenu] addItem:itemValue];
        }
        [[mainItem submenu] addItem:itemConfig];
    }
    
    // by config
    for (NSString *configName in [self.valueByConfigurations allKeys])
    {
        NSMenuItem *itemConfig = [[NSMenuItem alloc] initWithTitle:configName action:nil keyEquivalent:@""];
        [itemConfig setSubmenu:[[NSMenu alloc] initWithTitle:@""]];
        
        for (NSString *value in self.values)
        {
            NSMenuItem *itemValue = createMenuItem(value, [value isEqualToString:self.valueByConfigurations[configName]]);
            [itemValue setRepresentedObject:^{
                [wSelf.target setValue:value forBuildVar:wSelf.name andConfiguration:configName];
            }];
            [[itemConfig submenu] addItem:itemValue];
        }
        
        if (![self.values containsObject:self.valueByConfigurations[configName]])
        {
            [[itemConfig submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem *itemValue = createMenuItem(self.valueByConfigurations[configName], YES);
            [[itemConfig submenu] addItem:itemValue];
        }
        
        [[mainItem submenu] addItem:itemConfig];
    }
    
    return mainItem;
}

@end
