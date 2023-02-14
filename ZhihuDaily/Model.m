//
//  Model.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/1/31.
//
//Model用于get知乎api提供的数据并保存到模型中
#import "Model.h"
#import "AFHTTPSessionManager.h"

//@interface Model ()
//
//@property (nonatomic,strong) NSString *api;
//
//@end

@implementation Model


+(instancetype)DataWithDict:(NSDictionary *)dict{
    Model *model = [[Model alloc]init];
    model.title = dict[@"title"];
    model.hint = dict[@"hint"];
    model.imagesArray = dict[@"images"];
    model.images = model.imagesArray[0];
    model.url = dict[@"url"];
    model.idNum = dict[@"id"];
    return model;
}

@end
