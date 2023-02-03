//
//  SessionManager.h
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/3.
//
//
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionManager : AFHTTPSessionManager

//@property (nonatomic,copy) NSString *apiURL;

//异步请求数据


+(void)getDatawithapiURL:(NSString *)api
                   Success:(void(^)(NSArray *array))success
                   Failure:(void(^)(void)) failure;

@end

NS_ASSUME_NONNULL_END
