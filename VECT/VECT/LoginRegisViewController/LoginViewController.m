//
//  LoginViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/3.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "LoginViewController.h"
#import "registerViewController.h"
#import "ForgetPawViewController.h"
#import "realNameViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import <GT3Captcha/GT3Captcha.h>
#import "CustomButton.h"

@interface LoginViewController ()<UITextFieldDelegate,GT3CaptchaManagerDelegate, CaptchaButtonDelegate>

@property(nonatomic,strong)UITextField *nameText;
@property(nonatomic,strong)UITextField *passwordText;
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) UIButton *chanpassButton;
@property (strong, nonatomic) UIButton *loginButton;
@property(strong,nonatomic)UIImageView *iv;
@property (nonatomic, strong) GT3CaptchaButton *captchaButton;
@property (nonatomic, strong)CustomButton *button;

@end

@implementation LoginViewController

- (GT3CaptchaButton *)captchaButton {
    if (!_captchaButton) {
        //创建验证管理器实例
        
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *api_1=[NSString stringWithFormat:@"http://vectwallet.com/gt/register4?uuid=%@&typeId=1", myUUIDStr];
        
        GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_1 timeout:5.0];
        
        captchaManager.delegate = self;
        captchaManager.maskColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        //debug mode
        //[captchaManager enableDebugMode:YES];
        //创建验证视图的实例
        _captchaButton = [[GT3CaptchaButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*1.5/10, GZDeviceHeight/4+30+GZDeviceHeight/10+40+GZDeviceHeight/30+40+GZDeviceHeight/20+30.0+GZDeviceHeight/20, GZDeviceWidth*3.5/5, 20.0+GZDeviceHeight/30) captchaManager:captchaManager];
        _captchaButton.layer.cornerRadius=(20.0+GZDeviceHeight/40)/2.f;
        //[self.captchaButton startCaptcha];
    }
    
    return _captchaButton;
}

- (void)createDefaultButton {
    
    //添加验证按钮到父视图上
    self.captchaButton.frame=CGRectMake(GZDeviceWidth*1.5/10, GZDeviceHeight/4+30+GZDeviceHeight/10+40+GZDeviceHeight/30+40+GZDeviceHeight/20+30.0+GZDeviceHeight/20, GZDeviceWidth*3.5/5, 20.0+GZDeviceHeight/30);
    self.captchaButton.layer.cornerRadius=(20.0+GZDeviceHeight/40)/2.f;
    //推荐直接开启验证
    [self.captchaButton startCaptcha];
    [_iv addSubview:self.captchaButton];
}

- (void)setupLoginButton {
    
    _button = [[CustomButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/10, GZDeviceHeight/4+30+GZDeviceHeight/10+40+GZDeviceHeight/30+40+GZDeviceHeight/20+30.0+GZDeviceHeight/20, GZDeviceWidth*4/5, 20.0+GZDeviceHeight/30)];
    _button.delegate = self;
    //_button.backgroundColor = [UIColor colorWithRed:0.3 green:0.63 blue:1.0 alpha:1.0];
    _button.backgroundColor = [UIColor blueColor];
    [_button setClipsToBounds:YES];
    
    _button.layer.cornerRadius = 2.0;
    [_button setTitle:@"登录" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:5/255.0 green:99/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
    _button.titleLabel.font=[UIFont systemFontOfSize:8.5+GZDeviceWidth/35];
    _button.backgroundColor=[UIColor whiteColor];
    _button.layer.cornerRadius=(20.0+GZDeviceHeight/40)/2.f;
    //_button.center = CGPointMake(200, 200);
    /*[_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GZDeviceHeight/4+30+GZDeviceHeight/10+40+GZDeviceHeight/30+40+GZDeviceHeight/20+30.0+GZDeviceHeight/20);
        make.left.mas_equalTo(GZDeviceWidth/10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth*4/5, 20.0+GZDeviceHeight/30));
    }];
    */
     
    [_iv addSubview:_button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImage *image=[UIImage imageNamed:@"vextdsa.jpg"];
    _iv=[[UIImageView alloc] initWithImage:image];
    //_iv.frame=CGRectMake(0, 20, GZDeviceWidth, GZDeviceHeight);
    [self.view addSubview:_iv];
    _iv.userInteractionEnabled=YES;
    [_iv mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, GZDeviceHeight));
    }];
    
    UIImage *logolimage=[UIImage imageNamed:@"VECTlogol.png"];
    UIImageView *logolImageView=[[UIImageView alloc] initWithImage:logolimage];
    [_iv addSubview:logolImageView];
    [logolImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo((GZDeviceWidth-GZDeviceWidth/2)/2);
        make.top.mas_equalTo(GZDeviceHeight/15);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/2, GZDeviceWidth/2));
    }];
    
    [self createDefaultButton];
    [self setupLoginButton];
    
    _nameText=[[UITextField alloc] init];
    //_nameText.backgroundColor=[UIColor whiteColor];
    //_nameText.textColor=[UIColor redColor];
    //_nameText.keyboardType=UIKeyboardTypeNumberPad;//数字键盘
    //_nameText.keyboardType=UIKeyboardTypeNamePhonePad;//电话键盘,也支持输入人名
    _nameText.keyboardType=UIKeyboardTypeASCIICapable;//电话键盘
    _nameText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _nameText.layer.borderWidth = 0.7f;
    //设置弧度,这里将按钮变成了圆形
    _nameText.layer.cornerRadius = 10.0f;
    _nameText.layer.masksToBounds = YES;
    _nameText.rightViewMode=UITextFieldViewModeAlways;
    _nameText.placeholder=@"请输入用户名";
    [_nameText setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    [_nameText setTextAlignment:NSTextAlignmentLeft];
    _nameText.adjustsFontSizeToFitWidth = YES;
    [_nameText setClearsOnBeginEditing:YES];
    [_nameText setSecureTextEntry:NO];
    [_nameText setReturnKeyType:UIReturnKeyDone];
    _nameText.clearButtonMode = UITextFieldViewModeAlways;//输入框中是否有个叉号，在什么时候显示
    _nameText.minimumFontSize=16;
    [_iv addSubview:_nameText];
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GZDeviceHeight/4+30+GZDeviceHeight/10);
        make.left.mas_equalTo(GZDeviceWidth/10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth*4/5.0, 40));
    }];
    
    /*
    UIImageView *leftView=[[UIImageView alloc] init];
    [leftView setFrame:CGRectMake(20, 0, 18, 18)];
    [leftView setImage:[UIImage imageNamed:@"VECTnameph.png"]];
    [leftView setContentMode:UIViewContentModeScaleAspectFit];
    [_nameText setLeftView:leftView];
    [_nameText setLeftViewMode:UITextFieldViewModeAlways];
    */
    
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 38, 18)];
    imageViewPwd.image=[UIImage imageNamed:@"VECTnameph1.png"];
    _nameText.leftView=imageViewPwd;
    _nameText.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _nameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _passwordText=[[UITextField alloc] initWithFrame:CGRectMake(100, 300, 230, 42)];
    //_passwordText.backgroundColor=[UIColor whiteColor];
    //_passwordText.textColor=[UIColor redColor];
    //_passwordText.keyboardType=UIKeyboardTypeASCIICapable;
    //_passwordText.keyboardAppearance=UIKeyboardAppearanceDefault;
    //_passwordText.borderStyle=UITextBorderStyleRoundedRect;
    _passwordText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _passwordText.layer.borderWidth = 0.7f;
    //设置弧度,这里将按钮变成了圆形
    _passwordText.layer.cornerRadius = 10.0f;
    _passwordText.layer.masksToBounds = YES;
    _passwordText.placeholder=@"请输入密码";
    [_passwordText setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    [_passwordText setTextAlignment:NSTextAlignmentLeft];
    _passwordText.adjustsFontSizeToFitWidth = YES;
    [_passwordText setReturnKeyType:UIReturnKeyDone];
    _passwordText.minimumFontSize=16;//设置自动缩小显示的最小字体大小
    [_iv addSubview:_passwordText];
    //_passwordText.borderStyle=UITextBorderStyleRoundedRect;
    _passwordText.keyboardType=UIKeyboardTypeNumbersAndPunctuation;//
    _passwordText.clearButtonMode = UITextFieldViewModeAlways;//输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    _passwordText.secureTextEntry = YES;//每输入一个字符就变成点 用语密码输入
    _passwordText.autocorrectionType = UITextAutocorrectionTypeNo;//是否纠错
    _passwordText.clearsOnBeginEditing = NO;//再次编辑就清空
    _passwordText.autocapitalizationType = UITextAutocapitalizationTypeNone;//首字母是否大写
    [_passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GZDeviceHeight/4+30+GZDeviceHeight/10+40+GZDeviceHeight/30);
        make.left.mas_equalTo(GZDeviceWidth/10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth*4/5.0, 40.0));
    }];
    
    //记下账号密码
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nameStr=[NSString stringWithFormat:@"%@", [userDefaults stringForKey:@"myPhone"]];
    NSString *passStr=[NSString stringWithFormat:@"%@", [userDefaults stringForKey:@"mypassword"]];
    
    if ((nameStr.length!=0) && (passStr.length!=0)) {
        _nameText.text=nameStr;
        _passwordText.text=passStr;
    }
    
    /*
    UIImageView *leftView2=[[UIImageView alloc] init];
    [leftView2 setFrame:CGRectMake(10, 0, 15, 15)];
    [leftView2 setImage:[UIImage imageNamed:@"VECTpasswo.png"]];
    [leftView2 setContentMode:UIViewContentModeScaleAspectFit];
    [_passwordText setLeftView:leftView2];
    [_passwordText setLeftViewMode:UITextFieldViewModeAlways];
    */
    
    
    UIImageView *imageViewPwd2=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 38, 18)];
    imageViewPwd2.image=[UIImage imageNamed:@"VECTpasswo1.png"];
    _passwordText.leftView=imageViewPwd2;
    _passwordText.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _passwordText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
     
    _passwordText.delegate=self;
    _passwordText.delegate=self;
    
    _registerButton=[[UIButton alloc] init];
    [_registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    _registerButton.titleLabel.font=[UIFont systemFontOfSize:15];
    //_registerButton.backgroundColor=[UIColor cyanColor];
    //[_registerButton setTitleShadowColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(registerMethod) forControlEvents:UIControlEventTouchUpInside];
    //将控件添加到当前视图上
    [_iv addSubview:_registerButton];
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GZDeviceHeight/4+30+GZDeviceHeight/10+40+GZDeviceHeight/30+40+GZDeviceHeight/20);
        make.left.mas_equalTo(GZDeviceWidth/10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 30.0));
    }];
    
    _chanpassButton=[[UIButton alloc] init];
    [_chanpassButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_chanpassButton setTintColor:[UIColor orangeColor]];
    _chanpassButton.titleLabel.font=[UIFont systemFontOfSize:15];
    //_chanpassButton.backgroundColor=[UIColor orangeColor];
    //[_chanpassButton setTitleShadowColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_chanpassButton addTarget:self action:@selector(changeMethod) forControlEvents:UIControlEventTouchUpInside];
    //将控件添加到当前视图上
    [_iv addSubview:_chanpassButton];
    [_chanpassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GZDeviceHeight/4+30+GZDeviceHeight/10+40+GZDeviceHeight/30+40+GZDeviceHeight/20);
        make.left.mas_equalTo(GZDeviceWidth/2+GZDeviceWidth/2-(GZDeviceWidth/10+GZDeviceWidth/4));
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 30.0));
    }];
    
    _nameText.text=@"";
    _passwordText.text=@"";
    
    //缓存过期自动退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBgColor) name:@"changeBgColor" object:nil];
    
    //用户手动退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutchangeBgColor) name:@"logoutchangeBgColor" object:nil];
    
    //注册成功的跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"changeregisColor" object:nil];
    
    NSLog(@"账号==%@  密码==%@", _nameText.text,_passwordText.text);
    
    // Do any additional setup after loading the view.
}

-(void)changeBgColor
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _nameText.text=[userDefaults stringForKey:@"myPhone"];
    _passwordText.text=[userDefaults stringForKey:@"mypassword"];
}

-(void)logoutchangeBgColor
{
    
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"账号==%@  密码==%@", _nameText.text,_passwordText.text);
    
    _nameText.text=@"";
    _passwordText.text=@"";
    
    //NSLog(@"账号%@", [userDefaults stringForKey:@"myPhone"]);
    //NSLog(@"密码%@", [userDefaults stringForKey:@"mypassword"]);
}

- (void)tongzhi:(NSNotification *)text{
    
    NSLog(@"%@",text.userInfo[@"textOne"]);
    
    NSLog(@"－－－－－接收到通知------");
    
    _nameText.text=text.userInfo[@"textOne"];
    _passwordText.text=text.userInfo[@"textTwo"];
    
}

- (void)registerMethod
{
   registerViewController *reg=[[registerViewController alloc] init];
   [self presentViewController:reg animated:YES completion:nil];

}

- (void)changeMethod
{
    ForgetPawViewController *fgp=[[ForgetPawViewController alloc] init];
    [self presentViewController:fgp animated:YES completion:nil];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nameText resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    [_passwordText resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    //返回一个BOOL值，指定是否循序文本字段开始编辑,返回NO时不能唤起键盘进行编辑
    return YES;
}

//视图快消失时隐藏键盘
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_nameText resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    [_passwordText resignFirstResponder];
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
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-GZDeviceHeight/6, self.view.frame.size.width, self.view.frame.size.height);
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
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+GZDeviceHeight/6, self.view.frame.size.width, self.view.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
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
    
    NSLog(@"处理验证中返回的错误%ld   %@", error.code,error.error_code);
    
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
    
    
    NSString *pattern1 = @"^1+[3578]+\\d{9}";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern1];
    
    NSString *pattern3 =@"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern3];
    
    if ((_nameText.text.length==0) || (_passwordText.text.length == 0)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登录名或密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ((![pred1 evaluateWithObject:_nameText.text]) && (![pred3 evaluateWithObject:_nameText.text])) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你输入的账号格式不对，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (((_nameText.text.length !=0) && (_passwordText.text.length !=0)) && (([pred1 evaluateWithObject:_nameText.text]) || ([pred3 evaluateWithObject:_nameText.text])) ) {
        
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        //NSURL *url = [NSURL URLWithString:@"http://vectwallet.com/muser/logingo"];
        NSURL *url=[NSURL URLWithString:[portUrl stringByAppendingString:@"/muser/logingo"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:5.0f];//超过这个时间就算超时，请求失败
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:_nameText.text forKey:@"mobile"];
        [parameters setValue:_passwordText.text forKey:@"Password"];
        [parameters setValue:@"1" forKey:@"type"];

        [parameters setValue:myUUIDStr forKey:@"uuid"];
        [parameters setValue:@"1" forKey:@"messageTypeId"];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/4)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/4, 20+GZDeviceHeight/25)];
                    theLabel.backgroundColor=[UIColor blackColor];
                    theLabel.layer.cornerRadius = 5.f;
                    theLabel.clipsToBounds = YES;
                    theLabel.textColor=[UIColor whiteColor];
                    theLabel.alpha=0.8f;
                    theLabel.textAlignment=NSTextAlignmentCenter;
                    theLabel.font=[UIFont systemFontOfSize:15.f];
                    theLabel.text=@"请求错误!";
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
            } else {
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
                        theLabel.text=@"登录失败!请重新登录";
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
                    // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                    NSLog(@"post success :%@",object1);
                    NSString *str0=[object1 objectForKey:@"code"];
                    //NSString *str00=[NSString stringWithFormat:@"%@", str0];
                    NSString *str1=[object1 objectForKey:@"desc"];
                    NSDictionary *dic2=[object1 objectForKey:@"resultMap"];
                    NSLog(@"字典中解析出来的code:%@",str0);
                    NSLog(@"字典中解析出来的desc:%@",str1);
                    NSLog(@"字典中解析出来的resultMap:%@",dic2);
                    NSLog(@"字典中解析出来的accountName:%@",[[dic2 objectForKey:@"user"] objectForKey:@"accountName"]);
                    NSLog(@"字典中解析出来的id:%@",[[dic2 objectForKey:@"user"] objectForKey:@"id"]);
                    NSLog(@"字典中解析出来的type:%@",[[dic2 objectForKey:@"user"] objectForKey:@"type"]);
                    NSString *thetypeString=[NSString stringWithFormat:@"%@", [[dic2 objectForKey:@"user"] objectForKey:@"type"]];
                    
                    //NSLog(@"我需要的啊啊啊啊type=%@",thetypeString);
                    
                    if ([[NSString stringWithFormat:@"%@", [object1 objectForKey:@"code"]] isEqualToString:@"0"]) {
                        
                        //设置登陆成功后跳转到主界面
                        //NSString *MarkString=@"1";
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        //[userDefaults setObject:MarkString forKey:@"myString"];
                        [userDefaults setObject:[dic2 objectForKey:@"token"] forKey:@"mytoken"];//存令牌
                        [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"accountName"] forKey:@"myPhone"];//存账号
                        [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"id"] forKey:@"myuserId"];//存ID
                        [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"type"] forKey:@"mytype"];//存是否认证
                        [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"mobile"] forKey:@"mymobile"];//存手机号
                        [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"email"] forKey:@"myemail"];//存邮箱
                        [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"username"] forKey:@"myname"];//存姓名
                        [userDefaults setObject:[[dic2 objectForKey:@"tCommunity"] objectForKey:@"createDate"] forKey:@"mycommunity"];//存姓名
                        
                        NSLog(@"我要的社区服务%@", [userDefaults stringForKey:@"mycommunity"]);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/4)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/4, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"登录成功!";
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
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *mypaw=self.passwordText.text;
                            [userDefaults setObject:mypaw forKey:@"mypassword"];//存储密码
                        });
                        
                        //判断是否实名认证通过
                        if ([thetypeString isEqualToString:@"1"]) {
                            
                            [[NSUserDefaults standardUserDefaults]setObject:@"islogin" forKey:@"islogin"];
                            
                            //NSString *MarkString=@"1";
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            //[userDefaults setObject:MarkString forKey:@"myString"];
                            [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"username"] forKey:@"themyname"];//存姓名
                            [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"sex"] forKey:@"themysex"];//存性别
                            [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"user_no"] forKey:@"themyshenfenID"];//存身份证号
                            [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"fm"] forKey:@"themyimagepath1"];//存照片路径1
                            [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"sc"] forKey:@"themyimagepath2"];//存照片路径2
                            [userDefaults setObject:[[dic2 objectForKey:@"user"] objectForKey:@"zm"] forKey:@"themyimagepath3"];//存照片路径3
                            
                            //查询签到
                            NSURL *url2 = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/signWhether"]];
                            // 2.创建一个网络请求，分别设置请求方法、请求参数
                            NSMutableURLRequest *request2 =[NSMutableURLRequest requestWithURL:url2];
                            NSMutableDictionary *parameters2 = [[NSMutableDictionary alloc] init];
                            NSString *mstr2=[NSString stringWithFormat:@"%@", [[dic2 objectForKey:@"user"] objectForKey:@"id"]];
                            NSLog(@"查询签到之前的测试userId：%@", mstr2);
                            [parameters2 setValue:mstr2 forKey:@"userId"];
                            [parameters2 setValue:[NSString stringWithFormat:@"%@", [dic2 objectForKey:@"token"]] forKey:@"token"];
                            
                            request2.HTTPMethod = @"POST";
                            [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                            NSString *args2 = [self convertToJsonData:parameters2];
                            request2.HTTPBody = [args2 dataUsingEncoding:NSUTF8StringEncoding];
                            // 3.获得会话对象
                            NSURLSession *session2 = [NSURLSession sharedSession];
                            // 4.根据会话对象，创建一个Task任务
                            NSURLSessionDataTask *sessionDataTask2 = [session2 dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                
                                // 10、判断是否请求成功
                                if (error) {
                                    NSLog(@"post1 error :%@",error.localizedDescription);
                                }else {
                                    // 如果请求成功，则解析数据。
                                    NSLog(@"返回的response信息%@",response);
                                    id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                    // 11、判断是否解析成功
                                    if (error) {
                                        NSLog(@"post2 error :%@",error.localizedDescription);
                                    }else {
                                        // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                                        NSLog(@"post success :%@",object1);
                                        NSString *str0=[object1 objectForKey:@"code"];
                                        NSString *str00=[NSString stringWithFormat:@"%@", str0];
                                        NSString *str1=[object1 objectForKey:@"desc"];
                                        NSDictionary *dic2=[object1 objectForKey:@"resultMap"];
                                        NSLog(@"签到字典中解析出来的code:%@",str0);
                                        NSLog(@"签到字典中解析出来的desc:%@",str1);
                                        NSLog(@"签到字典中解析出来的resultMap:%@",dic2);
                                        //签到成功
                                        if ([str00 isEqualToString:@"0"]) {
                                            /*
                                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"查询签到成功" preferredStyle:UIAlertControllerStyleAlert];
                                             UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                             }];
                                             [alertController addAction:action];
                                             [self presentViewController:alertController animated:YES completion:nil];
                                             */
                                        }
                                    }
                                }
                            }];
                            
                            //5.最后一步，执行任务，(resume也是继续执行)。
                            [sessionDataTask2 resume];
                            
                            //用户签到
                            NSURL *url1 = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/signIn"]];
                            // 2.创建一个网络请求，分别设置请求方法、请求参数
                            NSMutableURLRequest *request1 =[NSMutableURLRequest requestWithURL:url1];
                            NSMutableDictionary *parameters1 = [[NSMutableDictionary alloc] init];
                            
                            NSString *mstr=[NSString stringWithFormat:@"%@", [[dic2 objectForKey:@"user"] objectForKey:@"id"]];
                            NSLog(@"签到之前的测试userId：%@", mstr);
                            [parameters1 setValue:mstr forKey:@"userId"];
                            [parameters1 setValue:[NSString stringWithFormat:@"%@", [dic2 objectForKey:@"token"]] forKey:@"token"];
                            
                            request1.HTTPMethod = @"POST";
                            [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                            NSString *args1 = [self convertToJsonData:parameters1];
                            request1.HTTPBody = [args1 dataUsingEncoding:NSUTF8StringEncoding];
                            // 3.获得会话对象
                            NSURLSession *session1 = [NSURLSession sharedSession];
                            // 4.根据会话对象，创建一个Task任务
                            NSURLSessionDataTask *sessionDataTask1 = [session1 dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                
                                // 10、判断是否请求成功
                                if (error) {
                                    NSLog(@"post error :%@",error.localizedDescription);
                                }else {
                                    // 如果请求成功，则解析数据。
                                    NSLog(@"返回的response信息%@",response);
                                    id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                    // 11、判断是否解析成功
                                    if (error) {
                                        NSLog(@"post error :%@",error.localizedDescription);
                                    }else {
                                        // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                                        NSLog(@"post success :%@",object1);
                                        NSString *str0=[object1 objectForKey:@"code"];
                                        NSString *str00=[NSString stringWithFormat:@"%@", str0];
                                        NSString *str1=[object1 objectForKey:@"desc"];
                                        NSDictionary *dic2=[object1 objectForKey:@"resultMap"];
                                        NSLog(@"签到字典中解析出来的code:%@",str0);
                                        NSLog(@"签到字典中解析出来的desc:%@",str1);
                                        NSLog(@"签到字典中解析出来的resultMap:%@",dic2);
                                        //签到成功
                                        if ([str00 isEqualToString:@"0"]) {
                                            /*
                                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"签到成功" preferredStyle:UIAlertControllerStyleAlert];
                                             UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                             }];
                                             [alertController addAction:action];
                                             [self presentViewController:alertController animated:YES completion:nil];
                                             */
                                        }
                                    }
                                }
                            }];
                            
                            //5.最后一步，执行任务，(resume也是继续执行)。
                            [sessionDataTask1 resume];
                            
                            [NSThread sleepForTimeInterval:0.7];//此方法是一种阻塞执行方式，建议放在子线程中执行，否则会卡住界面。但有时还是需要阻塞执行，如进入欢迎界面需要沉睡3秒才进入主界面时。
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"noti1" object:nil];
                            
                        } else if ([thetypeString isEqualToString:@"0"] || [thetypeString isEqualToString:@"2"] ||[thetypeString isEqualToString:@"-1"] ||[thetypeString isEqualToString:@""])
                        {
                            // 0正在审核，1，已实名，2失败 空和-1没有提交
                            realNameViewController *re=[[realNameViewController alloc] init];
                            [self presentViewController:re animated:YES completion:nil];
                        }
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-self.view.frame.size.width/2)/2, self.view.frame.size.height*2/5, self.view.frame.size.width/2, 20+self.view.frame.size.height/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=[NSString stringWithFormat:@"%@", [object1 objectForKey:@"desc"]];
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
                }
            }
        }];
        
        //5.最后一步，执行任务，(resume也是继续执行)。
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
    
    NSLog(@"修改API2的请求,执行了吗7");
}

//是否开启二次验证
- (BOOL)shouldUseDefaultSecondaryValidate:(GT3CaptchaManager *)manager {
    NSLog(@"是否开启二次验证,执行了吗1");
    
    return YES;
}

-(NSDictionary *)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error
{
    NSLog(@"字典manager==%@--dictionary==%@--error==%@",manager, dictionary, error);
    
    return nil;
}

//修改API1的请求
- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    NSString *newURL = [NSString stringWithFormat:@"%@?t=%.0f", originalRequest.URL.absoluteString, [[[NSDate alloc] init] timeIntervalSince1970]];
    mRequest.URL = [NSURL URLWithString:newURL];
    
    replacedHandler(mRequest);
    
    NSLog(@"修改API1的请求 manager==%@--originalRequest==%@--replacedHandler==%@", manager, originalRequest, replacedHandler);
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
