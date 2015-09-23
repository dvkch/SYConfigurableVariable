//
//  NSMenu+UI.m
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 04/08/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "NSMenu+UI.h"

@implementation NSMenu (UI)

- (void)stealItemsFromMenu:(NSMenu *)menu
{
    NSArray *menuItems = [[menu itemArray] copy];
    for (NSMenuItem *item in menuItems)
    {
        [menu removeItem:item];
        [self addItem:item];
    }
}

@end
