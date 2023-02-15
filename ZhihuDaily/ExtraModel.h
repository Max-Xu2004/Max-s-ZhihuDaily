//
//  ExtraModel.h
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExtraModel : NSObject

@property(nonatomic,copy) NSString *comments;
@property(nonatomic,copy) NSString *popularity;

//字典转模型
//dict为字典
+(instancetype)DataWithDict:(NSDictionary *)dict;



@end

NS_ASSUME_NONNULL_END
