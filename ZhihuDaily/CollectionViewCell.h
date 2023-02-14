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

@property (nonatomic,strong) NSString *imgLink;

@property (nonatomic,strong) NSString *titleText;

@property (nonatomic,strong) NSString *hintText;

@end

NS_ASSUME_NONNULL_END
