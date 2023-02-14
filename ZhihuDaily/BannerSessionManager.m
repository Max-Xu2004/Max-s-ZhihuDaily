//
//  BannerSessionManager.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/11.
//

#import "BannerSessionManager.h"
#import "BannerModel.h"

@implementation BannerSessionManager

+ (void)getBannerDatawithSuccess:(void (^)(NSArray * _Nonnull))success Failure:(void (^)(void))failure{
    AFHTTPSessionManager *bannerManager = [AFHTTPSessionManager manager];
    [bannerManager GET:@"https://news-at.zhihu.com/api/3/news/latest" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *mArray = [NSMutableArray array];
        for(NSDictionary *dict in responseObject[@"top_stories"]){
            BannerModel *model = [BannerModel DataWithDict:dict];
            [mArray addObject:model];
        }
        if(success) success(mArray.copy);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        }];
}

@end
