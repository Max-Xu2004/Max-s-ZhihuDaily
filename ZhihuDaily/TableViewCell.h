//
//  TableViewCell.h
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//复用标志
UIKIT_EXTERN NSString *TableViewCellReuseIdentifier;

@interface TableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *imgURL;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *hint;

@end

NS_ASSUME_NONNULL_END
