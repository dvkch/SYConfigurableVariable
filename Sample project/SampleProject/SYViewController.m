//
//  SYViewController.m
//  SampleProject
//
//  Created by Stan Chevallier on 31/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYViewController.h"
#import "SYConfig.h"

@interface SYViewController ()
@property (nonatomic, weak) IBOutlet UILabel *labelHost;
@end

@implementation SYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.labelHost setText:[SYConfig host]];
}

@end
