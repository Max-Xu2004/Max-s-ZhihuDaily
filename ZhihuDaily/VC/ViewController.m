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
#import "BannerModel.h"
#import "NewsViewController.h"
#import "SessionManager.h"
#import "MJRefresh.h"
#import "TableViewHeaderView.h"
#import "CollectionViewCell.h"
#import "BannerSessionManager.h"
#import "LoginViewController.h"

#define stautsBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
static NSString *apiPrefix= @"https://news-at.zhihu.com/api/3/stories/before/";

@interface ViewController () <UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UILabel *sayhi; //根据时间显示早上好，下午好，晚上好；
@property (nonatomic,strong) UILabel *monthView; //当前月份显示
@property (nonatomic,strong) UILabel *dayView; //当前日期显示
@property (nonatomic,strong) UITableView *tableView; //该TableView用来展示首页新闻
@property (nonatomic,strong) NSMutableArray<NSArray *> *newsArray; //存放请求数据的数组
@property (nonatomic,strong) NSMutableArray *bannerArray; //用来存放前五天的新闻数据生成banner
@property (nonatomic,strong) WKWebView *webView; //用于浏览新闻网页
@property (nonatomic,strong) NSDate *date; //用于存放当前日期
@property (nonatomic,assign) NSInteger counter; //计数器，用来计算请求历史数据的次数
@property (nonatomic,assign) NSTimeInterval oneDay; //为一天有多少秒，便于计算前后日期，获取历史新闻
@property (nonatomic,strong) NSDateFormatter *formatter; //8位数日期格式
@property (nonatomic,strong) NSDateFormatter *formatter2; //"x月x日"格式
@property (nonatomic,strong) NSLock *lock; //使用nslock使进程优先请求，避免重复请求导致历史新闻排序混乱
@property (nonatomic,strong) UICollectionView *collectionView; //轮播图
@property (nonatomic,strong) UIButton *login; //登陆的头像按钮
@property (nonatomic,strong) NSTimer *scrollTimer; //轮播图计时器
@property (nonatomic,strong) UIView *topView; //头视图信息显示区域


@end

@implementation ViewController

bool loginOrNot = NO; //该变量用于确认是否登陆

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self addTapGesture];
    
    self.lock = [[NSLock alloc]init]; //初始化线程锁
    [self nsDateInit]; //初始化NSDate相关变量
    [self getLatestNews]; //获取最新新闻
    [self bannerInit]; //banner初始化
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.sayhi];
    [self.topView addSubview:self.monthView];
    [self.topView addSubview:self.dayView];
    [self.topView addSubview:self.login];
    [self.view addSubview:self.tableView];
    [self.login addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    [self frameInit];
} //viewDidLoad结束位置


#pragma mark -懒加载
-(UILabel *)sayhi{
    if(_sayhi == nil){
        _sayhi = [[UILabel alloc]init];
        _sayhi.font = [UIFont boldSystemFontOfSize:25];
        _sayhi.text = [self greeting];
    }
    return _sayhi;
}

-(UILabel *)monthView{
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
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, stautsBarHeight+60, self.view.frame.size.width, self.view.frame.size.height-stautsBarHeight-60) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90; //写死防止排版出问题
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //取消分割线

        
        [_tableView registerClass:TableViewCell.class forCellReuseIdentifier:TableViewCellReuseIdentifier];
        [_tableView registerClass:TableViewHeaderView.class forHeaderFooterViewReuseIdentifier:TableViewHeaderViewReuseIdentifier];
        
        self.tableView.tableHeaderView = self.collectionView;
        
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(viewRefresh)];

        
    }
    return _tableView;
}

- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat space = 10;
        CGFloat width = self.view.frame.size.width - 2 * space;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(space, 100, width, width) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:CollectionViewCell.class forCellWithReuseIdentifier:CollectionViewCellReuseIdentifier];
    }
    return _collectionView;
}

- (UIButton *)login{
    if(_login == nil){
        _login = [[UIButton alloc]init];
        [_login setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    }
    return _login;
}

- (UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        [self addTapGesture];
    }
    return _topView;
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
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellReuseIdentifier forIndexPath:indexPath];
    
    Model *model = self.newsArray[indexPath.section][indexPath.row];
    
    cell.imgURL = model.images;
    cell.title = model.title;
    cell.hint = model.hint;
    
    return cell;
}

#pragma mark -tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Model *model = self.newsArray[indexPath.section][indexPath.row];
    NewsViewController *newsVC = [[NewsViewController alloc]init];
    newsVC.newsURL = model.url;
    newsVC.idNum = model.idNum;
    [self.navigationController pushViewController:newsVC animated:YES];
}

#pragma mark - 新闻列表刷新（获取历史新闻）
- (void)viewRefresh{

    [self.lock lock];
    
    NSDate *theDate = [[NSDate alloc]init];
    theDate = [self.date initWithTimeIntervalSinceNow:self.oneDay*self.counter*-1];
    NSString *dateString = [self.formatter stringFromDate:theDate];
    self.counter++;
    NSString *apiString = [apiPrefix stringByAppendingString:dateString];
    
    
    [SessionManager getDatawithapiURL:apiString Success:^(NSArray * _Nonnull array) {
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
#pragma mark -HeaderViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) return 0;
    else return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

// Section header & footer information.

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableViewCellReuseIdentifier];
    if (headerView == nil) {
        headerView = [[TableViewHeaderView alloc] initWithReuseIdentifier:TableViewCellReuseIdentifier];
    }
    
    headerView.date = [self.formatter2 stringFromDate:[self.date initWithTimeIntervalSinceNow:self.oneDay*section*-1]];
    return headerView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bannerArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    BannerModel *bModel = self.bannerArray[indexPath.row];
    
    cell.imgLink = bModel.image;
    cell.titleText = bModel.title;
    cell.hintText = bModel.hint;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BannerModel *bModel = self.bannerArray[indexPath.row];
    NewsViewController *newsVC = [[NewsViewController alloc]init];
    newsVC.newsURL = bModel.url;
    newsVC.idNum = bModel.idNum;  //向newsVC传递新闻的链接和id数，用于浏览新闻和获取点赞数和评论数等extra信息
    [self.navigationController pushViewController:newsVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self adjustPicturePosition];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.scrollTimer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self performSelector:@selector(continueScrollTimer) withObject:nil afterDelay:3.0];
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.frame.size;
}

#pragma mark - 登录按钮点击事件
- (void)loginButtonClick:(UIButton*)button{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}



- (void)adjustPicturePosition {
    // 拿到图片的X
    CGFloat offsetX = self.collectionView.contentOffset.x;
    // 计算是第几张图
    CGFloat offsetItemNum = offsetX / self.collectionView.bounds.size.width;
    // 红色图1的位置
    if (offsetItemNum == 7 - 1) {
        // 设置的绿色图1的位置
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width, 0) animated:NO];
    } else if (offsetItemNum == 0) {
        // 红色图4
        // 设置为绿色图4的位置
        [self.collectionView setContentOffset:CGPointMake((7 - 2) * self.collectionView.bounds.size.width, 0) animated:NO];
    }
    // 四舍五入(主要是为了滑动到一半的图片设置pagecontrol)
    // 拿到当前的图片count
//    NSInteger pageNum = (NSInteger)round(offsetItemNum);
    // 设置页数
//    if  self.pageControl.currentPage = item;
}
#pragma mark - 恢复自动轮播
-(void) continueScrollTimer{
    [self.scrollTimer setFireDate:[NSDate distantPast]];
}
#pragma mark - 自动轮播
-(void) scrollToNextPage:(NSTimer *)timer
{
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x+self.collectionView.bounds.size.width, 0) animated:YES];
}



#pragma mark - 获取最新新闻
-(void) getLatestNews{
    self.newsArray = [[NSMutableArray alloc]init]; //
    [SessionManager getDatawithapiURL:@"https://news-at.zhihu.com/api/3/news/latest" Success:^(NSArray * _Nonnull array) {
        [self.newsArray addObject:array];
        [self.tableView reloadData]; //刷新数据
            } Failure:^{
        NSLog(@"Error ");
            }];
}

#pragma mark - 位置初始化
-(void) frameInit{
    //设置问候语的位置
    [self.sayhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(stautsBarHeight);
        make.left.equalTo(self.view).mas_offset(60);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    //设置月份显示的位置
    [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(stautsBarHeight+25);
        make.left.equalTo(self.view).mas_offset(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    //设置日期显示的位置
    [self.dayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).mas_offset(stautsBarHeight+5);
            make.left.equalTo(self.view).mas_offset(22);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(20);
    }];
    //设置tableView的位置
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.view).mas_offset(stautsBarHeight+60);
//        make.bottom.equalTo(self.view).mas_offset(0);
//        make.left.equalTo(self.view).mas_offset(0);
//        make.right.equalTo(self.view).mas_offset(0);
//    }];
    //设置login按钮的位置
    [self.login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(stautsBarHeight+5);
        make.right.equalTo(self.view).mas_offset(-20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
}
#pragma mark - 初始化nsdate变量
-(void) nsDateInit{
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"yyyyMMdd";
    self.formatter2 = [[NSDateFormatter alloc] init];
    self.formatter2.dateFormat = @"MM月dd日";
    self.counter = 0;
    self.oneDay = 86400; //
    self.date = [[NSDate alloc]init];
    self.date = [NSDate date]; //初始化日期计算有关变量
}
#pragma mark - Banner初始化
-(void) bannerInit{
    [BannerSessionManager getBannerDatawithSuccess:^(NSArray * _Nonnull array) {
        self.bannerArray = [[NSMutableArray alloc]initWithArray:array];
        [self.bannerArray addObject:self.bannerArray[0]];
        [self.bannerArray insertObject:self.bannerArray[4] atIndex:0];
            [self.collectionView reloadData];
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width, 0) animated:NO];
        } Failure:^{
            NSLog(@"Error");
        }];
}
#pragma mark - 问候语判断
-(NSString *) greeting{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    long hour = [calendar component:NSCalendarUnitHour fromDate:[NSDate date]];
    NSLog(@"%ld",hour);
   //从这里开始为根据时间对问候文本的判定
    if(hour>=0&&hour<6) return @"早点休息";
    else if (hour>=6&&hour<12) return @"知乎日报";
    else if (hour==12) return @"知乎日报";
    else if (hour>12&&hour<18) return @"知乎日报";
    else if (hour>=18&&hour<23) return @"晚上好！";
    else return @"早点休息";
}

#pragma mark -轻点顶部返回
- (void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.topView addGestureRecognizer:tap];
}

-(void)tapAction{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    NSLog(@"111");
}

@end
    
