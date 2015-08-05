//
//  NSAlert+UI.m
//  ConfigurableVariable
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
    
    NSArray *details = @[@"This tool allows you to work with configurable variables easily. Though it can create new variables for you, you can also add them manually. Let's take the case of a variable called \"ENVIRONMENT\" with possible values: \"STAGING\" and \"PRODUCTION\"",
                         @"To add this variable manually you need to do the following steps:",
                         @"1. Tap on the project on the Navigator panel (left panel)",
                         @"2. In the project and targets view, tap the project",
                         @"3. Open the Build Settings tab",
                         @"4. Tap the + icon, right under \"Build Settings\"",
                         @"5. Select \"Add User-Defined Setting\"",
                         @"6. Enter \"ENVIRONMENT\" for your variable",
                         @"7. Redo steps 4 to 6 with the following variable name: \"ENVIRONMENT%%SUFFIX%%\"",
                         @"8. The last created variable should contain all possibilities, separated by \"%%SEPARATOR%%\", here its value will be \"STAGING%%SEPARATOR%%PRODUCTION\"",
                         @"9. Go to the info.plist file of your target",
                         @"10. Add a new variable called \"ENVIRONMENT\", with the value \"$(ENVIRONMENT)\"",
                         @"",
                         @"Be careful:",
                         @"- \"ENVIRONMENT\" can have a different value for each configuration",
                         @"- \"ENVIRONMENT%%SUFFIX%%\" must have the same values accross all configurations of a target",
                         @"- both variable needs to be defined at the target level, not for the whole project"];
    
    NSMutableArray *detailsMutable = [NSMutableArray array];
    for (NSString *detail in details)
    {
        NSString *newDetail = [detail stringByReplacingOccurrencesOfString:@"%%SUFFIX%%" withString:[SYConsts valuesVariableNameSuffix]];
        newDetail = [newDetail stringByReplacingOccurrencesOfString:@"%%SEPARATOR%%" withString:[SYConsts valuesSeparator]];
        [detailsMutable addObject:newDetail];
    }
    
    [alert setInformativeText:[detailsMutable componentsJoinedByString:@"\n"]];
    [alert beginSheetModalForWindow:window completionHandler:nil];
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
