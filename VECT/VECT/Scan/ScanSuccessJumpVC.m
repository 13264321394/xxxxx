//
//  ScanSuccessJumpVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 16/8/29.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "ScanSuccessJumpVC.h"
#import "SGWebView.h"
#import "Masonry.h"

@interface ScanSuccessJumpVC () <SGWebViewDelegate>
@property (nonatomic , strong) SGWebView *webView;
@end

@implementation ScanSuccessJumpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //网页位置下移/偏移
    self.automaticallyAdjustsScrollViewInsets = NO;  //oc
    
    [self setupNavigationItem];
   
    if (self.jump_bar_code) {
        [self setupLabel];
    } else {
        [self setupWebView];
    }
}

- (void)setupNavigationItem {
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, StatusbarHeight+44)];
    //view1.backgroundColor=[UIColor colorWithRed:237/255.0 green:59/255.0 blue:87/255.0 alpha:1.0f];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    
    UILabel *forgetPawLabel=[[UILabel alloc] init];
    forgetPawLabel.text=@"提示";
    forgetPawLabel.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:forgetPawLabel];
    [forgetPawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight);
        make.left.mas_equalTo(GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/2, 44));
    }];
    
    UIButton *backbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/50, StatusbarHeight+7, 18, 30)];
    [backbutton setImage:[UIImage imageNamed:@"返回 copy.png"] forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:backbutton];
    
    UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, 10)];
    view2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view2];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:self action:@selector(right_BarButtonItemAction)];
}

- (void)backMethod {
    //if (self.comeFromVC == ScanSuccessJumpComeFromWB) {
    //    [self.navigationController popViewControllerAnimated:YES];
    //}
    
    if (self.comeFromVC == ScanSuccessJumpComeFromWC) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)right_BarButtonItemAction {
    [self.webView reloadData];
}

// 添加Label，加载扫描过来的内容
- (void)setupLabel {
    // 提示文字
    UILabel *prompt_message = [[UILabel alloc] init];
    prompt_message.frame = CGRectMake(0, 200, self.view.frame.size.width, 30);
    prompt_message.text = @"已扫描到以下内容：";
    prompt_message.textColor = [UIColor blackColor];
    prompt_message.font=[UIFont systemFontOfSize:16.f];
    prompt_message.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:prompt_message];
    
    // 扫描结果
    CGFloat label_Y = CGRectGetMaxY(prompt_message.frame);
    
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(20, 100, GZDeviceWidth-2*20, 20);
    lab.textColor = [UIColor lightGrayColor];
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:18.f];
    lab.text = self.jump_bar_code;
    CGSize titleSize = [lab.text sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake(self.view.frame.size.width-40, GZDeviceHeight/2)];
    lab.frame = CGRectMake(3, 3, titleSize.width, titleSize.height);
    lab.backgroundColor=[UIColor whiteColor];
    
    
    UIView *backgView=[[UIView alloc] initWithFrame:CGRectMake(20-3, label_Y+20-3, titleSize.width+6, titleSize.height+6)];
    backgView.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:backgView];
    backgView.layer.cornerRadius = 3;
    backgView.layer.masksToBounds = YES;
    
    [backgView addSubview:lab];
}

// 添加webView，加载扫描过来的内容
- (void)setupWebView {
    CGFloat webViewX = 0;
    CGFloat webViewY = StatusbarHeight+44;
    CGFloat webViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat webViewH = [UIScreen mainScreen].bounds.size.height-(StatusbarHeight+44);
    self.webView = [SGWebView webViewWithFrame:CGRectMake(webViewX, webViewY, webViewW, webViewH)];
    if (self.comeFromVC == ScanSuccessJumpComeFromWB) {
        _webView.progressViewColor = [UIColor orangeColor];
    };
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.jump_URL]]];
    _webView.SGQRCodeDelegate = self;
    [self.view addSubview:_webView];
}

- (void)webView:(SGWebView *)webView didFinishLoadWithURL:(NSURL *)url {
    NSLog(@"didFinishLoad");
    
    self.title = webView.navigationItemTitle;
}


@end

