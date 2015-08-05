//
//  NSAlert+UI.h
//  ConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSAlert (UI)

+ (void)sy_showHelpAlertInWindow:(NSWindow *)window;
+ (void)sy_showNewVariablePromptInWindow:(NSWindow *)window completion:(void(^)(NSString *name, NSArray *values))completion;
+ (void)sy_showInvalidVariableNameInWindow:(NSWindow *)window completion:(void(^)(void))completion;

@end
