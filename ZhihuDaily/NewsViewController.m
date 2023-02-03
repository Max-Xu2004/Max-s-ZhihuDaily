//
//  NewsViewController.m
//  ZhihuDaily
//
//  Created by 许晋嘉 on 2023/2/2.
//

#import "NewsViewController.h"
#import "Masonry.h"

@interface NewsViewController ()

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
}

-(WKWebView *)webView{
    if(_webView == nil){
        _webView = [[WKWebView alloc]init];
//        _webView.frame = CGRectMake(0, 0, 300, 600);
        NSURL *url = [NSURL URLWithString:_newsURL];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    return _webView;
}

//#pragma mark - Setter
//
//- (void)setUrl:(NSString *)url{
//    url
//}
   

@end
