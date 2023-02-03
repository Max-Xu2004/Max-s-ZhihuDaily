//
//  Model.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/1/31.
//
//Model用于get知乎api提供的数据并保存到模型中
#import "Model.h"
#import "AFHTTPSessionManager.h"

@implementation Model

+(instancetype)DataWithDict:(NSDictionary *)dict{
    Model *model = [[Model alloc]init];
    model.title = dict[@"title"];
    model.hint = dict[@"hint"];
    model.imagesArray = dict[@"images"];
    model.images = model.imagesArray[0];
    model.url = dict[@"url"];
    return model;
}

+ (void)getDatawithSuccess:(void (^)(NSArray * _Nonnull))success Failure:(void (^)(void))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://news-at.zhihu.com/api/3/stories/before/20230203" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *mArray = [NSMutableArray array];
        for(NSDictionary *dict in responseObject[@"stories"]){
            Model *model = [Model DataWithDict:dict];
            [mArray addObject:model];
        }
        if(success) success(mArray.copy); 
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        }];
}
@end
