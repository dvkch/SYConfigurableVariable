//
//  SYProject.h
//  ConfigurableVariable
//
//  Created by Stan Chevallier on 30/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYProject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSArray *targets;

- (instancetype)initWithPath:(NSString *)path;

@end
