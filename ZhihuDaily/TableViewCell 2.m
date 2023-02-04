//
//  TableViewCell.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/1.
//

#import "TableViewCell.h"

#pragma mark - TableViewCell()

@interface TableViewCell()

@property (nonatomic,strong) UIImageView *imgView;
@property (strong,nonatomic) UILabel *titleLab;

@end

@implementation TableViewCell

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        <#statements#>
    }
    return self;
}

@end
