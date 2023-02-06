//
//  TableViewHeaderView.h
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//复用标志
UIKIT_EXTERN NSString *TableViewHeaderViewReuseIdentifier;

@interface TableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic,copy) NSString *date;

@end

NS_ASSUME_NONNULL_END
