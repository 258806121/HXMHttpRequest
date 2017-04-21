//
//  HXMHttpRequest.h
//  Http
//
//  Created by 侯绪铭 on 2017/4/10.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMessage.h"
#import "AFNetworking.h"

typedef void (^successBlock) (id responseObject);
typedef void (^failureBlock) (NSError *error);
typedef void (^progressBlock)(CGFloat progress);


@interface HXMHttpRequest : NSObject

// 请求单例
+ (instancetype)shareInstance;

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
     failure:(failureBlock)failure;

/**
 @brief 上传 <多个> 文件
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
            failure:(failureBlock)failure;

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
           failure:(failureBlock)failure;


@end
