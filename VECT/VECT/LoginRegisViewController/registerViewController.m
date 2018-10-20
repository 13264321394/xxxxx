//
//  registerViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/4.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "registerViewController.h"
#import "AFNetworking.h"
#import <GT3Captcha/GT3Captcha.h>
#import "CustomButton.h"
#import "Masonry.h"

@interface registerViewController ()<UITextFieldDelegate,GT3CaptchaManagerDelegate, CaptchaButtonDelegate>

@property(nonatomic,retain)UITextField *phoneText;
@property(nonatomic,retain)UITextField *passwordText;
@property(nonatomic,retain)UITextField *againText;
@property(nonatomic,retain)UITextField *codeText;
@property(nonatomic,retain)UITextField *referrerText;
@property (strong, nonatomic) CustomButton *codeButton;
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) UIButton *lastButton;
@property (strong, nonatomic)NSTimer *timer;
@property(nonatomic, assign)NSInteger count;
//@property(nonatomic,copy)NSPredicate *pred;
@property (nonatomic, strong) GT3CaptchaButton *captchaButton;

@end

@implementation registerViewController

- (GT3CaptchaButton *)captchaButton {
    if (!_captchaButton) {
        //创建验证管理器实例
        
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *api_1=[NSString stringWithFormat:@"http://vectwallet.com/gt/register4?uuid=%@&typeId=12", myUUIDStr];
        
        GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_1 timeout:5.0];
        
        captchaManager.delegate = self;
        captchaManager.maskColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        //debug mode
        //[captchaManager enableDebugMode:YES];
        //创建验证视图的实例
        _captchaButton = [[GT3CaptchaButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*3/5, (20+GZDeviceWidth/20-15-GZDeviceWidth/24)/2, GZDeviceWidth/5, 15+GZDeviceWidth/24) captchaManager:captchaManager];
        _captchaButton.layer.borderWidth = 0.3f;
        //给按钮设置角的弧度
        _captchaButton.layer.cornerRadius = 10.0f;
        
    }
    
    return _captchaButton;
}

- (void)createDefaultButton {
    
    //添加验证按钮到父视图上
    self.captchaButton.frame=CGRectMake(GZDeviceWidth*3/5, (20+GZDeviceWidth/20-15-GZDeviceWidth/24)/2, GZDeviceWidth/5, 15+GZDeviceWidth/24);
    //self.captchaButton.layer.cornerRadius=(20.0+GZDeviceHeight/40)/2.f;
    //推荐直接开启验证
    [self.captchaButton startCaptcha];
    [_codeText addSubview:self.captchaButton];
}

- (void)setupLoginButton {
    
    _codeButton = [[CustomButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*2.8/5-1, (20+GZDeviceWidth/20-15-GZDeviceWidth/23)/2-1, GZDeviceWidth*1.4/5+2, 15+GZDeviceWidth/23+2)];
    _codeButton.delegate = self;
    //_button.backgroundColor = [UIColor colorWithRed:0.3 green:0.63 blue:1.0 alpha:1.0];
    [_codeButton setClipsToBounds:YES];
    
    //_button.layer.cornerRadius = 2.0;
    [_codeButton setTitle:@"点击获取" forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/35];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:(10+GZDeviceWidth/30)/2.f];
    _codeButton.backgroundColor=[UIColor whiteColor];
    [_codeText addSubview:_codeButton];
    _codeButton.layer.borderColor = [[UIColor redColor] CGColor];
    //设置边框宽度
    _codeButton.layer.borderWidth = 0.6f;
    //给按钮设置角的弧度
    _codeButton.layer.cornerRadius = 8.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImage *image=[UIImage imageNamed:@"vectfs.jpg"];
    UIImageView *iv=[[UIImageView alloc] initWithImage:image];
    iv.frame=CGRectMake(0, 0, GZDeviceWidth, GZDeviceHeight);
    
    [self.view addSubview:iv];
    iv.userInteractionEnabled=YES;
    
    UIImage *logolimage=[UIImage imageNamed:@"VECTlogol.png"];
    UIImageView *logolImageView=[[UIImageView alloc] initWithImage:logolimage];
    [iv addSubview:logolImageView];
    //logolImageView.backgroundColor=[UIColor cyanColor];
    [logolImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo((GZDeviceWidth-GZDeviceWidth/3.5)/2);
        make.top.mas_equalTo(StatusbarHeight+GZDeviceHeight/25);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/3.5, GZDeviceWidth/3.5));
    }];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/3, StatusbarHeight+GZDeviceHeight/35+GZDeviceWidth/3.5+GZDeviceHeight/30, (GZDeviceWidth-GZDeviceWidth/3)/2, 15+GZDeviceWidth/20)];
    label.text=@"快速注册";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:5+GZDeviceWidth/35];
    label.textColor=[UIColor whiteColor];
    [iv addSubview:label];
    
    /*
    UIButton *backbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/50, StatusbarHeight+7, 18, 30)];
    [backbutton setImage:[UIImage imageNamed:@"返回 copy.png"] forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    */
     
    _phoneText=[[UITextField alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, StatusbarHeight+GZDeviceHeight/10+GZDeviceHeight/14+GZDeviceHeight/14+15+GZDeviceWidth/20, GZDeviceWidth-GZDeviceWidth/15*2, 20+GZDeviceWidth/20)];
    _phoneText.backgroundColor=[UIColor whiteColor];
    //_phoneText.textColor=[UIColor redColor];
    _phoneText.keyboardType=UIKeyboardTypeNumberPad;
    _phoneText.keyboardAppearance=UIKeyboardAppearanceDefault;
    _phoneText.borderStyle=UITextBorderStyleRoundedRect;
    _phoneText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _phoneText.layer.borderWidth = 0.7f;
    //设置弧度,这里将按钮变成了圆形
    _phoneText.layer.cornerRadius = 10.0f;
    _phoneText.layer.masksToBounds = YES;
    _phoneText.rightViewMode=UITextFieldViewModeAlways;
    _phoneText.placeholder=@"请输入你的电话号码";
    [_phoneText setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    [_phoneText setTextAlignment:NSTextAlignmentLeft];
    _phoneText.adjustsFontSizeToFitWidth = YES;
    [_phoneText setClearsOnBeginEditing:YES];
    [_phoneText setSecureTextEntry:NO];
    [_phoneText setReturnKeyType:UIReturnKeyDone];
    _phoneText.minimumFontSize=16;
    [iv addSubview:_phoneText];
    
    _passwordText=[[UITextField alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, StatusbarHeight+GZDeviceHeight/10+GZDeviceHeight/14+GZDeviceHeight/14+20+GZDeviceWidth/20+GZDeviceHeight/14, GZDeviceWidth-GZDeviceWidth/15*2, 20+GZDeviceWidth/20)];
    _passwordText.backgroundColor=[UIColor whiteColor];
    //_passwordText.textColor=[UIColor redColor];
    _passwordText.keyboardType=UIKeyboardTypeASCIICapable;
    _passwordText.keyboardAppearance=UIKeyboardAppearanceDefault;
    _passwordText.borderStyle=UITextBorderStyleRoundedRect;
    _passwordText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _passwordText.layer.borderWidth = 0.7f;
    //设置弧度,这里将按钮变成了圆形
    _passwordText.layer.cornerRadius = 10.0f;
    _passwordText.layer.masksToBounds = YES;
    _passwordText.rightViewMode=UITextFieldViewModeAlways;
    _passwordText.placeholder=@"密码(6-18位数字和字母组合)";
    [_passwordText setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    [_passwordText setTextAlignment:NSTextAlignmentLeft];
    _passwordText.adjustsFontSizeToFitWidth = YES;
    [_passwordText setClearsOnBeginEditing:YES];
    [_passwordText setSecureTextEntry:NO];
    _passwordText.secureTextEntry = YES;
    [_passwordText setReturnKeyType:UIReturnKeyDone];
    _passwordText.minimumFontSize=16;
    _passwordText.autocapitalizationType = UITextAutocapitalizationTypeNone;//首字母是否大写
    [iv addSubview:_passwordText];
    
    _againText=[[UITextField alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, StatusbarHeight+GZDeviceHeight/10+GZDeviceHeight/14+GZDeviceHeight/14+20+GZDeviceWidth/20+GZDeviceHeight/14+20+GZDeviceHeight/20, GZDeviceWidth-GZDeviceWidth/15*2, 20+GZDeviceWidth/20)];
    _againText.backgroundColor=[UIColor whiteColor];
    //_againText.textColor=[UIColor redColor];
    _againText.keyboardType=UIKeyboardTypeASCIICapable;
    _againText.keyboardAppearance=UIKeyboardAppearanceDefault;
    _againText.borderStyle=UITextBorderStyleRoundedRect;
    _againText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _againText.layer.borderWidth = 0.7f;
    //设置弧度,这里将按钮变成了圆形
    _againText.layer.cornerRadius = 10.0f;
    _againText.layer.masksToBounds = YES;
    _againText.rightViewMode=UITextFieldViewModeAlways;
    _againText.placeholder=@"确认密码";
    [_againText setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    [_againText setTextAlignment:NSTextAlignmentLeft];
    _againText.secureTextEntry = YES;
    _againText.adjustsFontSizeToFitWidth = YES;
    [_againText setClearsOnBeginEditing:YES];
    [_againText setReturnKeyType:UIReturnKeyDone];
    _againText.autocapitalizationType = UITextAutocapitalizationTypeNone;//首字母是否大写
    _againText.minimumFontSize=16;
    [iv addSubview:_againText];
    
    _codeText=[[UITextField alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, StatusbarHeight+GZDeviceHeight/10+GZDeviceHeight/14+GZDeviceHeight/14+20+GZDeviceWidth/20+GZDeviceHeight/14+20+GZDeviceHeight/20+20+GZDeviceHeight/20, GZDeviceWidth-GZDeviceWidth/15*2, 20+GZDeviceWidth/20)];
    _codeText.backgroundColor=[UIColor whiteColor];
    //_codeText.textColor=[UIColor redColor];
    _codeText.keyboardType=UIKeyboardTypeNumberPad;
    _codeText.keyboardAppearance=UIKeyboardAppearanceDefault;
    _codeText.borderStyle=UITextBorderStyleRoundedRect;
    _codeText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _codeText.layer.borderWidth = 0.7f;
    //设置弧度,这里将按钮变成了圆形
    _codeText.layer.cornerRadius = 10.0f;
    _codeText.layer.masksToBounds = YES;
    _codeText.rightViewMode=UITextFieldViewModeAlways;
    _codeText.placeholder=@"输入验证码";
    [_codeText setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    [_codeText setTextAlignment:NSTextAlignmentLeft];
    _codeText.adjustsFontSizeToFitWidth = YES;
    [_codeText setClearsOnBeginEditing:YES];
    [_codeText setSecureTextEntry:NO];
    [_codeText setReturnKeyType:UIReturnKeyDone];
    _codeText.minimumFontSize=16;
    [iv addSubview:_codeText];
    
    [self createDefaultButton];
    [self setupLoginButton];
    
    /*
    _codeButton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*3/5, (20+GZDeviceWidth/20-15-GZDeviceWidth/24)/2, GZDeviceWidth/5, 15+GZDeviceWidth/24)];
    [_codeButton setTitle:@"点击获取" forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:(10+GZDeviceWidth/30)/2.f];
    //_codeButton.layer.cornerRadius=12.5f;
    //_codeButton.backgroundColor=[UIColor redColor];
    [_codeButton addTarget:self action:@selector(codeMethod) forControlEvents:UIControlEventTouchUpInside];
    [_codeText addSubview:_codeButton];
    _codeButton.layer.borderColor = [[UIColor redColor] CGColor];
    //设置边框宽度
    _codeButton.layer.borderWidth = 0.3f;
    //给按钮设置角的弧度
    _codeButton.layer.cornerRadius = 10.0f;
    */
    
    _referrerText=[[UITextField alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, StatusbarHeight+GZDeviceHeight/10+GZDeviceHeight/14+GZDeviceHeight/14+20+GZDeviceWidth/20+GZDeviceHeight/14+20+GZDeviceHeight/20+20+GZDeviceHeight/20+20+GZDeviceHeight/20, GZDeviceWidth-GZDeviceWidth/15*2, 20+GZDeviceWidth/20)];
    _referrerText.backgroundColor=[UIColor whiteColor];
    //_referrerText.textColor=[UIColor redColor];
    _referrerText.keyboardType=UIKeyboardTypeNumberPad;
    _referrerText.keyboardAppearance=UIKeyboardAppearanceDefault;
    _referrerText.borderStyle=UITextBorderStyleRoundedRect;
    _referrerText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _referrerText.layer.borderWidth = 0.7f;
    //设置弧度,这里将按钮变成了圆形
    _referrerText.layer.cornerRadius = 10.0f;
    _referrerText.layer.masksToBounds = YES;
    _referrerText.rightViewMode=UITextFieldViewModeAlways;
    _referrerText.placeholder=@"推荐人VID  (选填)";
    [_referrerText setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    [_referrerText setTextAlignment:NSTextAlignmentLeft];
    _referrerText.adjustsFontSizeToFitWidth = YES;
    [_referrerText setClearsOnBeginEditing:YES];
    [_referrerText setSecureTextEntry:NO];
    [_referrerText setReturnKeyType:UIReturnKeyDone];
    _referrerText.minimumFontSize=16.f;
    [iv addSubview:_referrerText];
    

    _phoneText.delegate=self;
    _passwordText.delegate=self;
    _againText.delegate=self;
    _codeText.delegate=self;
    _referrerText.delegate=self;
    
    
    _registerButton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/10, StatusbarHeight+GZDeviceHeight/10+GZDeviceHeight/14+GZDeviceHeight/14+20+GZDeviceWidth/20+GZDeviceHeight/14+20+GZDeviceHeight/20+20+GZDeviceHeight/20+20+GZDeviceHeight/20+GZDeviceHeight/10, GZDeviceWidth-GZDeviceWidth/10*2, 25+GZDeviceWidth/20)];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor colorWithRed:5/255.0 green:99/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
    _registerButton.titleLabel.font=[UIFont systemFontOfSize:8.5+GZDeviceWidth/35];
    _registerButton.backgroundColor=[UIColor whiteColor];
    _registerButton.layer.cornerRadius=(25+GZDeviceWidth/20)/2.f;
    //_registerButton.layer.borderWidth=1.0f;
    [_registerButton addTarget:self action:@selector(registerMethod) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:_registerButton];
    
    
    UILabel *dLabel1=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/4, StatusbarHeight+GZDeviceHeight/10+GZDeviceHeight/14+GZDeviceHeight/14+20+GZDeviceWidth/20+GZDeviceHeight/14+20+GZDeviceHeight/20+20+GZDeviceHeight/20+20+GZDeviceHeight/20+GZDeviceHeight/10+GZDeviceHeight/13+6, GZDeviceWidth/4, 20+GZDeviceWidth/20)];
    dLabel1.text=@"已有账号？";
    dLabel1.textAlignment=NSTextAlignmentRight;
    dLabel1.font=[UIFont systemFontOfSize:4.5+GZDeviceWidth/32];
    dLabel1.textColor=[UIColor blackColor];
    [self.view addSubview:dLabel1];
    
    
    UILabel *dLabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/2, StatusbarHeight+GZDeviceHeight/10+GZDeviceHeight/14+GZDeviceHeight/14+20+GZDeviceWidth/20+GZDeviceHeight/14+20+GZDeviceHeight/20+20+GZDeviceHeight/20+20+GZDeviceHeight/20+GZDeviceHeight/10+GZDeviceHeight/13+6, GZDeviceWidth/4, 20+GZDeviceWidth/20)];
    dLabel.text=@"立即去登录";
    dLabel.textAlignment=NSTextAlignmentLeft;
    dLabel.font=[UIFont systemFontOfSize:4.5+GZDeviceWidth/32];
    dLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:dLabel];
    UITapGestureRecognizer *click1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lastMethod)];
    //必须设置这个
    dLabel.userInteractionEnabled=YES;
    [dLabel addGestureRecognizer:click1];
    
    
    /*
    _lastButton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/12, StatusbarHeight+GZDeviceHeight/10+GZDeviceHeight/14+GZDeviceHeight/14+20+GZDeviceWidth/20+GZDeviceHeight/14+20+GZDeviceHeight/20+20+GZDeviceHeight/20+20+GZDeviceHeight/20+GZDeviceHeight/10+GZDeviceHeight/16, GZDeviceWidth/2, 20+GZDeviceWidth/20)];
    [_lastButton setTitle:@"已有账号,直接登录!" forState:UIControlStateNormal];
    _lastButton.titleLabel.font=[UIFont systemFontOfSize:15.f];
    _lastButton.layer.cornerRadius=(15+GZDeviceWidth/20)/2.f;
    [_lastButton addTarget:self action:@selector(lastMethod) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:_lastButton];
    */
    
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
    
    NSString *regex = @"^1+[3578]+\\d{9}";
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (_phoneText.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"手机号不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (![predicate evaluateWithObject:_phoneText.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入正确的手机号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if ([predicate evaluateWithObject:_phoneText.text]) {
    
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        //NSURL *url = [NSURL URLWithString:@"http://vectwallet.com/gt/ajax-validate5"];
        NSURL *url=[NSURL URLWithString:[portUrl stringByAppendingString:@"/gt/ajax-validate5"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10.0f];//超过这个时间就算超时，请求失败
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setValue:_phoneText.text forKey:@"phone"];
        [parameters setValue:@"12" forKey:@"typeId"];
        [parameters setValue:@"" forKey:@"userId"];
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
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                            
                            //定时器放在主线程里面
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
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                
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

-(void)timerFired {
    if (_count != 0) {
        self.captchaButton.enabled=NO;
        _codeButton.enabled = NO;
        [self.codeButton setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateNormal];
        self.count -= 1;
        //       [self setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateDisabled];
    } else {
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.captchaButton.enabled=YES;
        _codeButton.enabled = YES;
        //        self.count = 60;
        _count=60;
        // 停掉定时器
        [self.timer invalidate];
        self.timer = nil;
    }
    NSLog(@"%ld",_count);
}

- (void)registerMethod
{
    NSLog(@"点击了注册按钮~~~");
    
    NSString *pattern1 = @"^1+[3578]+\\d{9}";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern1];
    
    NSString *pattern2 = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern2];
    
    if (_phoneText.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"手机号不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if(![pred1 evaluateWithObject:_phoneText.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你输入的手机号格式不对，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (![pred2 evaluateWithObject:_passwordText.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你设置的密码不是8～16位的数字和字母" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (![_passwordText.text isEqualToString:_againText.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你两次输入的密码不一样，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([pred1 evaluateWithObject:_phoneText.text] && [pred2 evaluateWithObject:_passwordText.text] && [_passwordText.text isEqualToString:_againText.text]) {
    
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/muser/register"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:_phoneText.text forKey:@"mobile"];
        [parameters setValue:_passwordText.text forKey:@"Password"];
        [parameters setValue:_codeText.text forKey:@"msgCode"];
        [parameters setValue:_referrerText.text forKey:@"recommendId"];
        
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                    theLabel.backgroundColor=[UIColor blackColor];
                    theLabel.layer.cornerRadius = 5.f;
                    theLabel.clipsToBounds = YES;
                    theLabel.textColor=[UIColor whiteColor];
                    theLabel.alpha=0.8f;
                    theLabel.textAlignment=NSTextAlignmentCenter;
                    theLabel.font=[UIFont systemFontOfSize:15.f];
                    theLabel.text=@"请你先连接网络";
                    [self.view addSubview:theLabel];
                    
                    //设置动画
                    CATransition *transion=[CATransition animation];
                    transion.type=@"push";//动画方式
                    transion.subtype=@"fromRight";//设置动画从哪个方向开始
                    [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                    //不占用主线程
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                        
                        [theLabel removeFromSuperview];
                        
                    });//这句话的意思是1.5秒后，把label移出视图
                    
                });
            } else {
                // 如果请求成功，则解析数据。
                NSLog(@"返回的response信息%@",response);
                
                id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                // 11、判断是否解析成功
                if (error) {
                    NSLog(@"post error :%@",error.localizedDescription);
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
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            
                            [theLabel removeFromSuperview];
                            
                        });//这句话的意思是1.5秒后，把label移出视图
                    });
                }else {
                    // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                    NSLog(@"post success :%@",object1);
                    NSString *str0=[object1 objectForKey:@"code"];
                    NSString *str00=[NSString stringWithFormat:@"%@", str0];
                    NSString *str1=[object1 objectForKey:@"desc"];
                    NSDictionary *dict2=[object1 objectForKey:@"resultMap"];
                    NSDictionary *dict3=[dict2 objectForKey:@"user"];
                    NSString *str4=[dict3 objectForKey:@"password"];
                    
                    NSLog(@"解析出来的code：%@",str0);
                    NSLog(@"解析出来的desc：%@",str1);
                    NSLog(@"解析出来的resultMap：%@",dict2);
                    NSLog(@"解析出来的str4：%@",str4);
                    
                    if ([str00 isEqualToString:@"0"]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UIView *theView=[[UIView alloc] initWithFrame:self.view.frame];
                            theView.backgroundColor=[UIColor blackColor];
                            [self.view addSubview:theView];
                            theView.alpha=0.4;
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*0.7)/2, GZDeviceHeight*3.4/5, GZDeviceWidth*0.7, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"注册成功！ 即将跳转到登录界面";
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromLeft";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                
                                [theLabel removeFromSuperview];
                                
                                [theView removeFromSuperview];
                                
                                NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.phoneText.text,@"textOne",self.passwordText.text,@"textTwo",nil];
                                //创建通知
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeregisColor" object:nil userInfo:dict];
                                [self dismissViewControllerAnimated:YES completion:nil];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                        });
                        
                        //[NSThread sleepForTimeInterval:1.0f];//此方法是一种阻塞执行方式，建议放在子线程中执行，否则会卡住界面。但有时还是需要阻塞执行，如进入欢迎界面需要沉睡3秒才进入主界面时。
                        
                    } else if ([str00 isEqualToString:@"6"]) {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"系统已经存在该手机号,请使用其他手机号注册!" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alertController addAction:action];
                        [self presentViewController:alertController animated:YES completion:nil];
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
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                        });
                    }
                }
            }
        }];
        
        //5.最后一步，执行任务，(resume也是继续执行)。
        [sessionDataTask resume];
    }
}

- (void)lastMethod
{
    NSLog(@"已有账号，直接登录");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)backMethod
{
    NSLog(@"dianji");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneText resignFirstResponder];
    [_passwordText resignFirstResponder];
    [_againText resignFirstResponder];
    [_codeText resignFirstResponder];
    [_referrerText resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//视图快消失时隐藏键盘
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_phoneText resignFirstResponder];
    [_passwordText resignFirstResponder];
    [_againText resignFirstResponder];
    [_codeText resignFirstResponder];
    [_referrerText resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //返回一个BOOL值，指定是否循序文本字段开始编辑,返回NO时不能唤起键盘进行编辑
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    
    //设置动画的名字
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.20];
    //??使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - GZDeviceHeight/6, self.view.frame.size.width, self.view.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //设置动画的名字
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.20];
    //??使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +GZDeviceHeight/6, self.view.frame.size.width, self.view.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
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
