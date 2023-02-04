//
//  ViewController.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/1/30.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "Masonry.h"
#import "Model.h"
#import "NewsViewController.h"
#import "SessionManager.h"
#import "MJRefresh.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel *sayhi; //根据时间显示早上好，下午好，晚上好；
@property (nonatomic,strong) UILabel *monthView; //当前月份显示
@property (nonatomic,strong) UILabel *dayView;
@property (nonatomic,strong) UITableView *tableView; //该TableView用来展示首页新闻
@property (nonatomic,strong) NSMutableArray<NSArray *> *newsArray; //存放请求数据的数组
@property (nonatomic,strong) WKWebView *webView; //用于浏览新闻网页
@property (nonatomic,strong) NSDate *date; //用于存放当前日期
@property (nonatomic,assign) NSInteger counter; //计数器，用来计算请求历史数据的次数
@property (nonatomic,assign) NSTimeInterval oneDay; //为一天有多少秒，便于计算前后日期，获取历史新闻
@property (nonatomic,strong) NSDateFormatter *formatter; //8位数日期格式
@property (nonatomic,strong) NSLock *lock;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.lock = [[NSLock alloc]init];
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"yyyyMMdd";
    self.counter = 0;
    self.oneDay = 86400; //
    self.date = [[NSDate alloc]init];
    self.date = [NSDate date]; //初始化日期计算有关变量

    
    
    self.newsArray = [[NSMutableArray alloc]init]; //
    [SessionManager getDatawithapiURL:@"https://news-at.zhihu.com/api/3/news/latest" Success:^(NSArray * _Nonnull array) {
        NSLog(@"aaa%@",self.newsArray);
        [self.newsArray addObject:array];
        
                    [self.tableView reloadData]; //刷新数据
        NSLog(@"数组内容为%@",self.newsArray);
        } Failure:^{
            NSLog(@"Error ");
        }];
    
//
    

    [self.view addSubview:self.sayhi];
    [self.view addSubview:self.monthView];
    [self.view addSubview:self.dayView];
    [self.view addSubview:self.tableView];
    //设置问候语的位置
    [self.sayhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(40);
        make.left.equalTo(self.view).mas_offset(60);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    //设置月份显示的位置
    [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(65);
        make.left.equalTo(self.view).mas_offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    //设置日期显示的位置
    [self.dayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).mas_offset(45);
            make.left.equalTo(self.view).mas_offset(28);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(20);
    }];
    //设置tableView的相对位置
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).mas_offset(100);
        make.bottom.equalTo(self.view).mas_offset(0);
        make.left.equalTo(self.view).mas_offset(0);
        make.right.equalTo(self.view).mas_offset(0);
    }];
    
} //viewDidLoad结束位置


#pragma mark -懒加载
-(UILabel *)sayhi{
    if(_sayhi == nil){
        _sayhi = [[UILabel alloc]init];
        _sayhi.font = [UIFont systemFontOfSize:25];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        long hour = [calendar component:NSCalendarUnitHour fromDate:[NSDate date]];
        
        
        
//        long minute = [calendar component:NSCalendarUnitMinute fromDate:[NSDate date]];
        NSLog(@"%ld",hour);
       //从这里开始为根据时间对问候文本的判定
        if(hour>=0&&hour<6) _sayhi.text = @"早点休息";
        else if (hour>=6&&hour<12) _sayhi.text = @"知乎日报";
        else if (hour==12) _sayhi.text = @"知乎日报";
        else if (hour>12&&hour<18) _sayhi.text = @"知乎日报";
        else if (hour>=18&&hour<23) _sayhi.text = @"晚上好！";
        else if (hour>=23) _sayhi.text = @"早点休息";
        //判定结束
        NSLog(@"%@",_sayhi.text);
        
//        _sayhi.frame = CGRectMake(100, 100, 150 , 50);
        _sayhi.backgroundColor = UIColor.whiteColor;
    }
    return _sayhi;
}

-(UILabel *)monthView{
    
//    NSDate *a;
//    NSCalendar *b;
//    NSDateFormatter *c;
//    NSDateComponents *d;
    
    if(_monthView == nil){
        _monthView = [[UILabel alloc]init];
        _monthView.font = [UIFont systemFontOfSize:18];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        long month = [calendar component:NSCalendarUnitMonth fromDate:[NSDate date]];//获取月份
        NSLog(@"%ld",month);
        //这里开始将数字的月份转换为中文的月份
        NSString *monthString;
        if (month == 1) monthString = @"一月";
        else if (month == 2) monthString = @"二月";
        else if (month == 3) monthString = @"三月";
        else if (month == 4) monthString = @"四月";
        else if (month == 5) monthString = @"五月";
        else if (month == 6) monthString = @"六月";
        else if (month == 7) monthString = @"七月";
        else if (month == 8) monthString = @"八月";
        else if (month == 9) monthString = @"九月";
        else if (month == 10) monthString = @"十月";
        else if (month == 11) monthString = @"十一月";
        else if (month == 12) monthString = @"十二月";
        //
        _monthView.text = monthString;
        _monthView.font = [UIFont systemFontOfSize:15];
        
    }
    return  _monthView;
}
-(UILabel *)dayView{
    if(_dayView == nil){
        _dayView = [[UILabel alloc]init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        long day = [calendar component:NSCalendarUnitDay fromDate:[NSDate date]];//获取天数
        NSString *dayString = [NSString stringWithFormat:@"%ld",day ]; //将天数转换为NSString类型
        _dayView.text = dayString;
        _dayView.font = [UIFont systemFontOfSize:25];
    }
    return _dayView;
}
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]init];
//        _tableView.frame = CGRectMake(0, 100, 400, 500);//临时调试的位置
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 100;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.orangeColor; //仅用于调试
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(viewRefresh)];

        
    }
    return _tableView;
}

#pragma mark -tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArray[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.newsArray.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [[TableViewCell alloc]init];
    
    Model *model = self.newsArray[indexPath.section][indexPath.row];
    
    cell.imgURL = model.images;
    cell.title = model.title;
    cell.hint = model.hint;
    
    return cell;
}

#pragma mark -tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Model *model = self.newsArray[indexPath.section][indexPath.row];
    NSLog(@"对应的新闻链接为%@",model.url);
    NSLog(@"单击了第%ld条信息",indexPath.row);
    NewsViewController *newsVC = [[NewsViewController alloc]init];
    newsVC.newsURL = model.url;
    [self presentViewController:newsVC animated:YES completion:nil];
}

#pragma mark - 新闻列表刷新
- (void)viewRefresh{

    [self.lock lock];
    
    NSDate *theDate = [[NSDate alloc]init];
    theDate = [self.date initWithTimeIntervalSinceNow:self.oneDay*self.counter*-1];
    NSString *dateString = [self.formatter stringFromDate:theDate];
    NSLog(@"日期%@",dateString);
    self.counter++;
    NSString *apiPrefix = @"https://news-at.zhihu.com/api/3/stories/before/";
    NSString *apiString = [apiPrefix stringByAppendingString:dateString];
    
    
    [SessionManager getDatawithapiURL:apiString Success:^(NSArray * _Nonnull array) {
        NSLog(@"aaa%@",self.newsArray);
        [self.newsArray addObject:array];
        
                    [self.tableView reloadData]; //刷新数据
        NSLog(@"数组内容为%@",self.newsArray);
        [self.tableView beginUpdates];
        [self.tableView reloadData]; //刷新数据
        [self.tableView endUpdates];
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(viewRefresh)];
        [self.lock unlock];
        } Failure:^{
            NSLog(@"Error ");
        }];
    
    

}



@end
    
