//
//  TableViewHeaderView.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/5.
//

#import "TableViewHeaderView.h"

NSString *TableViewHeaderViewReuseIdentifier = @"TableViewHeaderView";


#pragma mark - TableViewHeaderView()

@interface TableViewHeaderView ()

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation TableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}

- (void)updateConfigurationUsingState:(UIViewConfigurationState *)state {
    self.titleLab.frame = CGRectMake(15, -8, 70, 30);
    self.titleLab.backgroundColor = UIColor.whiteColor;
}

#pragma mark - Lazy

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:15];
//        self.titleLab.text = @"1";
        
    }
    return _titleLab;
}

#pragma mark - Setter
- (void)setDate:(NSString *)date{
    _date = date;
    self.titleLab.text = self.date;
}
@end
