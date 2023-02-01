//
//  Model.h
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/1/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *hint;
@property(nonatomic,copy) NSString *images;
@property(nonatomic,copy) NSString *url;

//异步请求数据
+(void)getDatawithSuccess:(void(^)(NSArray *array))success
                   Failure:(void(^)(void)) failure;

//字典转模型
//dict为字典
+(instancetype)DataWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
