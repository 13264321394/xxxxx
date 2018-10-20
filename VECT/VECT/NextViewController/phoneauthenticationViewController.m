//
//  phoneauthenticationViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/11.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "phoneauthenticationViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import <GT3Captcha/GT3Captcha.h>
#import "CustomButton.h"

@interface phoneauthenticationViewController ()<UITextFieldDelegate, GT3CaptchaManagerDelegate, CaptchaButtonDelegate>

@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UITextField *newpswField;
@property (strong, nonatomic)NSTimer *timer;
@property(nonatomic, assign)NSInteger count;
@property (nonatomic, strong) GT3CaptchaButton *captchaButton;
@property (strong, nonatomic) CustomButton *codeButton;

@end

@implementation phoneauthenticationViewController

- (GT3CaptchaButton *)captchaButton {
    if (!_captchaButton) {
        //创建验证管理器实例
        
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *api_1=[NSString stringWithFormat:@"http://vectwallet.com/gt/register4?uuid=%@&typeId=7", myUUIDStr];
        
        GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_1 timeout:5.0];
        
        captchaManager.delegate = self;
        captchaManager.maskColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        //debug mode
        //[captchaManager enableDebugMode:YES];
        //创建验证视图的实例
        _captchaButton = [[GT3CaptchaButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*2/5, (20+GZDeviceHeight/20-15-GZDeviceWidth/25)/2, GZDeviceWidth/5, 15+GZDeviceWidth/25) captchaManager:captchaManager];
        _captchaButton.layer.borderWidth = 0.5f;
        //给按钮设置角的弧度
        _captchaButton.layer.cornerRadius=(10+GZDeviceWidth/25)/2.f;
        
    }
    
    return _captchaButton;
}

- (void)createDefaultButton {
    
    //添加验证按钮到父视图上
    self.captchaButton.frame=CGRectMake(GZDeviceWidth*2/5, (20+GZDeviceHeight/20-15-GZDeviceWidth/25)/2, GZDeviceWidth/5, 15+GZDeviceWidth/25);
    self.captchaButton.layer.cornerRadius=(10+GZDeviceWidth/25)/2.f;
    //推荐直接开启验证
    [self.captchaButton startCaptcha];
    [_newpswField addSubview:self.captchaButton];
}

- (void)setupLoginButton {
    
    _codeButton = [[CustomButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*1.8/5, (20+GZDeviceHeight/20-15-GZDeviceWidth/21)/2, GZDeviceWidth/3.8, 15+GZDeviceWidth/21)];
    
    _codeButton.delegate = self;
    //_button.backgroundColor = [UIColor colorWithRed:0.3 green:0.63 blue:1.0 alpha:1.0];
    [_codeButton setClipsToBounds:YES];
    
    [_codeButton setTitle:@"点击获取" forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/35];
    _codeButton.backgroundColor=[UIColor whiteColor];
    [_newpswField addSubview:_codeButton];
    [_codeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:(10+GZDeviceWidth/40)/2.f];
    _codeButton.layer.cornerRadius=(10+GZDeviceWidth/25)/2.f;
    _codeButton.backgroundColor=[UIColor colorWithRed:193/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *realnameLabel=[[UILabel alloc] init];
    realnameLabel.text=@"手机认证";
    realnameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:realnameLabel];
    [realnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight);
        make.left.mas_equalTo(GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/2, 44));
    }];
    
    UIButton *backbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/50, StatusbarHeight+7, 18, 30)];
    [backbutton setImage:[UIImage imageNamed:@"返回 copy.png"] forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    
    UIView *grayView=[[UIView alloc] init];
    grayView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 10));
    }];
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, StatusbarHeight+44+10, 80, 50)];
    nameLabel.text=@"手机号";
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    _phoneTextField=[[UITextField alloc] init];
    _phoneTextField.placeholder=@"请输入您的手机号";
    _phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    _phoneTextField.rightViewMode=UITextFieldViewModeAlways;
    _phoneTextField.adjustsFontSizeToFitWidth = YES;
    [_phoneTextField setClearsOnBeginEditing:YES];
    [self.view addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10);
        make.left.mas_equalTo(10+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
    }];
    
    UIView *grayView1=[[UIView alloc] init];
    grayView1.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView1];
    [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UILabel *sexLabel=[[UILabel alloc] init];
    sexLabel.text=@"验证码";
    [self.view addSubview:sexLabel];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(GZDeviceWidth/30);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    _newpswField=[[UITextField alloc] init];
    _newpswField.placeholder=@"请输入验证码";
    _newpswField.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:_newpswField];
    [_newpswField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(GZDeviceWidth/30+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
    }];
    
    [self createDefaultButton];
    [self setupLoginButton];
    
    /*
    _codeButton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*2/5, (20+GZDeviceHeight/20-15-GZDeviceWidth/25)/2, GZDeviceWidth/5, 15+GZDeviceWidth/25)];
    [_codeButton setTitle:@"点击获取" forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:(10+GZDeviceWidth/40)/2.f];
    _codeButton.layer.cornerRadius=(10+GZDeviceWidth/25)/2.f;
    _codeButton.backgroundColor=[UIColor colorWithRed:193/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
    [_codeButton addTarget:self action:@selector(codeMethod) forControlEvents:UIControlEventTouchUpInside];
    [_newpswField addSubview:_codeButton];
    */
    
    UIView *grayView6=[[UIView alloc] init];
    grayView6.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView6];
    [grayView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20)-(20+GZDeviceHeight/30)));
    }];
    
    UIButton *deterButton=[[UIButton alloc] init];
    [deterButton setTitle:@"确 认" forState:UIControlStateNormal];
    deterButton.titleLabel.font=[UIFont systemFontOfSize:18.f];
    deterButton.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    [deterButton addTarget:self action:@selector(deterMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deterButton];
    [deterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(300);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 25+GZDeviceHeight/30));
    }];
    
    // Do any additional setup after loading the view.
}

-(void)deterMethod
{
    NSLog(@"点击了手机认证界面的确认按钮");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mwduserId = [userDefaults stringForKey:@"myuserId"];
    
    NSString *regex = @"^1+[3578]+\\d{9}";
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (_phoneTextField.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (![predicate evaluateWithObject:_phoneTextField.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你输入的手机号格式不对，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ((_newpswField.text.length !=0) && [predicate evaluateWithObject:_phoneTextField.text]) {
        NSLog(@"手机号正确");
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/rest/imgUpload/updatphone"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:mwduserId forKey:@"id"];
        [parameters setValue:_phoneTextField.text forKey:@"phone"];
        [parameters setValue:_newpswField.text forKey:@"code"];
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
                NSLog(@"返回的response信息：%@",response);
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
                    NSDictionary *dict2=[object1 objectForKey:@"resultMap"];
                    NSLog(@"解析出来的code：%@",str0);
                    NSLog(@"解析出来的desc：%@",str1);
                    NSLog(@"解析出来的resultMap：%@",dict2);
                    
                    if ([str00 isEqualToString:@"200"]) {
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:@"0" forKey:@"realnamecertification"];
                    } else if ([str00 isEqualToString:@"203"]) {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码已过期" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alertController addAction:action];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                }
            }
        }];
        //5.最后一步，执行任务，(resume也是继续执行)。
        [sessionDataTask resume];
    }
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
    
    if (_phoneTextField.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号和图形码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (![predicate evaluateWithObject:_phoneTextField.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你输入的手机号格式不对，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ((_phoneTextField.text.length !=0) && [predicate evaluateWithObject:_phoneTextField.text]) {
        
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //NSString *thephone=[userDefaults stringForKey:@"myPhone"];
        NSString *idstring=[userDefaults stringForKey:@"myuserId"];
        
        //NSURL *url = [NSURL URLWithString:@"http://vectwallet.com/gt/ajax-validate5"];
        NSURL *url=[NSURL URLWithString:[portUrl stringByAppendingString:@"/gt/ajax-validate5"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10.0f];//超过这个时间就算超时，请求失败
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setValue:_phoneTextField.text forKey:@"phone"];
        [parameters setValue:@"7" forKey:@"typeId"];
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

-(void)timerFired{
    
    if (_count != 0) {
        self.captchaButton.enabled=NO;
        self.codeButton.enabled = NO;
        [self.codeButton setTitle:[NSString stringWithFormat:@"剩余%ld秒", _count] forState:UIControlStateNormal];
        _count -= 1;
        
        
        //       [self setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateDisabled];
    } else {
        self.codeButton.enabled = YES;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneTextField resignFirstResponder];
    [_newpswField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑,返回NO时不能唤起键盘进行编辑
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    
    NSLog(@"视图消失");
    [self.timer invalidate];
    self.timer = nil;
}

-(void)backMethod
{
    NSLog(@"dianji");
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
