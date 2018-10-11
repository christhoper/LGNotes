//
//  LGNetworkManager.m
//  LGAssistance
//
//  Created by hend on 2017/7/10.
//  Copyright © 2017年 hend. All rights reserved.
//

#import "LGNetworkManager.h"

@interface LGNetworkManager ()
/** 网络请求超时时长 */
@property (assign, nonatomic) NSTimeInterval timeout;
/** 版本号 */
@property (assign, nonatomic) APIVersion version;
/** 请求方式 */
@property (assign, nonatomic) RequestType requestType;
/** 请求网址 */
@property (copy, nonatomic) NSString *url;
/** 请求参数 */
@property (assign, nonatomic) id parameters;
/** 请求头 */
@property (strong, nonatomic) NSDictionary *HTTPHeaderDic;
/** 数据发送类型 */
@property (assign, nonatomic) RequestSerializer serializer;

@property (assign, nonatomic) ResponseSerializer respone;
/** 验证token */
@property (nonatomic,assign) BOOL verifyTokenEnable;

@end

@implementation LGNetworkManager

+ (LGNetworkManager *)shareManager{
    static LGNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LGNetworkManager alloc] init];
        [manager resettingRequestParams];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    });
    return manager;
}

- (void)netMonitoring{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.networkReachabilityStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.networkReachabilityStatus = AFNetworkReachabilityStatusReachableViaWiFi;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.networkReachabilityStatus = AFNetworkReachabilityStatusNotReachable;
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (LGNetworkManager *(^)(BOOL))setVerifyTokenEnable{
    return ^LGNetworkManager *(BOOL verifyTokenEnable){
        self.verifyTokenEnable = verifyTokenEnable;
        return self;
    };
}

- (LGNetworkManager *(^)(NSTimeInterval))setTimeoutInterval{
    return ^LGNetworkManager *(NSTimeInterval timeoutInterval){
        self.timeout = timeoutInterval;
        return self;
    };
}

- (LGNetworkManager *(^)(RequestType))setRequestType{
    return ^LGNetworkManager *(RequestType requestType){
        self.requestType = requestType;
        return self;
    };
}

- (LGNetworkManager *(^)(APIVersion))setAPIVersion{
    return ^LGNetworkManager *(APIVersion version){
        self.version = version;
        return self;
    };
}

- (LGNetworkManager *(^)(NSString *))setRequestUrl{
    return ^LGNetworkManager *(NSString *requestUrl){
        self.url = requestUrl;
        return self;
    };
}

- (LGNetworkManager *(^)(id))setParameters{
    return ^LGNetworkManager *(id parameters){
        self.parameters = parameters;
        return self;
    };
}

- (LGNetworkManager *(^)(NSDictionary *))setHTTPHeaderDic{
    return ^LGNetworkManager *(NSDictionary *HTTPHeaderDic){
        self.HTTPHeaderDic = HTTPHeaderDic;
        return self;
    };
}

- (LGNetworkManager *(^)(RequestSerializer))setSerializer{
    return ^LGNetworkManager *(RequestSerializer serializer){
        self.serializer = serializer;
        return self;
    };
}

- (LGNetworkManager *(^)(ResponseSerializer))setResponerializer{
    return ^LGNetworkManager *(ResponseSerializer respone){
        self.respone = respone;
        return self;
    };
}

/** 获取网络状态 */
- (AFNetworkReachabilityStatus)networkStatus{
   __block AFNetworkReachabilityStatus networkStatus;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                break;
                case AFNetworkReachabilityStatusNotReachable:
                break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
            default:
                break;
        }
        networkStatus = status;
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return networkStatus;
}

/** 开始请求前的设置 */
- (LGNetworkManager *)setupAttributeBeforSendRequest{
    LGNetworkManager *manager = [[LGNetworkManager class] manager];
    
    [self setupATRequestSerializerWithManager:manager];
    
    [self setupATHTTPHeaderWithManager:manager];
    
    [self setupATResponeSerrializerWithManager:manager];
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = self.timeout;
    return manager;
}

/** 设置发送类型及超时时间 */
- (LGNetworkManager *)setupATRequestSerializerWithManager:(LGNetworkManager *)manager{
    switch (self.serializer) {
        case RequestSerializerJSON:{
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
            break;
        case RequestSerializerHTTP:{
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        }
            break;
            
        default:
            break;
    }
    return manager;
}

/** 设置请求头 */
- (LGNetworkManager *)setupATHTTPHeaderWithManager:(LGNetworkManager *)manager{
    for (NSString *key in self.HTTPHeaderDic) {
        [manager.requestSerializer setValue:self.HTTPHeaderDic[key] forHTTPHeaderField:key];
    }
    return manager;
}

/** 设置返回结果类型 */
- (LGNetworkManager *)setupATResponeSerrializerWithManager:(LGNetworkManager *)manager{
    switch (self.respone) {
        case ResponseSerializerJSON:{
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
        case ResponseSerializerHTTP:{
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
            break;
        case ResponseSerializerXML:{
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        }
            break;
            
        default:
            break;
    }
    return manager;
}

/** 设置请求的url */
- (NSString *)setupRequestUrl{
    NSString *version = @"";
    switch (self.version) {
        case None:{
          return self.url;
        }
            break;
        case Version1:{
            return version = @"v1";
        }
            break;
        case Version2:{
            return version = @"v2";
        }
            break;
    
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@,%@",self.url,version];
}

- (void)startSendRequestWithProgress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
   
    LGNetworkManager *manager = [self setupAttributeBeforSendRequest];
    manager.timeout = self.timeout;
    NSString *url = [[self setupRequestUrl] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    RequestType requestType = self.requestType;
    if (self.url.length == 0) {
        failure([NSError errorWithDomain:@"请求网址为空" code:-1 userInfo:nil]);
        return ;
    }
    
    switch (requestType) {
        case GET:{
            
            [manager GET:url parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(responseObject);
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }];
        }
            break;
        case GETSYSTEM:{
            __block NSString *paramsString = @"";
            if ([self.parameters isKindOfClass:[NSDictionary class]]) {
                [self.parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSString *string;
                    if (paramsString.length == 0) {
                        string = [NSString stringWithFormat:@"%@=%@",key,obj];
                    }
                    else{
                        string = [NSString stringWithFormat:@"&%@=%@",key,obj];
                    }
                    paramsString = [paramsString stringByAppendingString:string];
                }];
            }
            NSString *url = [[self setupRequestUrl] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            url = [url stringByAppendingString:paramsString];
            NSURL *requestUrl = [NSURL URLWithString:url];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
            request.HTTPMethod = @"GET";
            request.timeoutInterval = self.timeout;
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }else{
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(dic);
                    });
                }
            }];
            [dataTask resume];
        }
            break;
            
        case GETXML:{
            NSURL *requestUrl = [NSURL URLWithString:[self url]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
            request.timeoutInterval = self.timeout;
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }else{
                    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(result);
                    });
                }
            }];
            [dataTask resume];
        }
            break;
            
        case POST:{
            [manager POST:url parameters:self.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(responseObject);
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }];
        }
            break;
            
        case POSTSYSTEM:{
            NSURL *requestUrl = [NSURL URLWithString:url];
            // POST请求
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
            request.HTTPMethod = @"POST";
            // 设置请求头
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            request.timeoutInterval = self.timeout;
            // 检验给定的对象是否能够被序列化
            if (![NSJSONSerialization isValidJSONObject:self.parameters]) {
                NSLog(@"格式不正确，不能被序列化");
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = nil;
                    failure(error);
                });
                return;
            }
            //设置请求体
            request.HTTPBody = [NSJSONSerialization dataWithJSONObject:self.parameters options:NSJSONWritingPrettyPrinted error:NULL];
            //                NSLog(@"%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }else{
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(dic);
                    });
                }
            }];
            [dataTask resume];
        }
            break;
            
        default:
            break;
    }
    [self resettingRequestParams];
}

- (void)starSendRequestSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
//    AFNetworkReachabilityStatus netStatus = [self networkStatus];
//    if (netStatus == AFNetworkReachabilityStatusNotReachable) {
//        NSLog(@"无网络连接");
//        failure([NSError errorWithDomain:@"无网络连接" code:-1 userInfo:nil]);
//        return;
//    }
    
    // 检测token是否有效
    if (self.verifyTokenEnable) {
        [self startSendRequestWithProgress:nil success:success failure:failure];
    } else {
//        [self verifyTokenWithstartRequestWithProgress:nil success:success failure:failure];
        [self startSendRequestWithProgress:nil success:success failure:failure];
    }
  
}
- (void)verifyTokenWithstartRequestWithProgress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError * error))failure{
    [self startSendRequestWithProgress:nil success:success failure:failure];
}

/** 重置请求参数设置 */
- (void)resettingRequestParams{
    self.url = nil;
    self.version = None;
    self.requestType = GET;
    self.parameters = nil;
    self.HTTPHeaderDic = nil;
    self.serializer = RequestSerializerHTTP;
    self.respone = ResponseSerializerJSON;
    self.timeout = 20;
    self.verifyTokenEnable = NO;
}


@end
