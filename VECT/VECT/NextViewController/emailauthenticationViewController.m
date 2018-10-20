//
//  emailauthenticationViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/15.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "emailauthenticationViewController.h"
#import "Masonry.h"

@interface emailauthenticationViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *emaliTextField;
@property(nonatomic,strong)UITextField *newpswField;
@property(nonatomic,strong)UIButton *codeButton;
@property (strong, nonatomic)NSTimer *timer;
@property(nonatomic, assign)NSInteger count;

@end

@implementation emailauthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *realnameLabel=[[UILabel alloc] init];
    realnameLabel.text=@"邮箱认证";
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
    
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.text=@"邮箱";
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    _emaliTextField=[[UITextField alloc] init];
    _emaliTextField.placeholder=@"请输入您的邮箱";
    _emaliTextField.keyboardType=UIKeyboardTypeASCIICapable;
    _emaliTextField.rightViewMode=UITextFieldViewModeAlways;
    _emaliTextField.adjustsFontSizeToFitWidth = YES;
    [_emaliTextField setClearsOnBeginEditing:YES];
    [self.view addSubview:_emaliTextField];
    [_emaliTextField mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    _codeButton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*2/5, (20+GZDeviceHeight/20-15-GZDeviceWidth/25)/2, GZDeviceWidth/5, 15+GZDeviceWidth/25)];
    [_codeButton setTitle:@"点击获取" forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/35];
    _codeButton.titleLabel.font=[UIFont systemFontOfSize:(10+GZDeviceWidth/40)/2.f];
    _codeButton.layer.cornerRadius=(10+GZDeviceWidth/25)/2.f;
    _codeButton.backgroundColor=[UIColor colorWithRed:193/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
    [_codeButton addTarget:self action:@selector(codeMethod) forControlEvents:UIControlEventTouchUpInside];
    [_newpswField addSubview:_codeButton];
     
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
    deterButton.titleLabel.font=[UIFont systemFontOfSize:8.5+GZDeviceWidth/35];
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

-(void)codeMethod
{
    NSLog(@"点击了邮箱认证界面的获取验证码按钮");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mwduserId = [userDefaults stringForKey:@"myuserId"];
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    // 创建谓词对象并设定条件的表达式
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (_emaliTextField.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"邮箱不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (![emailTest evaluateWithObject:_emaliTextField.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你输入的邮箱格式不对，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([emailTest evaluateWithObject:_emaliTextField.text]) {
        NSLog(@"邮箱格式正确");
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/rest/imgUpload/codemail"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:_emaliTextField.text forKey:@"email"];
        [parameters setValue:mwduserId forKey:@"userId"];
        
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
                    //NSDictionary *dict2=[object1 objectForKey:@"resultMap"];
                    //NSLog(@"解析出来的code：%@",str0);
                    NSLog(@"解析出来的desc：%@",str1);
                    //NSLog(@"解析出来的resultMap：%@",dict2);
                    
                    if ([str00 isEqualToString:@"200"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight/2, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"验证码发送成功";
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromLeft";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                        });
                    } else if ([str00 isEqualToString:@"203"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight/2, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"用户未登录";
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromLeft";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight/2, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"验证码发送失败";
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromLeft";//设置动画从哪个方向开始
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
        //5.最后一步，执行任务，(resume也是继续执行)。
        [sessionDataTask resume];
        self.count=59;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:1];
    }
}

-(void)timerFired{
    
    if (_count != 0) {
        [_codeButton setTitle:[NSString stringWithFormat:@"剩余%ld秒", _count] forState:UIControlStateNormal];
        _count -= 1;
        _codeButton.enabled = NO;
        
        //       [self setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateDisabled];
    } else {
        
        _codeButton.enabled = YES;
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
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

-(void)deterMethod
{
    
    NSLog(@"点击了邮箱认证界面的确认按钮");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mwduserId = [userDefaults stringForKey:@"myuserId"];
    
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    // 创建谓词对象并设定条件的表达式
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ((_emaliTextField.text.length==0) || (_emaliTextField.text.length==0)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"邮箱和验证码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (![emailTest evaluateWithObject:_emaliTextField.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你输入的邮箱格式不对，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (_emaliTextField.text.length==0) {
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([emailTest evaluateWithObject:_emaliTextField.text] && (_emaliTextField.text.length!=0)) {
        NSLog(@"邮箱格式正确");
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/rest/imgUpload/updatemail"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:mwduserId forKey:@"id"];
        [parameters setValue:_emaliTextField.text forKey:@"email"];
        [parameters setValue:_newpswField.text forKey:@"msgCode"];
        [parameters setValue:mwduserId forKey:@"userId"];
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
                        [userDefaults setObject:self.emaliTextField.text forKey:@"myemail"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight/2, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"邮箱认证成功";
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromLeft";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                        });
                        
                    } else if ([str00 isEqualToString:@"203"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight/2, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"你没有登录过此邮箱";
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromLeft";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight/2, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"邮箱认证失败";
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromLeft";//设置动画从哪个方向开始
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
        //5.最后一步，执行任务，(resume也是继续执行)。
        [sessionDataTask resume];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_emaliTextField resignFirstResponder];
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
