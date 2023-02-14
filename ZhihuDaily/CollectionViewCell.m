//
//  CollectionViewCell.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/11.
//

#import "CollectionViewCell.h"
#import "UIimageView+WebCache.h"

NSString *CollectionViewCellReuseIdentifier = @"CollectionViewCell";

#pragma mark - CollectionViewCell ()

@interface CollectionViewCell ()

@property (nonatomic, strong) UIImageView *bannerImg;

@property (nonatomic, strong) UILabel *bannerTitle;

@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self.contentView addSubview:self.bannerImg];
        [self.contentView addSubview:self.bannerTitle];
        [self.contentView addSubview:self.hintLabel];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    self.bannerImg.frame =CGRectMake(0, 0, layoutAttributes.size.width, layoutAttributes.size.height-10);
    self.bannerTitle.frame = CGRectMake(10, layoutAttributes.size.height-100, layoutAttributes.size.width, 55);
    self.hintLabel.frame = CGRectMake(10, layoutAttributes.size.height-40, layoutAttributes.size.width, 20);
}

#pragma mark - 懒加载
- (UIImageView *)bannerImg{
    if(_bannerImg == nil){
        _bannerImg = [[UIImageView alloc]init];
    }
    return _bannerImg;
}

- (UILabel *)bannerTitle{
    if(_bannerTitle == nil){
        _bannerTitle = [[UILabel alloc]init];
        _bannerTitle.textColor = UIColor.whiteColor;
        _bannerTitle.numberOfLines = 0;
        _bannerTitle.font = [UIFont boldSystemFontOfSize:22];
    }
    return _bannerTitle;
}

- (UILabel *)hintLabel{
    if(_hintLabel == nil){
        _hintLabel = [[UILabel alloc]init];
        _hintLabel.textColor = UIColor.whiteColor;
        _hintLabel.numberOfLines = 1;
        _hintLabel.font = [UIFont systemFontOfSize:15];
    }
    return _hintLabel;
}
#pragma mark - Setter
- (void)setImgLink:(NSString *)imgLink{
    NSURL *link = [NSURL URLWithString:imgLink];
    [_bannerImg sd_setImageWithURL:link];
}

- (void)setTitleText:(NSString *)titleText{
    self.bannerTitle.text = titleText.copy;
}

- (void)setHintText:(NSString *)hintText{
    self.hintLabel.text = hintText.copy;
}

@end
