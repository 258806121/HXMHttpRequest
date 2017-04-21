//
//  HomeVC.m
//  Http
//
//  Created by 侯绪铭 on 2017/4/11.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getBannerInfo];
}


- (void)getBannerInfo
{
    [self showProgressHUD];
    
    NSString *url = @"http://www.oliving365.com/hbsy/api/newhome/banner";
    [HXMHttpRequest post:url
              parameters:nil
                 success:^(id responseObject) {
                     
                     [self hiddenProgessHUD];
                     // 状态码为 0 成功
                     if ([STATUS isEqualToString:k_http_request_success]) {
                         
                         NSLog(@"----%@",DATA);
                         
                     } else {
                         
                         [self hiddenProgressHUDWithText:MESSAGE];
                     }
                 } failure:^(NSError *error) {
                     // 失败
                     [self hiddenProgressHUDWithText:k_http_request_failed];
                 }];
}


@end
