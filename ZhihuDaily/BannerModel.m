//
//  BannerModel.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/12.
//

#import "BannerModel.h"

@implementation BannerModel

+(instancetype)DataWithDict:(NSDictionary *)dict{
    BannerModel *model = [[BannerModel alloc]init];
    model.title = dict[@"title"];
    model.hint = dict[@"hint"];
    model.image = dict[@"image"];
    model.url = dict[@"url"];
    model.idNum = dict[@"id"];
    return model;
}

@end
