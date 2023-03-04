//
//  CollectionViewCell.h
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///复用标志
UIKIT_EXTERN NSString *CollectionViewCellReuseIdentifier;

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) NSString *imgLink;

@property (nonatomic,copy) NSString *titleText;

@property (nonatomic,copy) NSString *hintText;

@end

NS_ASSUME_NONNULL_END
