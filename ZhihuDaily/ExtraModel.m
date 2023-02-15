//
//  ExtraModel.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/14.
//

#import "ExtraModel.h"

@implementation ExtraModel

+ (instancetype)DataWithDict:(NSDictionary *)dict{
    ExtraModel *model = [[ExtraModel alloc]init];
    model.comments = dict[@"comments"];
    model.popularity = dict[@"popularity"];
    return model;
}

@end
