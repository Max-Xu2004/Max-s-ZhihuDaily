//
//  ExtraSessionManager.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/14.
//

#import "ExtraSessionManager.h"
#import "ExtraModel.h"

@implementation ExtraSessionManager

+ (void)getExtraDatawithidNUM:(NSString *)idNUM
                      Success:(void (^)(NSArray * _Nonnull))success
                      Failure:(void (^)(void))failure{
    AFHTTPSessionManager *extraManager = [AFHTTPSessionManager manager];
    NSString *idString = [NSString stringWithFormat:@"%@",idNUM];
    NSString *apiPrefix = @"https://news-at.zhihu.com/api/3/story-extra/";
    NSString *apiString = [apiPrefix stringByAppendingString:idString];
    [extraManager GET:apiString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *mArray = [NSMutableArray array];
        NSString *comments = responseObject[@"comments"];
        NSString *popularity = responseObject[@"popularity"];
        [mArray addObject:comments];
        [mArray addObject:popularity];
        if(success) success(mArray.copy);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error");
        }];
}

@end
