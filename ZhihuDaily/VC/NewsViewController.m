//
//  NewsViewController.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/2.
//

#import "NewsViewController.h"
#import "Masonry.h"
#import "ExtraSessionManager.h"

@interface NewsViewController () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) UIButton *back; //返回键

@property (nonatomic,strong) UIButton *comment; //评论图标

@property (nonatomic,strong) UILabel *commentLabel; //评论数显示

@property (nonatomic,strong) UIButton *like; //点赞按钮

@property (nonatomic,strong) UILabel *likeLabel; //点赞数显示

@property (nonatomic,strong) UIButton *favorites; //收藏按钮

@property (nonatomic,strong) UIButton *share; //分享按钮

@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,assign) UIUserInterfaceStyle mode;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //array[0]为评论数，array[1]为点赞数
    [ExtraSessionManager getExtraDatawithidNUM:_idNum Success:^(NSArray * _Nonnull array) {
        self.commentLabel.text = [NSString stringWithFormat:@"%@",array[0]];
        self.likeLabel.text = [NSString stringWithFormat:@"%@",array[1]];
        } Failure:^{
            NSLog(@"Error");
        }];
    
    self.mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
    if(self.mode == UIUserInterfaceStyleDark);
    else self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.back];
    [self.view addSubview:self.comment];
    [self.view addSubview:self.like];
    [self.view addSubview:self.favorites];
    [self.view addSubview:self.share];
    [self.view addSubview:self.likeLabel];
    [self.view addSubview:self.commentLabel];
    [self.back addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    [self.like addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.favorites addTarget:self action:@selector(buttonClick3:) forControlEvents:UIControlEventTouchUpInside];
    
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]  initWithTarget: self  action:@selector(edgePan:)];
        edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
   
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.view).mas_offset(10);
        make.bottom.equalTo(self.view).mas_offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.back).mas_offset(50);
        make.bottom.equalTo(self.view).mas_offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.comment).mas_offset(35);
        make.bottom.equalTo(self.view).mas_offset(-30);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.like mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.comment).mas_offset(80);
        make.bottom.equalTo(self.view).mas_offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.like).mas_offset(35);
        make.bottom.equalTo(self.view).mas_offset(-30);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(10);
    }];
    
    [self.favorites mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.like).mas_offset(80);
        make.bottom.equalTo(self.view).mas_offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.share mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.favorites).mas_offset(80);
        make.bottom.equalTo(self.view).mas_offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
}
#pragma mark - 懒加载
-(WKWebView *)webView{
    if(_webView == nil){
        _webView = [[WKWebView alloc]init];
        NSURL *url = [NSURL URLWithString:self.newsURL];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
    }
    return _webView;
}

- (UIButton *)back{
    if(_back == nil){
        _back = [[UIButton alloc]init];
        [_back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    return _back;
}

- (UIButton *)comment{
    if(_comment == nil){
        _comment = [[UIButton alloc]init];
        [_comment setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    }
    return _comment;
}

- (UIButton *)like{
    if(_like == nil){
        _like = [[UIButton alloc]init];
        [_like setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    return _like;
}

- (UIButton *)favorites{
    if(_favorites == nil){
        _favorites = [[UIButton alloc]init];
        [_favorites setImage:[UIImage imageNamed:@"favorites"] forState:UIControlStateNormal];
    }
    return _favorites;
}

- (UIButton *)share{
    if(_share == nil){
        _share = [[UIButton alloc]init];
        [_share setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    }
    return _share;
}

- (UILabel *)commentLabel{
    if(_commentLabel == nil){
        _commentLabel = [[UILabel alloc]init];
        _commentLabel.font = [UIFont systemFontOfSize:10];
    }
    return _commentLabel;
}

- (UILabel *)likeLabel{
    if(_likeLabel == nil){
        _likeLabel = [[UILabel alloc]init];
        _likeLabel.font = [UIFont systemFontOfSize:10];
        
    }
    return _likeLabel;
}

#pragma mark - 侧滑返回手势设置
   
-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 返回按钮事件
- (void)buttonClick1:(UIButton*)button{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 点赞按钮事件
- (void)buttonClick2:(UIButton*)button{
    
    self.like.selected =! self.like.selected;
    if(self.like.selected){
            [_like setImage:[UIImage imageNamed:@"likec"] forState:UIControlStateNormal];
            [self presentAlertControllerwithTitle:@"已点赞"];
            self.likeLabel.text = [NSString stringWithFormat:@"%d",[self.likeLabel.text intValue]+1];
        }
        else{
            [_like setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            [self presentAlertControllerwithTitle:@"已取消点赞"];
            self.likeLabel.text = [NSString stringWithFormat:@"%d",[self.likeLabel.text intValue]-1];
        }
    
}

#pragma mark - 收藏按钮事件
- (void)buttonClick3:(UIButton*)button{
    
    self.favorites.selected =! self.favorites.selected;
    if(self.favorites.selected){
            [_favorites setImage:[UIImage imageNamed:@"favoritesc"] forState:UIControlStateNormal];
        [self presentAlertControllerwithTitle:@"已收藏"];
        }
        else{
            [_favorites setImage:[UIImage imageNamed:@"favorites"] forState:UIControlStateNormal];
            [self presentAlertControllerwithTitle:@"已取消收藏"];
        }
    
}

#pragma mark - 弹出提示框
-(void)presentAlertControllerwithTitle:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:NULL preferredStyle:UIAlertControllerStyleAlert];
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [self presentViewController:alert animated:YES completion:^{
           
        }];
}

#pragma mark - 自动消失计时器
-(void) performDismiss:(NSTimer *)timer
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //屏蔽最顶部打开知乎日报和最底部进入知乎（去除页面”广告“元素）
    [webView evaluateJavaScript:@"document.getElementsByClassName('Daily')[0].remove();document.getElementsByClassName('    view-more')[0].remove();" completionHandler:nil];
    if(self.mode == UIUserInterfaceStyleDark){
        // 改变网页内容背景颜色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#8F999999'"completionHandler:nil];
        // 改变网页内容文字颜色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#8F999999'"completionHandler:nil];
    }
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{

}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

     NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}


@end
