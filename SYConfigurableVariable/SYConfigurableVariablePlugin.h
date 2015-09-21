//
//  SYConfigurableVariablePlugin.h
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface SYConfigurableVariablePlugin : NSObject

@property (nonatomic, strong, readonly) NSBundle *bundle;

+ (instancetype)sharedPlugin;
+ (void)setSharedPlugin:(SYConfigurableVariablePlugin *)sharedPlugin;

- (id)initWithBundle:(NSBundle *)plugin;
- (void)menuItemTapped:(NSMenuItem *)menuItem;

@end