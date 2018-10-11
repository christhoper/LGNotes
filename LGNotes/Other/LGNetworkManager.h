//
//  LGNetworkManager.h
//  LGAssistance
//
//  Created by hend on 2017/7/10.
//  Copyright © 2017年 hend. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/** 请求方式类型 */
typedef NS_ENUM(NSInteger, RequestType) {
    GET,
    GETXML,
    POST,
    POSTSYSTEM,
    GETSYSTEM
};
/** 版本号 */
typedef NS_ENUM(NSInteger, APIVersion) {
    None,
    Version1,
    Version2
};
/** 数据发送类型 */
typedef NS_ENUM(NSInteger, RequestSerializer) {
    RequestSerializerHTTP,
    RequestSerializerJSON
};
/** 数据接收类型 */
typedef NS_ENUM(NSInteger, ResponseSerializer) {
    ResponseSerializerJSON,
    ResponseSerializerXML,
    ResponseSerializerHTTP
};

@interface LGNetworkManager : AFHTTPSessionManager
/** 网络状态 */
@property (nonatomic, assign) AFNetworkReachabilityStatus networkReachabilityStatus;

+ (LGNetworkManager *)shareManager;

/** 网络监控 */
- (void)netMonitoring;


/** 检测token是否有效 */
- (LGNetworkManager *(^)(BOOL verifyTokenEnable))setVerifyTokenEnable;

/**
 设置超时时间
 */
- (LGNetworkManager *(^)(NSTimeInterval timeoutInterval))setTimeoutInterval;

/**
 请求方式
 */
- (LGNetworkManager *(^)(RequestType requestType))setRequestType;

/**
 版本
 */
- (LGNetworkManager *(^)(APIVersion version))setAPIVersion;

/**
 请求网址
 */
- (LGNetworkManager *(^)(NSString *requestUrl))setRequestUrl;

/**
 请求参数
 */
-(LGNetworkManager *(^)(id parameters))setParameters;

/**
 请求头
 */
- (LGNetworkManager *(^)(NSDictionary *HTTPHeaderDic))setHTTPHeaderDic;

/**
 数据发送类型，默认HTTP
 */
- (LGNetworkManager *(^)(RequestSerializer RequestSerializer))setSerializer;

/**
 请求结果接收类型，默认JSON
 */
- (LGNetworkManager *(^)(ResponseSerializer Responerializer))setResponerializer;

/**
 发送请求(带进度)

 @param progress 进度
 @param success 成功返回结果
 @param failure 失败返回结果
 */
- (void)startSendRequestWithProgress:(void (^)(NSProgress *progress))progress
                             success:(void (^)(id respone))success
                             failure:(void (^)(NSError *error))failure;

/**
 发送请求(没有进度)

 @param success 成功
 @param failure 失败
 */
- (void)starSendRequestSuccess:(void (^)(id respone))success
                       failure:(void (^)(NSError *error))failure;


@end
