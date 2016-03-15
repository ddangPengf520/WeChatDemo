//
//  DdNetWork.m
//  WeChatApliy
//
//  Created by dpfst520 on 15/12/1.
//  Copyright © 2015年 pengfei.dang. All rights reserved.
//

#import "DdNetWork.h"

#import "Reachability.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"


@implementation DdNetWork




/**
 *  @brief GET请求
 *
 *  @param urlString      请求的url
 *  @param parameters     请求参数
 *  @param requestHead    请求头
 *  @param dataReturnType 请求数据类型
 *  @param successBlock   请求成功的回调
 *  @param failureBlock   请求失败的回调
 */

+ (void)getRequestWithURLString:(NSString *)urlString
                     Parameters:(id)parameters
                    RequestHead:(NSDictionary *)requestHead
                 DataReturnType:(DataReturnType)dataReturnType
                   SuccessBlock:(void (^)(NSData *data))successBlock
                   FailureBlock:(void (^)(NSError *error))failureBlock
{
    if ([self isNetWorkConnectionAvailable]) {
        
        //获得请求管理者
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //支持https请求
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        //状态栏加载指示器
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        //网络数据形式
        switch (dataReturnType) {
            case DataReturnTypeData:
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
            case DataReturnTypeJson:
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                break;
            case DataReturnTypeXml:
                manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                break;
                
            default:
                break;
        }
        
        //响应数据支持的类型
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain", @"application/x-javascript", @"application/javascript", nil]];
        
        //url转码
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        //如果有请求头，添加请求头
        if (requestHead) {
            for (NSString *key in requestHead) {
                [manager.requestSerializer setValue:[requestHead objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        //请求数据
        [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            successBlock(operation.responseData);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error ---> %@",error);
        }];
    } else {
        NSLog(@"无网络。。。");
    }
}

/**
 *  @brief POST请求
 *
 *  @param urlString       请求的url
 *  @param parameters      请求参数
 *  @param requestHead     请求头
 *  @param dataReturnType  请求数据类型
 *  @param requestBodyType 请求body的类型
 *  @param successBlock    请求成功的回调
 *  @param failureBlock    请求失败的回调
 */

+ (void)postRequestWithURLString:(NSString *)urlString
                      Parameters:(id)parameters
                     RequestHead:(NSDictionary *)requestHead
                 RequestBodyType:(RequestBodyType)requestBodyType
                  DataReturnType:(DataReturnType)dataReturnType
                    SuccessBlock:(void (^)(NSData *data))successBlock
                    FailureBlock:(void (^)(NSError *error))failureBlock
{
    if ([self isNetWorkConnectionAvailable]) {
        
        //获得请求管理者
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //支持https
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        //开启状态栏架子啊指示器
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        //上传数据时body的类型
        switch (requestBodyType) {
            case RequestBodyTypeString:
                
                //保持字符串样式
                [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
                    return  parameters;
                }];
                
                break;
            case RequestBodyTypeJson:
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                break;
            case RequestBodyTypeXml:
                manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
                break;
            case RequestBodyTypeDictionaryToString:
                break;
            default:
                break;
        }
        
        //网络形式
        switch (dataReturnType) {
            case DataReturnTypeData:
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
            case DataReturnTypeXml:
                manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                break;
            case DataReturnTypeJson:
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                break;
                
            default:
                break;
        }
        
        //响应数据支持的类型
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain", @"application/x-javascript", @"application/javascript", nil]];
        
        //url转码
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        //如果有请求头， 添加请求头
        if (requestHead) {
            for (NSString *key in requestHead) {
                [manager.requestSerializer setValue:[requestHead objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        //请求数据
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            successBlock(operation.responseData);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error ---> %@", error);
        }];
    } else {
        NSLog(@"无网络。。。");
    }
}


/**
 *  @brief 网络判断
 *
 *  @return YES 有网 WIFI/WWAN  NO 无网络连接
 */
+ (BOOL)isNetWorkConnectionAvailable
{
    BOOL isExistenceNetWork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetWork = NO;
            NSLog(@"无网络。。。");
            break;
        case ReachableViaWiFi:
            isExistenceNetWork = YES;
            NSLog(@"wifi网络。。。");
            break;
        case ReachableViaWWAN:
            isExistenceNetWork = YES;
            NSLog(@"3G");
            break;
            
        default:
            break;
    }
    
    return isExistenceNetWork;
}




@end
