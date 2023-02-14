//
//  NewsViewController.h
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/2.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsViewController : UIViewController

@property (nonatomic,strong) NSString *newsURL;
@property (nonatomic,strong) NSString *likeNum;


@end

NS_ASSUME_NONNULL_END
