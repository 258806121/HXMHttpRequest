//
//  BaseVC.m
//  Http
//
//  Created by 侯绪铭 on 2017/4/11.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()
{
    MBProgressHUD *progressHUD;
}

@end

@implementation BaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupHUD];

}

- (void)setupHUD
{
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    progressHUD.contentColor = [UIColor whiteColor];
    [self.view addSubview:progressHUD];
    
}

// 显示加载进度条
- (void)showProgressHUD
{
    [self showProgressHUDWithText:nil];
}

// 显示 + 提示信息
- (void)showProgressHUDWithText:(NSString *)text
{
    if (text && text.length > 0 ) {
        progressHUD.label.text = text;
    } else {
        progressHUD.label.text = nil;
    }
    
    [self.view bringSubviewToFront:progressHUD];
    [progressHUD showAnimated:YES];
}

// 隐藏
- (void)hiddenProgessHUD
{
    [self hiddenProgressHUDWithText:nil];
}

// 隐藏 + 提示信息
- (void)hiddenProgressHUDWithText:(NSString *)text
{
    if (text && text.length > 0 ) {
        progressHUD.label.text = text;
    } else {
        progressHUD.label.text = nil;
    }
    
    [self.view sendSubviewToBack:progressHUD];
    [progressHUD hideAnimated:YES afterDelay:1.5];
}


@end
