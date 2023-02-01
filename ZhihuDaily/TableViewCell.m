//
//  TableViewCell.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/1.
//

#import "TableViewCell.h"
#import "UIimageView+WebCache.h"

#pragma mark - TableViewCell ()

@interface TableViewCell ()

@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *titleLab;

@end

@implementation TableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}

#pragma mark - 设置大小
- (void)layoutIfNeeded{
    CGFloat space = 2;
    CGFloat side = self.contentView.frame.size.height- 2 * space;
    self.imgView.frame = CGRectMake(space, space, side, side);
    self.titleLab.frame = CGRectMake(2 * space + side, space, 300, 40);
}

#pragma mark - 懒加载

-(UIImageView *)imgView{
    if(_imgView == nil){
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}

-(UILabel *)titleLab{
    if(_titleLab == nil){
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont boldSystemFontOfSize:14];
        _titleLab.numberOfLines = 2;
    }
    return _titleLab;
}

#pragma mark - Setter

- (void)setImgURL:(NSString *)imgURL{
    _imgURL = imgURL.copy;
    NSURL *URL = [NSURL URLWithString:imgURL]; //将NSString的图片链接文本转换为NSURL
    [_imgView sd_setImageWithURL:URL];
//    self.imgView.image = [UIImage imageNamed:imgName];
}

-(void)setTitle:(NSString *)title{
    self.titleLab.text = title.copy;
}

#pragma mark - Getter

- (NSString *)title{
    return self.titleLab.text;
}

@end
