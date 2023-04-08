//
//  TableViewCell.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/1.
//

#import "TableViewCell.h"
#import "UIimageView+WebCache.h"
#import "Masonry.h"

NSString *TableViewCellReuseIdentifier = @"TableViewCell";

#pragma mark - TableViewCell ()

@interface TableViewCell ()

@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *hintLab;

@end

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.hintLab];
    }
    return self;
}
#pragma mark - 计算titleLab行数并设置hintLab位置使二者紧贴
- (void)layoutIfNeeded{
    if([self.titleLab.text length]/16 == 0){
        self.hintLab.frame = CGRectMake(15, 55.5, self.titleLab.frame.size.width, 12);
    }
    else if ([self.titleLab.text length]/16 == 1 &&[self.titleLab.text length]%16 == 0){
        self.hintLab.frame = CGRectMake(15, 55.5, self.titleLab.frame.size.width, 12);
    }
    else{
        self.hintLab.frame = CGRectMake(15, 66.5, self.titleLab.frame.size.width, 12);
    }
}

#pragma mark - 懒加载

-(UIImageView *)imgView{
    if(_imgView == nil){
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-10, 10, 70, 70)];
    }
    return _imgView;
}

-(UILabel *)titleLab{
    if(_titleLab == nil){
//        _titleLab = [[UILabel alloc] init];
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.contentView.frame.size.width-40, 60)];
        _titleLab.font = [UIFont boldSystemFontOfSize:17];
        _titleLab.numberOfLines = 2;
    }
    return _titleLab;
}

-(UILabel *)hintLab{
    if(_hintLab == nil){
        _hintLab = [[UILabel alloc]init];
        _hintLab.font = [UIFont boldSystemFontOfSize:12];
        _hintLab.numberOfLines = 1;
        _hintLab.textColor = UIColor.grayColor;
    }
    return _hintLab;
}

#pragma mark - Setter

- (void)setImgURL:(NSString *)imgURL{
    _imgURL = imgURL.copy;
    NSURL *URL = [NSURL URLWithString:imgURL]; //将NSString的图片链接文本转换为NSURL
    [_imgView sd_setImageWithURL:URL];
}

-(void)setTitle:(NSString *)title{
    self.titleLab.text = title.copy;
}

-(void)setHint:(NSString *)hint{
    self.hintLab.text = hint.copy;
}

#pragma mark - Getter

- (NSString *)title{
    return self.titleLab.text;
}

@end
