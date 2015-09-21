//
//  NSAlert+UI.m
//  SYConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "NSAlert+UI.h"
#import "SYConsts.h"

@implementation NSAlert (UI)

+ (void)sy_showHelpAlertInWindow:(NSWindow *)window
{
    NSAlert *alert = [[self alloc] init];
    [alert setMessageText:@"Help"];
    [alert addButtonWithTitle:@"Close"];
    [alert addButtonWithTitle:@"Open GitHub"];
    
    [alert setInformativeText:@"This tool allows you to work with configurable variables easily. Though it can create new variables for you, you can also add them manually.\nAll the help you could ever want is available on GitHub; feel free to sumbit any issue you may encounter and merge request."];
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
        if (labs(NSModalResponseAbort) == labs(returnCode))
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/dvkch/SYConfigurableVariable"]];
    }];
}

+ (void)sy_showNewVariablePromptInWindow:(NSWindow *)window completion:(void(^)(NSString *name, NSArray *values))completion
{
    NSAlert *alert = [[self alloc] init];
    [alert setMessageText:@"New configurable variable"];
    [alert addButtonWithTitle:@"Add"];
    [alert addButtonWithTitle:@"Cancel"];
    
    NSTextField *inputName   = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 30, 300, 24)];
    [inputName setStringValue:@"Variable name"];
    NSTextField *inputValues = [[NSTextField alloc] initWithFrame:NSMakeRect(0,  0, 300, 24)];
    [inputValues setStringValue:@"Values;Separated;By;Semicolon"];
    
    NSView *inputs = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 54)];
    [inputs addSubview:inputName];
    [inputs addSubview:inputValues];
    [alert setAccessoryView:inputs];
    
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
        BOOL canceled = (labs(returnCode) == labs(NSModalResponseAbort));
        if (completion && !canceled)
            completion(inputName.stringValue, [inputValues.stringValue componentsSeparatedByString:[SYConsts valuesSeparator]]);
    }];
}

+ (void)sy_showInvalidVariableNameInWindow:(NSWindow *)window completion:(void (^)(void))completion
{
    NSAlert *alert = [[self alloc] init];
    [alert setMessageText:@"Invalid variable name"];
    [alert setInformativeText:@"A variable name must not be empty and can only contain the follow characters: a-z, A-Z, 0-9 and \"_\"."];
    [alert addButtonWithTitle:@"Close"];
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
        if (completion)
            completion();
    }];
}

@end
