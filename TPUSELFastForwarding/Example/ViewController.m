//
//  ViewController.m
//  Example
//
//  Created by 邵伟男 on 2017/11/24.
//  Copyright © 2017年 邵伟男. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(losted:Instance:Method:inVC:)];
    [[self class] performSelector:@selector(losted:Class:MethodInVCClass:)];
}


@end