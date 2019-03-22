//
//  WebViewController.m
//  tools
//
//  Created by jike1 on 2019/3/22.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];
    if (_url) {
        NSURL *url = [NSURL URLWithString:_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
        [_webView loadRequest: request];
    }
}

- (void)initWebView {
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
//    config.requiresUserActionForMediaPlayback = YES;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"CalcBit_NewBeTools";
    
    
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    //初始化
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, width, height) configuration:config];
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    //可返回的页面列表, 存储已打开过的网页
//    WKBackForwardList * backForwardList = [_webView backForwardList];
    
    //        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chinadaily.com.cn"]];
    //        [request addValue:[self readCurrentCookieWithDomain:@"http://www.chinadaily.com.cn"] forHTTPHeaderField:@"Cookie"];
    //        [_webView loadRequest:request];
    //页面后退
//    [_webView goBack];
//    //页面前进
//    [_webView goForward];
//    //刷新当前页面
//    [_webView reload];
    
    [self.view addSubview:_webView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
