//
//  HXMHttpRequest.m
//  Http
//
//  Created by 侯绪铭 on 2017/4/10.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import "HXMHttpRequest.h"

/**
 * 网络请求返回的状态码(key) - 和后台商定
 */
#define K_HTTP_STATUS_KEY     @"code"

/**
 * 网络请求返回的数据(key) - 和后台商定
 */
#define K_HTTP_DATA_KEY       @"data"

/**
 * 网络请求返回的错误提示 - 和后台商定
 */
#define K_HTTP_STATUS_MSG     @"message"

/**
 * 网络状态码(成功) - 和后台商定
 */
#define K_HTTP_STATUS_SUCCESS @"0"

@interface HXMHttpRequest ()

@property (nonatomic,strong) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic,strong) AFNetworkReachabilityManager *netWorkReachabilityManager;

@end

@implementation HXMHttpRequest

// 请求单例
+ (instancetype)shareInstance
{
    static HXMHttpRequest *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

// 请求实例
- (AFHTTPSessionManager *)httpSessionManager
{
    if (!_httpSessionManager) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        // 告诉服务器以json的形式返回数据
        _httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                         @"application/json",
                                                                         @"text/json",
                                                                         @"text/plain",
                                                                         @"text/html",
                                                                         nil];
    }
    return _httpSessionManager;
}

// 网络状态的实例
- (AFNetworkReachabilityManager *)netWorkReachabilityManager
{
    if (!_netWorkReachabilityManager) {
        _netWorkReachabilityManager = [AFNetworkReachabilityManager manager];
        [_netWorkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    [TSMessage showNotificationWithTitle:@"未检测到网络" type:TSMessageNotificationTypeMessage];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    [TSMessage showNotificationWithTitle:@"未检测到网络" type:TSMessageNotificationTypeMessage];
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    [TSMessage showNotificationWithTitle:@"已切换至移动网络" type:TSMessageNotificationTypeMessage];
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [TSMessage showNotificationWithTitle:@"已切换至Wi-Fi" type:TSMessageNotificationTypeMessage];
                    break;
                    
                default:
                    break;
            }
        }];
    }
    return _netWorkReachabilityManager;
}

#pragma mark - Instance Method

// 是否显示网络请求的指示器
- (void)showNetworkIndicator:(BOOL)isShow
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = isShow;
}

#pragma mark - Class Method

// 当前是否有网络连接
+ (BOOL)hasNetworkConnecttion
{
    AFNetworkReachabilityStatus status = [HXMHttpRequest shareInstance].netWorkReachabilityManager.networkReachabilityStatus;
    if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    } else {
        return YES;
    }
}

// 开始监听网络状态
+ (void)startMonitoring
{
    [[HXMHttpRequest shareInstance].netWorkReachabilityManager startMonitoring];
}

#pragma mark - Network

/**
 *  @brief POST     请求方式
 *  @param url      url字符串
 *  @param param    请求的参数
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+ (void)post:(NSString *)url
  parameters:(id)param
     success:(successBlock)success
     failure:(failureBlock)failure
{
    HXMHttpRequest *http = [HXMHttpRequest shareInstance];
    
    // 显示网络标识
    [http showNetworkIndicator:YES];
    [http.httpSessionManager POST:url
                       parameters:param
                         progress:^(NSProgress * _Nonnull uploadProgress) {
                             
                         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                             // 取消网络标识
                             [http showNetworkIndicator:NO];
                             // 完成
                             if (task.state == NSURLSessionTaskStateCompleted) {
                                 
                                 if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                     success(responseObject);
                                 } else {
                                     // 数据格式异常
                                     NSAssert(![responseObject isKindOfClass:[NSDictionary class]], @"数据格式返回异常,不是字典");
                                 }
                                 
                             } else {
                                 // 错误的请求状态
                             }
                             
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             // 取消网络标识
                             [http showNetworkIndicator:NO];
                             failure(error);
                             
                         }];
}

/**
    @brief 上传多个文件
    @param url          请求的字符串
    @param param        参数(字典)
    @param fileDatas    上传的文件(NSData)
    @param fileNames    上传文件的名字
    @param names        服务器对应的参数名称
    @param mimeType     要上传的文件类型(如 image/png  image/jpeg)
    @param progress     上传进度回调 0.0-1.0之间
    @param success      成功的回调
    @param failure      失败的回调
 */
+ (void)uploadFiles:(NSString *)url
         parameters:(id)param
          fileDatas:(NSArray *)fileDatas
          fileNames:(NSArray *)fileNames
              names:(NSArray *)names
           mimeType:(NSString *)mimeType
           progress:(progressBlock)progress
            success:(successBlock)success
            failure:(failureBlock)failure
{
    HXMHttpRequest *http = [HXMHttpRequest shareInstance];
    
    // 显示网络标识
    [http showNetworkIndicator:YES];
    
    [http.httpSessionManager POST:url
                       parameters:param
        constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            if (fileDatas && fileDatas.count > 0 && [fileDatas isKindOfClass:[NSArray class]]) {
                
                for (int i = 0; i < fileDatas.count; i++) {
                    
                    NSData *fileData = fileDatas[i];
                    NSString *fileName = fileNames[i];
                    NSString *name = names[i];
                    
                    [formData appendPartWithFileData:fileData
                                                name:name
                                            fileName:fileName
                                            mimeType:mimeType];
                }
            } else {
                // 异常
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            // 上传文件的进度
            if (uploadProgress.totalUnitCount > 0) {
                progress(uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 取消网络标识
            [http showNetworkIndicator:NO];
            
            // 完成
            if (task.state == NSURLSessionTaskStateCompleted) {
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    success(responseObject);
                } else {
                    // 数据格式异常
                    NSAssert(![responseObject isKindOfClass:[NSDictionary class]], @"数据格式返回异常,不是字典");
                }
                
            } else {
                // 错误的请求状态
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            // 取消网络标识
            [http showNetworkIndicator:NO];
            failure(error);
            
        }];
}

/**
 @brief 上传 <单个> 文件
 @param url          请求的字符串
 @param param        参数(字典)
 @param fileData     上传的文件(NSData)
 @param fileName     上传文件的名字
 @param name         服务器对应的参数名称
 @param mimeType     要上传的文件类型(如 image/png  image/jpeg)
 @param progress     上传进度回调 0.0-1.0之间
 @param success      成功的回调
 @param failure      失败的回调
 */
+ (void)uploadFile:(NSString *)url
         parameter:(id)param
          fileData:(NSData *)fileData
          fileName:(NSString *)fileName
              name:(NSString *)name
          mimeType:(NSString *)mimeType
          progress:(progressBlock)progress
           success:(successBlock)success
           failure:(failureBlock)failure
{
    HXMHttpRequest *http = [HXMHttpRequest shareInstance];
    
    // 显示网络标识
    [http showNetworkIndicator:YES];
    
    [http.httpSessionManager POST:url
                       parameters:param
        constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            if (fileData && fileName) {
                
                [formData appendPartWithFileData:fileData
                                            name:name
                                        fileName:fileName
                                        mimeType:mimeType];
            } else {
                // 异常
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            // 上传文件的进度
            if (uploadProgress.totalUnitCount > 0) {
                progress(uploadProgress.completedUnitCount / (float)uploadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //取消网络标识
            [http showNetworkIndicator:NO];
            //完成
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(responseObject);
            } else {
                //数据格式异常
                NSAssert(![responseObject isKindOfClass:[NSDictionary class]], @"数据返回格式错误,不是字典");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //取消网络标识
            [http showNetworkIndicator:NO];
            failure (error);
        }];
}

@end
