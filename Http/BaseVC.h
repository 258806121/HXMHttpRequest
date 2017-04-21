//
//  BaseVC.h
//  Http
//
//  Created by 侯绪铭 on 2017/4/11.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

// 显示加载进度条
- (void)showProgressHUD;

// 显示 + 提示信息
- (void)showProgressHUDWithText:(NSString *)text;

// 隐藏
- (void)hiddenProgessHUD;

// 隐藏 + 提示信息
- (void)hiddenProgressHUDWithText:(NSString *)text;

@end
