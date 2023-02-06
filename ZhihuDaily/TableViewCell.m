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
#pragma mark - 设置大小
- (void)layoutIfNeeded{
//    CGFloat space = 2;
//    CGFloat side = self.contentView.frame.size.height- 2 * space;
//    self.imgView.frame = CGRectMake(space, space, side, side);
//    self.titleLab.frame = CGRectMake(2 * space + side, space, 300, 40); //测试数据
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo
//    }];

//设置新闻图片位置
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(10);
        make.bottom.equalTo(self.contentView).mas_offset(-10);
        make.right.equalTo(self.contentView).mas_offset(-10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(70);
    }];
//设置新闻标题位置
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(10);
        make.bottom.equalTo(self.hintLab).mas_offset(-20);
        make.left.equalTo(self.contentView).mas_offset(18);
        make.right.equalTo(self.imgView).mas_offset(-80);
    }];
//设置作者名、阅读时间位置
    [self.hintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).mas_offset(-10);
        make.left.equalTo(self.contentView).mas_offset(18);
        make.right.equalTo(self.imgView).mas_offset(-80);
        make.height.mas_equalTo(12);
    }];
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
    }
    return _hintLab;
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

-(void)setHint:(NSString *)hint{
    self.hintLab.text = hint.copy;
}

#pragma mark - Getter

- (NSString *)title{
    return self.titleLab.text;
}

@end
