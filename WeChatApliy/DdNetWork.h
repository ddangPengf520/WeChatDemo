//
//  DdNetWork.h
//  WeChatApliy
//
//  Created by dpfst520 on 15/12/1.
//  Copyright © 2015年 pengfei.dang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DataReturnType) {
    DataReturnTypeData,//返回数据Data型
    DataReturnTypeXml,//返回数据Xml型
    DataReturnTypeJson//返回数据Json
};

typedef NS_ENUM(NSInteger, RequestBodyType) {
    RequestBodyTypeXml,//数据请求Xml型
    RequestBodyTypeJson,//数据请求Json型
    RequestBodyTypeDictionaryToString,//数据请求字典转字符串
    RequestBodyTypeString//数据请求字符串
};

@interface DdNetWork : NSObject



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
                   FailureBlock:(void (^)(NSError *error))failureBlock;

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
                    FailureBlock:(void (^)(NSError *error))failureBlock;


/**
 *  @brief 网络判断
 *
 *  @return YES 有网 WIFI/WWAN  NO 无网络连接
 */
+ (BOOL)isNetWorkConnectionAvailable;





@end
