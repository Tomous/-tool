//
//  ViewController.m
//  PayMentTool
//
//  Created by 大橙子 on 2019/7/25.
//  Copyright © 2019 Tomous. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"
#import "PaymentTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)btnDidClick {
    [self.view endEditing:YES];
    PaymentTool *tool = [[PaymentTool alloc]init];
    [self.view.window addSubview:tool];
    tool.completeHandle = ^(NSString *inputPwd) {
        
        if (!inputPwd) {
            return ;
        }
        NSLog(@"inputPwd--%@",inputPwd);
    };
}

@end
