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
    POSTENCRY,        // 加密
    GETSYSTEM,
    UPLOAD            // 上传
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

/** 上传数据的类型 */
typedef NS_ENUM(NSInteger, LGNoteUploadType) {
    LGNoteUploadTypeImage,    // 图片
    LGNoteUploadTypeVideo,    // 视频
    LGNoteUploadTypeOther     // 其他
};


@interface LGNoteNetworkManager : AFHTTPSessionManager
/** 网络状态 */
@property (nonatomic, assign) AFNetworkReachabilityStatus networkReachabilityStatus;
/** 上传进度 */
@property (nonatomic, strong, readonly) NSProgress *uploadProgress;

+ (LGNoteNetworkManager *)shareManager;

/** 网络监控 */
- (void)netMonitoring;


/** 检测token是否有效 */
- (LGNoteNetworkManager *(^)(BOOL verifyTokenEnable))setVerifyTokenEnable;

/**
 设置超时时间
 */
- (LGNoteNetworkManager *(^)(NSTimeInterval timeoutInterval))setTimeoutInterval;

/**
 请求方式
 */
- (LGNoteNetworkManager *(^)(RequestType requestType))setRequestType;

/**
 版本
 */
- (LGNoteNetworkManager *(^)(APIVersion version))setAPIVersion;

/**
 请求网址
 */
- (LGNoteNetworkManager *(^)(NSString *requestUrl))setRequestUrl;

/**
 请求参数
 */
- (LGNoteNetworkManager *(^)(id parameters))setParameters;

/**
 请求头
 */
- (LGNoteNetworkManager *(^)(NSDictionary *HTTPHeaderDic))setHTTPHeaderDic;

/**
 数据发送类型，默认HTTP
 */
- (LGNoteNetworkManager *(^)(RequestSerializer RequestSerializer))setSerializer;

/**
 请求结果接收类型，默认JSON
 */
- (LGNoteNetworkManager *(^)(ResponseSerializer Responerializer))setResponerializer;

/**
 上传的数据
 */
- (LGNoteNetworkManager *(^)(NSArray<NSData *> *uploadDatas))setUploadDatas;

/**
 图片上传方式
 */
- (LGNoteNetworkManager *(^)(LGNoteUploadType uploadType))setUploadType;

/**
 加密key
 */
- (LGNoteNetworkManager *(^)(NSString* encryKey))setEncryKey;

/**
 加密key
 */
- (LGNoteNetworkManager *(^)(NSString* token))setToken;


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
