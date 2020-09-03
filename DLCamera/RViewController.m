//
//  RViewController.m
//  DLCamera
//
//  Created by 百维科技 on 2020/9/2.
//  Copyright © 2020 百维科技. All rights reserved.
//

#import "RViewController.h"
#import "DLViewController.h"

@interface RViewController ()

@end

@implementation RViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击拍照" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 200, 100, 30);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)btnClick {
    DLViewController *vc = [[DLViewController alloc]init];
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}


@end
