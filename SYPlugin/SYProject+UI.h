//
//  SYProject+UI.h
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYProject.h"

@class NSMenuItem;
typedef void(^SYPMenuItemTapped)(void);

@interface SYProject (UI)

- (NSMenuItem *)menuItem;

@end
