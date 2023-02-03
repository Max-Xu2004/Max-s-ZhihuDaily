//
//  SessionManager.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/3.
//

#import "SessionManager.h"
#import "Model.h"

@implementation SessionManager

NSString *api;

//apiURL为请求数据的api链接
+(void)getDatawithapiURL:(NSString *)api
                   Success:(void(^)(NSArray *array))success
                   Failure:(void(^)(void)) failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:(api) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *mArray = [NSMutableArray array];
        for(NSDictionary *dict in responseObject[@"stories"]){
            Model *model = [Model DataWithDict:dict];
            [mArray addObject:model];
        }
        if(success) success(mArray.copy);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        }];
}


//- (void)setApiURL:(NSString *)apiURL{
//    api = apiURL.copy;
//}

@end
