//
//  brmonViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/5.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "brmonViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "newaddressViewController.h"
#import "LMJDropdownMenu.h"
#import "Reachability.h"
#import <GT3Captcha/GT3Captcha.h>
#import "CustomButton.h"

@interface brmonViewController ()<UITextFieldDelegate,GT3CaptchaManagerDelegate, CaptchaButtonDelegate,LMJDropdownMenuDelegate>

@property(nonatomic,retain)UITextField *tewPaswTextField;
@property(nonatomic,retain)UITextField *confirmTextField;
@property (strong, nonatomic)NSTimer *timer;
@property(nonatomic, assign)NSInteger count;
@property(nonatomic, assign)float h;
@property(strong, nonatomic) UIImageView *graimageView;
@property(strong, nonatomic)NSMutableArray *datasource1;
@property(strong, nonatomic)NSMutableArray *datasource2;
@property (nonatomic, strong) GT3CaptchaButton *captchaButton;
@property (strong, nonatomic) CustomButton *codeButton;
@property(nonatomic, assign)NSInteger selectRow;
@property (strong, nonatomic)LMJDropdownMenu  *dropdownMenu;
@property(copy, nonatomic)NSString *theidStr;//地址对应的id

@end

@implementation brmonViewController
{
    NSString *_languageStr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self dataquery];//添加数据，获取数组对应的id
    LMJDropdownMenu  *dropdownMenu = [[LMJDropdownMenu alloc] init];
    [dropdownMenu setFrame:CGRectMake(GZDeviceWidth/4+10, StatusbarHeight+44+10+self.h/5/2, GZDeviceWidth*2/3, self.h*4/5)];
    //dropdownMenu.center=self.view.center;
    [dropdownMenu setMenuTitles:self.datasource1 rowHeight:self.h*4/5];
    dropdownMenu.delegate = self;
    [self.view addSubview:dropdownMenu];
    self.dropdownMenu=dropdownMenu;
}

- (GT3CaptchaButton *)captchaButton {
    if (!_captchaButton) {
        //创建验证管理器实例
        
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *api_1=[NSString stringWithFormat:@"http://vectwallet.com/gt/register4?uuid=%@&typeId=9", myUUIDStr];
        
        GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_1 timeout:5.0];
        
        captchaManager.delegate = self;
        captchaManager.maskColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        //debug mode
        //[captchaManager enableDebugMode:YES];
        //创建验证视图的实例
        _captchaButton = [[GT3CaptchaButton alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/4+GZDeviceWidth-10-GZDeviceWidth/4-GZDeviceWidth/3+GZDeviceWidth/15, StatusbarHeight+44+10+self.h+1+self.h+1+(self.h-self.h*2.9/4)/2, GZDeviceWidth/4, self.h*2.9/4) captchaManager:captchaManager];
        _captchaButton.layer.borderWidth = 0.5f;
        //给按钮设置角的弧度
        _captchaButton.layer.cornerRadius = 10.0f;
        
    }
    
    return _captchaButton;
}

- (void)createDefaultButton {
    
    //添加验证按钮到父视图上
    self.captchaButton.frame=CGRectMake(10+GZDeviceWidth/4+GZDeviceWidth-10-GZDeviceWidth/4-GZDeviceWidth/3+GZDeviceWidth/15, StatusbarHeight+44+10+self.h+1+self.h+1+(self.h-self.h*3/4)/2, GZDeviceWidth/4, self.h*3/4);
    //self.captchaButton.layer.borderWidth = 0.5f;
    //self.captchaButton.layer.cornerRadius=10.0f;
    //推荐直接开启验证
    [self.captchaButton startCaptcha];
    [self.view addSubview:self.captchaButton];
}

- (void)setupLoginButton {
    
    _codeButton = [[CustomButton alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/4+GZDeviceWidth-12-GZDeviceWidth/4-GZDeviceWidth/3+GZDeviceWidth/15, StatusbarHeight+44+10+self.h+1+self.h+1+(self.h-self.h*3.6/4)/2, GZDeviceWidth/3.9, self.h*3.6/4)];
    
    _codeButton.delegate = self;
    //_button.backgroundColor = [UIColor colorWithRed:0.3 green:0.63 blue:1.0 alpha:1.0];
    [_codeButton setClipsToBounds:YES];
    
    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:(10+GZDeviceWidth/30)/2.f];
    _codeButton.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_codeButton];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:4+GZDeviceWidth/36];
    [_codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _codeButton.layer.borderColor = [[UIColor redColor] CGColor];
    //设置边框宽度
    _codeButton.layer.borderWidth = 0.3f;
    //给按钮设置角的弧度
    _codeButton.layer.cornerRadius = 3.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.h=15+GZDeviceHeight/20;
    
    UILabel *forgetPawLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-80)/2, 20, 80, 30)];
    forgetPawLabel.text=@"我要提币";
    forgetPawLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:forgetPawLabel];
    [forgetPawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight);
        make.left.mas_equalTo(GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/2, 44));
    }];
    
    UIButton *backbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/50, StatusbarHeight+7, 18, 30)];
    [backbutton setImage:[UIImage imageNamed:@"返回 copy.png"] forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    
    UIButton *netabutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*3.9/5, StatusbarHeight+7, GZDeviceWidth/4.8, 30)];
    [netabutton setTitle:@"新增地址" forState:UIControlStateNormal];
    netabutton.titleLabel.font=[UIFont systemFontOfSize:4+GZDeviceWidth/35];
    [netabutton setTitleColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [netabutton addTarget:self action:@selector(netaMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:netabutton];
    
    UIView *grayView=[[UIView alloc] init];
    grayView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 10));
    }];
    
    UILabel *phoneLabel=[[UILabel alloc] init];
    phoneLabel.text=@"选择地址";
    phoneLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, self.h));
    }];
    
    UIView *grayView1=[[UIView alloc] init];
    grayView1.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView1];
    [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+self.h);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UILabel *newPaswLabel=[[UILabel alloc] init];
    newPaswLabel.text=@"提币数量";
    newPaswLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    [self.view addSubview:newPaswLabel];
    [newPaswLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+self.h+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, self.h));
    }];
    
    _tewPaswTextField=[[UITextField alloc] init];
    _tewPaswTextField.placeholder=@"请输入100整数倍的提币数量";
    _tewPaswTextField.keyboardType=UIKeyboardTypeNumberPad;
    _tewPaswTextField.rightViewMode=UITextFieldViewModeAlways;
    _tewPaswTextField.adjustsFontSizeToFitWidth = YES;
    [_tewPaswTextField setClearsOnBeginEditing:YES];
    [_tewPaswTextField setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_tewPaswTextField];
    [_tewPaswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+self.h+1);
        make.left.mas_equalTo(10+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-10-GZDeviceWidth/4, self.h));
    }];
    
    UIView *grayView2=[[UIView alloc] init];
    grayView2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView2];
    [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+self.h+1+self.h);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UILabel *confirmLabel=[[UILabel alloc] init];
    confirmLabel.text=@"短信验证";
    confirmLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    [self.view addSubview:confirmLabel];
    [confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+self.h+1+self.h+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, self.h));
    }];
    
    _confirmTextField=[[UITextField alloc] init];
    _confirmTextField.placeholder=@"请输入6位验证码";
    _confirmTextField.keyboardType=UIKeyboardTypeNumberPad;
    _confirmTextField.rightViewMode=UITextFieldViewModeAlways;
    _confirmTextField.adjustsFontSizeToFitWidth = YES;
    [_confirmTextField setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    [_confirmTextField setClearsOnBeginEditing:YES];
    //_confirmTextField.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_confirmTextField];
    [_confirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+self.h+1+self.h+1);
        make.left.mas_equalTo(10+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-10-GZDeviceWidth/4-GZDeviceWidth/4, self.h));
    }];
    
    UIView *grayView4=[[UIView alloc] init];
    grayView4.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView4];
    [grayView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+self.h+1+self.h+1+1+self.h);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, GZDeviceHeight-(20+44+10+self.h+1+self.h+1+self.h)));
    }];
    
    
    [self createDefaultButton];
    [self setupLoginButton];
    
    
    UIButton *deterButton=[[UIButton alloc] init];
    [deterButton setTitle:@"确 认" forState:UIControlStateNormal];
    deterButton.titleLabel.font=[UIFont systemFontOfSize:8.5+GZDeviceWidth/35];
    deterButton.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    [deterButton addTarget:self action:@selector(deterMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deterButton];
    [deterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 25+GZDeviceHeight/30));
    }];
    
    UILabel *mylabel=[[UILabel alloc] init];
    mylabel.text=@"为了您的资金安全提币申请统一于工作日(周一至周五)9:00～18:00审核!";
    mylabel.textColor=[UIColor redColor];
    mylabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/30];
    mylabel.textAlignment=NSTextAlignmentLeft;
    mylabel.lineBreakMode=NSLineBreakByTruncatingTail;
    mylabel.numberOfLines=0;
    //mylabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mylabel];
    
    [mylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(StatusbarHeight+44+10+self.h+1+self.h+1+self.h);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-2*15, GZDeviceHeight/6));
    }];
    
    _datasource1=[[NSMutableArray alloc] init];
    _datasource2=[[NSMutableArray alloc] init];
    
    [self dataquery];//添加数据，获取数组对应的id
    
    /*
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(GZDeviceWidth/4+10, StatusbarHeight+44+10, GZDeviceWidth*2/3, self.h)];
    // 显示选中框
    //pickerView.backgroundColor=[UIColor cyanColor];
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    */
     
    NSLog(@"viewdidLoad里面的数组==%@", self.datasource1);
    
    //性别选择器
    //_languageArr = self.datasource1;
    LMJDropdownMenu  *dropdownMenu = [[LMJDropdownMenu alloc] init];
    [dropdownMenu setFrame:CGRectMake(GZDeviceWidth/4+10, StatusbarHeight+44+10+self.h/5/2, GZDeviceWidth*2/3, self.h*4/5)];
    //dropdownMenu.center=self.view.center;
    [dropdownMenu setMenuTitles:self.datasource1 rowHeight:self.h*4/5];
    dropdownMenu.delegate = self;
    [self.view addSubview:dropdownMenu];
    self.dropdownMenu=dropdownMenu;
    
    
    // Do any additional setup after loading the view.
}

- (BOOL)captchaButtonShouldBeginTapAction:(CustomButton *)button {
    
    return YES;
}

- (void)captcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error {
    //演示中全部默认为成功, 不对返回做判断
    
    NSLog(@"firstViewController执行了吗4");
    //[TipsView showTipOnKeyWindow:@"DEMO: 登录成功"];
}

#pragma MARK - GT3CaptchaManagerDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    
    NSLog(@"firstViewController执行了吗2");
    
    if (error.code == -999) {
        // 请求被意外中断, 一般由用户进行取消操作导致, 可忽略错误
    } else if (error.code == -10) {
        // 预判断时被封禁, 不会再进行图形验证
    } else if (error.code == -20) {
        // 尝试过多
    } else {
        // 网络问题或解析失败, 更多错误码参考开发文档
    }
    
    NSLog(@"处理验证中返回的错误%@", error.error_code);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
        theLabel.backgroundColor=[UIColor blackColor];
        theLabel.layer.cornerRadius = 5.f;
        theLabel.clipsToBounds = YES;
        theLabel.textColor=[UIColor whiteColor];
        theLabel.alpha=0.8f;
        theLabel.textAlignment=NSTextAlignmentCenter;
        theLabel.font=[UIFont systemFontOfSize:15.f];
        
        if (error.code==-1009) {
            theLabel.text=@"您没有连接网络！";
        } else if (error.code == -20) {
            // 尝试过多
            theLabel.text=@"尝试过多！";
        } else {
            // 网络问题或解析失败, 更多错误码参考开发文档
            theLabel.text=@"网络问题！";
        }
        
        [self.view addSubview:theLabel];
        
        //设置动画
        CATransition *transion=[CATransition animation];
        transion.type=@"push";//动画方式
        transion.subtype=@"fromTop";//设置动画从哪个方向开始
        [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
        //不占用主线程
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
            [theLabel removeFromSuperview];
            
        });//这句话的意思是1.5秒后，把label移出视图
    });
    
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    
    NSLog(@"firstViewController验证码图形出来后，点击了空白处，取消了验证");
    
    NSLog(@"User Did Close GTView.");
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    [mutStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空格
    NSRange range2 = {0, mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@" " options:NSLiteralSearch range:range2];//去掉字符串中的换行符
    
    return mutStr;
}

//不使用默认的二次验证接口
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message {
    
    NSLog(@"manager====%@", manager);
    NSLog(@"code====%@", code);
    NSLog(@"很重要的result====%@", result);
    NSLog(@"message====%@", message);
    
    __block NSMutableString *postResult = [[NSMutableString alloc] init];
    [result enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [postResult appendFormat:@"%@=%@&",key,obj];
    }];
    
    NSInteger num1=[_tewPaswTextField.text integerValue];
    
    if (_tewPaswTextField.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入提币数量" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ((_tewPaswTextField.text.length!=0) && (num1%100 != 0) )
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提币数量请输入100的整数" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ((_tewPaswTextField.text.length!=0) && (num1%100 == 0)) {
        
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *thephone=[userDefaults stringForKey:@"myPhone"];
        NSString *idstring=[userDefaults stringForKey:@"myuserId"];
        
        //NSURL *url = [NSURL URLWithString:@"http://vectwallet.com/gt/ajax-validate5"];
        NSURL *url=[NSURL URLWithString:[portUrl stringByAppendingString:@"/gt/ajax-validate5"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10.0f];//超过这个时间就算超时，请求失败
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setValue:thephone forKey:@"phone"];
        [parameters setValue:@"9" forKey:@"typeId"];
        [parameters setValue:idstring forKey:@"userId"];
        [parameters setValue:myUUIDStr forKey:@"uuid"];
        
        [parameters setValue:[result objectForKey:@"geetest_challenge"] forKey:@"geetest_challenge"];
        [parameters setValue:[result objectForKey:@"geetest_validate"] forKey:@"geetest_validate"];
        [parameters setValue:[result objectForKey:@"geetest_seccode"] forKey:@"geetest_seccode"];
        
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *args = [self convertToJsonData:parameters];
        request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
        // 3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.根据会话对象，创建一个Task任务
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            [manager closeGTViewIfIsOpen];
            
            // 10、判断是否请求成功
            if (error) {
                NSLog(@"post1 error :%@",error.localizedDescription);
            } else {
                NSLog(@"返回的response信息%@",response);
                id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                // 11、判断是否解析成功
                if (error) {
                    NSLog(@"post2 error :%@",error.localizedDescription);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*2/3)/2, GZDeviceHeight*2.5/5, GZDeviceWidth*2/3, 20+GZDeviceHeight/25)];
                        theLabel.backgroundColor=[UIColor blackColor];
                        theLabel.layer.cornerRadius = 5.f;
                        theLabel.clipsToBounds = YES;
                        theLabel.textColor=[UIColor whiteColor];
                        theLabel.alpha=0.8f;
                        theLabel.textAlignment=NSTextAlignmentCenter;
                        theLabel.font=[UIFont systemFontOfSize:15.f];
                        theLabel.text=@"验证码发送失败！请重新尝试";
                        [self.view addSubview:theLabel];
                        
                        //设置动画
                        CATransition *transion=[CATransition animation];
                        transion.type=@"push";//动画方式
                        transion.subtype=@"fromTop";//设置动画从哪个方向开始
                        [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                        //不占用主线程
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            [theLabel removeFromSuperview];
                            
                        });//这句话的意思是1.5秒后，把label移出视图
                    });
                    
                }else {
                    NSLog(@"请求成功");
                    // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                    NSLog(@"post success :%@",object1);
                    NSString *str0=[object1 objectForKey:@"code"];
                    NSString *str00=[NSString stringWithFormat:@"%@", str0];
                    NSString *str1=[object1 objectForKey:@"desc"];
                    NSDictionary *dic2=[object1 objectForKey:@"resultMap"];
                    NSLog(@"字典中解析出来的code:%@",str0);
                    NSLog(@"字典中解析出来的desc:%@",str1);
                    NSLog(@"字典中解析出来的resultMap:%@",dic2);
                    if ([str00 isEqualToString:@"200"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=str1;
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromRight";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                [theLabel removeFromSuperview];
                             
                            });//这句话的意思是1.5秒后，把label移出视图
                            
                            self.count=59;
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFired) userInfo:nil repeats:1];
                            
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=str1;
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromRight";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                        });
                    }
                }
            }
        }];
        
        [sessionDataTask resume];
        
    }
}

//处理你的验证结果
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    if (!error) {
        //处理你的验证结果
        //NSLog(@"处理你的验证结果2\ndata: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"处理你的验证结果2\nmanager %@", manager);
        NSLog(@"处理你的验证结果2\nsession ID: %@,\ndata: %@", [manager getCookieValue:@"msid"], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //成功请调用decisionHandler(GT3SecondaryCaptchaPolicyAllow)
        decisionHandler(GT3SecondaryCaptchaPolicyAllow);
        //失败请调用decisionHandler(GT3SecondaryCaptchaPolicyForbidden)
        //decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
    } else {
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        NSLog(@"validate error: %ld, %@", (long)error.code, error.localizedDescription);
        NSLog(@"二次验证发生错误%@", error.error_code);
    }
}

//修改API2的请求
- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendSecondaryCaptchaRequest:(NSURLRequest *)originalRequest withReplacedRequest:(void (^)(NSMutableURLRequest *))replacedRequest {
    
    NSLog(@"执行了吗7");
}

//是否开启二次验证
- (BOOL)shouldUseDefaultSecondaryValidate:(GT3CaptchaManager *)manager {
    NSLog(@"执行了吗1");
    
    return YES;
}

//修改API1的请求
- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    NSString *newURL = [NSString stringWithFormat:@"%@?t=%.0f", originalRequest.URL.absoluteString, [[[NSDate alloc] init] timeIntervalSince1970]];
    mRequest.URL = [NSURL URLWithString:newURL];
    
    replacedHandler(mRequest);
}

//添加数据
-(void)dataquery
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myuserId9=[userDefaults stringForKey:@"myuserId"];
    NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
    //我的界面里的提币地址
    NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/showTuserWithdrawSite"]];
    
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:mytoken forKey:@"token"];
    [parameters setValue:myuserId9 forKey:@"userId"];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *args = [self convertToJsonData:parameters];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 10、判断是否请求成功
        if (error) {
            NSLog(@"post error :%@",error.localizedDescription);
        }else {
            // 如果请求成功，则解析数据。
            //NSLog(@"返回的response信息%@",response);
            id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];//解析出返回的数据，如果是字典可以用字典接受
            // 11、判断是否解析成功
            if (error) {
                NSLog(@"post error :%@",error.localizedDescription);
            }else {
                // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                
                NSLog(@"post success啊 :%@",object1);
                NSString *str0=[object1 objectForKey:@"code"];
                NSString *str00=[NSString stringWithFormat:@"%@", str0];
                NSString *str1=[object1 objectForKey:@"desc"];
                NSDictionary *dic2=[object1 objectForKey:@"resultMap"];
                NSLog(@"字典中解析出来的code:%@",str0);
                NSLog(@"字典中解析出来的desc:%@",str1);
                NSLog(@"字典中解析出来的resultMap:%@",dic2);
                
                if ([str00 isEqualToString:@"0"]) {
                    NSLog(@"data 数组==%@", [dic2 objectForKey:@"data"]);
                    
                    NSArray *arr=[dic2 objectForKey:@"data"];
                    [self.datasource1 removeAllObjects];
                    [self.datasource2 removeAllObjects];
                    
                    for (int i=0; i<arr.count; i++) {
                        [self.datasource1 addObject:[[arr objectAtIndex:i] objectForKey:@"label"]];
                        [self.datasource2 addObject:[[arr objectAtIndex:i] objectForKey:@"id"]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [self.dropdownMenu setMenuTitles:self.datasource1 rowHeight:self.h*4/5];
                    });
                    
                    NSLog(@"我要的数组数据元素1aaaaaaaaaaaaaaaaaaaaaaaaaaa==%@",self.datasource1);
                    NSLog(@"我要的数组数据元素2aaaaaaaaaaaaaaaaaaaaaaaaaaa==%@",self.datasource2);
                    
                }
            }
        }
    }];
    
    //5.最后一步，执行任务，启动请求(resume也是继续执行)。
    [sessionDataTask resume];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    [_tewPaswTextField resignFirstResponder];
    [_confirmTextField resignFirstResponder];
    
    return YES;
}

//视图快消失时隐藏键盘
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_tewPaswTextField resignFirstResponder];
    [_confirmTextField resignFirstResponder];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //返回一个BOOL值，指定是否循序文本字段开始编辑,返回NO时不能唤起键盘进行编辑
    return YES;
}

-(void)backMethod{
    
    NSLog(@"点击了返回按钮");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)timerFired{
    
    if (_count != 0) {
        self.codeButton.enabled = NO;
        self.captchaButton.enabled=NO;
        [self.codeButton setTitle:[NSString stringWithFormat:@"剩余%ld秒", _count] forState:UIControlStateNormal];
        _count -= 1;
        
        //       [self setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateDisabled];
    } else {
        self.captchaButton.enabled=YES;
        self.codeButton.enabled = YES;
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        //        self.count = 60;
        _count=60;
        // 停掉定时器
        [self.timer invalidate];
        self.timer = nil;
    }
    NSLog(@"%ld",_count);
}

-(void)deterMethod
{
    NSLog(@"点击了我要提币界面的确认按钮");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *thephone=[userDefaults stringForKey:@"myPhone"];
    NSString *theid=[userDefaults stringForKey:@"myuserId"];
    NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
    
    NSInteger num1=[self.tewPaswTextField.text integerValue];
    
    //NSLog(@"self.theidStr===%@", self.theidStr);
    
     if (_tewPaswTextField.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入提币数量" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ((_tewPaswTextField.text.length!=0) && (num1%100 != 0) )
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提币数量请输入100的整数" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ((_tewPaswTextField.text.length!=0) && (num1%100 == 0) && (_confirmTextField.text.length==0)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入验证码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ((_tewPaswTextField.text.length!=0) && (num1%100 == 0) && (_confirmTextField.text.length!=0)) {
        
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/addUserWithdraw"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setValue:mytoken forKey:@"token"];
        [parameters setValue:thephone forKey:@"mobile"];
        [parameters setValue:_confirmTextField.text forKey:@"msgCode"];
        [parameters setValue:self.theidStr forKey:@"withdrawAddrId"];
        [parameters setValue:_tewPaswTextField.text forKey:@"withdrawNumber"];
        [parameters setValue:theid forKey:@"userId"];
        
        NSLog(@"提币字典%@", parameters);
        
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *args = [self convertToJsonData:parameters];
        request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
        // 3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.根据会话对象，创建一个Task任务
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            // 10、判断是否请求成功
            if (error) {
                NSLog(@"post1 error :%@",error.localizedDescription);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                    theLabel.backgroundColor=[UIColor blackColor];
                    theLabel.layer.cornerRadius = 5.f;
                    theLabel.clipsToBounds = YES;
                    theLabel.textColor=[UIColor whiteColor];
                    theLabel.alpha=0.8f;
                    theLabel.textAlignment=NSTextAlignmentCenter;
                    theLabel.font=[UIFont systemFontOfSize:15.f];
                    theLabel.text=@"请检查你的网络";
                    [self.view addSubview:theLabel];
                    
                    //设置动画
                    CATransition *transion=[CATransition animation];
                    transion.type=@"push";//动画方式
                    transion.subtype=@"fromRight";//设置动画从哪个方向开始
                    [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                    //不占用主线程
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                        [theLabel removeFromSuperview];
                        
                    });//这句话的意思是1.5秒后，把label移出视图
                });
            }else {
                // 如果请求成功，则解析数据。
                NSLog(@"返回的response信息%@",response);
                id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                // 11、判断是否解析成功
                if (error) {
                    NSLog(@"post2 error :%@",error.localizedDescription);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                        theLabel.backgroundColor=[UIColor blackColor];
                        theLabel.layer.cornerRadius = 5.f;
                        theLabel.clipsToBounds = YES;
                        theLabel.textColor=[UIColor whiteColor];
                        theLabel.alpha=0.8f;
                        theLabel.textAlignment=NSTextAlignmentCenter;
                        theLabel.font=[UIFont systemFontOfSize:15.f];
                        theLabel.text=@"@远程调用失败@";
                        [self.view addSubview:theLabel];
                        
                        //设置动画
                        CATransition *transion=[CATransition animation];
                        transion.type=@"push";//动画方式
                        transion.subtype=@"fromRight";//设置动画从哪个方向开始
                        [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                        //不占用主线程
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            [theLabel removeFromSuperview];
                            
                        });//这句话的意思是1.5秒后，把label移出视图
                    });
                }else {
                    // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                    NSLog(@"post success :%@",object1);
                    NSString *str0=[object1 objectForKey:@"code"];
                    NSString *str00=[NSString stringWithFormat:@"%@", str0];
                    NSString *str1=[object1 objectForKey:@"desc"];
                    NSLog(@"解析出来的code==%@",str0);
                    NSLog(@"解析出来的desc==%@",str1);
                    if ([str00 isEqualToString:@"0"]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提币成功" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            }];
                            [alertController addAction:action];
                            [self presentViewController:alertController animated:YES completion:nil];
                        });
                        
                    } else if ([str00 isEqualToString:@"-1"] && [str1 isEqualToString:@"缺少参数"]) {
                    
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先选择地址" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            }];
                            [alertController addAction:action];
                            [self presentViewController:alertController animated:YES completion:nil];
                        });
                            
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@", [object1 objectForKey:@"desc"]] preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            }];
                            [alertController addAction:action];
                            [self presentViewController:alertController animated:YES completion:nil];
                        });
                        
                    }
                }
            }
        }];
        
        //5.最后一步，执行任务，(resume也是继续执行)。
        [sessionDataTask resume];
    }
    
}

-(void)netaMethod{
    
    NSLog(@"右上角的新增地址按钮");
    newaddressViewController *naVc=[[newaddressViewController alloc] init];
    [self presentViewController:naVc animated:YES completion:nil];
}

#pragma mark - LMJDropdownMenu Delegate
- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    
    if (_datasource1.count>0) {
        NSLog(@"number==%ld",(long)number);
        
        _languageStr = self.datasource1[number];
        _theidStr=[self.datasource2 objectAtIndex: number];
        
        NSLog(@"你选择了：%@",_languageStr);
        NSLog(@"对应的idstr==%@",self.theidStr);
    }
}

- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    NSLog(@"--将要显示--");
}

- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    NSLog(@"--已经显示--");
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSString * tips = @"";
    switch (reach.currentReachabilityStatus)
    {
        case NotReachable:
            tips = @"无网络连接";
            break;
            
        case ReachableViaWiFi:
            tips = @"Wifi";
            break;
            
        case ReachableViaWWAN:
            NSLog(@"移动流量");
        case kReachableVia2G:
            tips = @"2G";
            break;
            
        case kReachableVia3G:
            tips = @"3G";
            break;
            
        case kReachableVia4G:
            tips = @"4G";
            break;
    }
    
    if ([tips isEqualToString:@"无网络连接"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*3.2/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
            theLabel.backgroundColor=[UIColor blackColor];
            theLabel.layer.cornerRadius = 5.f;
            theLabel.clipsToBounds = YES;
            theLabel.textColor=[UIColor whiteColor];
            theLabel.alpha=0.8f;
            theLabel.textAlignment=NSTextAlignmentCenter;
            theLabel.font=[UIFont systemFontOfSize:15.f];
            theLabel.text=@"无网络连接";
            [self.view addSubview:theLabel];
            
            //设置动画
            CATransition *transion=[CATransition animation];
            transion.type=@"push";//动画方式
            transion.subtype=@"fromRight";//设置动画从哪个方向开始
            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
            //不占用主线程
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                [theLabel removeFromSuperview];
                
            });//这句话的意思是1.5秒后，把label移出视图
        });
        
    } else {
    
        if (self.datasource1.count==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*0.66)/2, GZDeviceHeight*3.2/5, GZDeviceWidth*0.66, 20+GZDeviceHeight/25)];
                theLabel.backgroundColor=[UIColor blackColor];
                theLabel.layer.cornerRadius = 5.f;
                theLabel.clipsToBounds = YES;
                theLabel.textColor=[UIColor whiteColor];
                theLabel.alpha=0.8f;
                theLabel.textAlignment=NSTextAlignmentCenter;
                theLabel.font=[UIFont systemFontOfSize:15.f];
                theLabel.text=@"您还没有添加地址，请先添加";
                [self.view addSubview:theLabel];
                
                //设置动画
                CATransition *transion=[CATransition animation];
                transion.type=@"push";//动画方式
                transion.subtype=@"fromRight";//设置动画从哪个方向开始
                [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                //不占用主线程
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                    [theLabel removeFromSuperview];
                    
                });//这句话的意思是1.5秒后，把label移出视图
            });
        }
        
    }
}

- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--将要隐藏--");
}

- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--已经隐藏--");
}

-(void)viewDidDisappear:(BOOL)animated {
    
    NSLog(@"视图消失");
    [self.timer invalidate];
    self.timer = nil;
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

