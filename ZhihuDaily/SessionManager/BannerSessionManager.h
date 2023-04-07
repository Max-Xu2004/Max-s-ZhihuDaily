//
//  BannerSessionManager.h
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/11.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerSessionManager : AFHTTPSessionManager

+(void)getBannerDatawithSuccess:(void(^)(NSArray *array))success
                   Failure:(void(^)(void)) failure;

@end

NS_ASSUME_NONNULL_END
