//
//  informationdetailViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/30.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "informationdetailViewController.h"
#import "Masonry.h"

@interface informationdetailViewController ()<UIWebViewDelegate>

@end

@implementation informationdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //网页位置下移/偏移
    self.automaticallyAdjustsScrollViewInsets = NO;  //oc
    //self.automaticallyAdjustsScrollViewInsets = false;  //swift
    
    UIView *view0=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, StatusbarHeight+44)];
    view0.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    [self.view addSubview:view0];
    
    UILabel *forgetPawLabel=[[UILabel alloc] init];
    forgetPawLabel.text=@"资讯详情";
    forgetPawLabel.textAlignment = NSTextAlignmentCenter;
    [view0 addSubview:forgetPawLabel];
    [forgetPawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight);
        make.left.mas_equalTo((GZDeviceWidth-GZDeviceWidth/2)/2);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/2, 44));
    }];
    
    UIButton *backbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/50, StatusbarHeight+7, 30, 30)];
    [backbutton setImage:[UIImage imageNamed:@"theback1.png"] forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [view0 addSubview:backbutton];
    
    UIWebView *webView = [[UIWebView alloc] init];
    
    if (StatusbarHeight==44) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44+34))];
    } else {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44))];
    }
    
    //NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_str1]];
    NSLog(@"我的展示接口==%@", _str1);
    [webView setDelegate:self];//设置代理。这样上面的三个方法才能得到回调。
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    // Do any additional setup after loading the view.
}

/*
//是否允许加载网页，也可获取js要打开的url，通过截取此url可与js交互
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    NSLog(@"urlString=%@---urlComps=%@",urlString,urlComps);
    return YES;
}
*/

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"web开始加载数据");
    //[activityIndicator startAnimating];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"web数据加载完");
}

//网页加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSURLRequest *request = webView.request;
    NSLog(@"didFailLoadWithError-url=%@--%@",[request URL],[request HTTPBody]);
    NSLog(@"web网页加载错误");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
        theLabel.backgroundColor=[UIColor blackColor];
        theLabel.textColor=[UIColor whiteColor];
        theLabel.alpha=0.8f;
        theLabel.textAlignment=NSTextAlignmentCenter;
        theLabel.font=[UIFont systemFontOfSize:15.f];
        theLabel.text=@"网页加载错误";
        [self.view addSubview:theLabel];
        
        //设置动画
        CATransition *transion=[CATransition animation];
        transion.type=@"push";//动画方式
        transion.subtype=@"fromLeft";//设置动画从哪个方向开始
        [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
        //不占用主线程
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
            [theLabel removeFromSuperview];
            
        });//这句话的意思是1.5秒后，把label移出视图
    });
}

-(void)backMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
