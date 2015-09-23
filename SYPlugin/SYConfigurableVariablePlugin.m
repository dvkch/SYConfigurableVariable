//
//  SYConfigurableVariablePlugin.m
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYConfigurableVariablePlugin.h"
#import "SYProject.h"
#import "SYProject+UI.h"
#import "NSAlert+UI.h"
#import "SYProject+List.h"
#import "NSMenu+UI.h"

static SYConfigurableVariablePlugin *__sharedPlugin;

@interface SYConfigurableVariablePlugin () <NSMenuDelegate>
@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) NSMenuItem *pluginMenu;
@property (nonatomic, strong) NSArray *lastProjects;
@end

@implementation SYConfigurableVariablePlugin

#pragma mark - View cycle

+ (instancetype)sharedPlugin
{
    return __sharedPlugin;
}

+ (void)setSharedPlugin:(SYConfigurableVariablePlugin *)sharedPlugin
{
    __sharedPlugin = sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init])
    {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    NSMenuItem *windowItem = [[NSApp mainMenu] itemAtIndex:2];
    [[windowItem submenu] addItem:[NSMenuItem separatorItem]];
    self.pluginMenu = [[NSMenuItem alloc] initWithTitle:@"Configure build" action:nil keyEquivalent:@""];
    [self.pluginMenu setSubmenu:[[NSMenu alloc] initWithTitle:@""]];
    [[self.pluginMenu submenu] setDelegate:self];
    [[windowItem submenu] addItem:self.pluginMenu];
    
    [self rebuildMenu];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)menuNeedsUpdate:(nonnull NSMenu *)menu
{
    [self rebuildMenu];
}

#pragma mark - Menu

- (void)rebuildMenu
{
    [[self.pluginMenu submenu] removeAllItems];
    
    self.lastProjects = [SYProject projectsInCurrentWorkspace];
    
    if (self.lastProjects.count == 0)
    {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"No project opened" action:nil keyEquivalent:@""];
        [[self.pluginMenu submenu] addItem:item];
    }
    else if (self.lastProjects.count == 1)
    {
        NSMenu *projectMenu = [(NSMenuItem *)[(SYProject *)self.lastProjects[0] menuItem] submenu];
        [[self.pluginMenu submenu] stealItemsFromMenu:projectMenu];
    }
    else
    {
        for (SYProject *project in self.lastProjects)
            [[self.pluginMenu submenu] addItem:[project menuItem]];
    }
    
    // Help
    {
        [[self.pluginMenu submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *itemHelp = [[NSMenuItem alloc] initWithTitle:@"Help" action:@selector(menuItemTapped:) keyEquivalent:@""];
        [itemHelp setTarget:self];
        [itemHelp setRepresentedObject:^{
            [NSAlert sy_showHelpAlertInWindow:[NSApp keyWindow]];
        }];
        [[self.pluginMenu submenu] addItem:itemHelp];
    }
}

- (void)menuItemTapped:(NSMenuItem *)menuItem
{
    SYPMenuItemTapped block = menuItem.representedObject;
    if (block) block();
}

@end
