//
//  passwordViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/9.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "passwordViewController.h"
#import "LoginViewController.h"
#import "Masonry.h"

@interface passwordViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *oldpswField;
@property(nonatomic,strong)UITextField *newpswField;
@property(nonatomic,strong)UITextField *confirmpswField;
@property(nonatomic,strong)UIView *darkview;

@end

@implementation passwordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *realnameLabel=[[UILabel alloc] init];
    realnameLabel.text=@"登录密码";
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
    nameLabel.text=@"旧密码";
    nameLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10);
        make.left.mas_equalTo(GZDeviceWidth/30);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    _oldpswField=[[UITextField alloc] init];
    _oldpswField.placeholder=@"请填写旧密码";
    [_oldpswField setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    _oldpswField.keyboardType=UIKeyboardTypeASCIICapable;
    _oldpswField.rightViewMode=UITextFieldViewModeAlways;
    _oldpswField.adjustsFontSizeToFitWidth = YES;
    _oldpswField.secureTextEntry = YES;
    [_oldpswField setClearsOnBeginEditing:YES];
    [self.view addSubview:_oldpswField];
    [_oldpswField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10);
        make.left.mas_equalTo(GZDeviceWidth/30+GZDeviceWidth/4);
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
    sexLabel.text=@"新密码";
    sexLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    [self.view addSubview:sexLabel];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(GZDeviceWidth/30);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    _newpswField=[[UITextField alloc] init];
    _newpswField.placeholder=@"8~16位数字和字母的结合";
    [_newpswField setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    _newpswField.keyboardType=UIKeyboardTypeASCIICapable;
    _newpswField.secureTextEntry = YES;
    [self.view addSubview:_newpswField];
    [_newpswField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(GZDeviceWidth/30+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
    }];
    
    UIView *grayView2=[[UIView alloc] init];
    grayView2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView2];
    [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    
    UILabel *phoneLabel=[[UILabel alloc] init];
    phoneLabel.text=@"确认密码";
    phoneLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(GZDeviceWidth/30);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    _confirmpswField=[[UITextField alloc] init];
    _confirmpswField.placeholder=@"请再次填写新密码";
    [_confirmpswField setValue:[UIFont systemFontOfSize:5+GZDeviceWidth/35] forKeyPath:@"_placeholderLabel.font"];
    _confirmpswField.keyboardType=UIKeyboardTypeASCIICapable;
    _confirmpswField.rightViewMode=UITextFieldViewModeAlways;
    _confirmpswField.adjustsFontSizeToFitWidth = YES;
    [_confirmpswField setClearsOnBeginEditing:YES];
    _confirmpswField.secureTextEntry = YES;
    [self.view addSubview:_confirmpswField];
    [_confirmpswField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(GZDeviceWidth/30+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-10-GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    UIView *grayView3=[[UIView alloc] init];
    grayView3.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:grayView3];
    [grayView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44+10+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20)));
    }];
    
    UIButton *deterButton=[[UIButton alloc] init];
    [deterButton setTitle:@"确 认" forState:UIControlStateNormal];
    deterButton.titleLabel.font=[UIFont systemFontOfSize:8.5+GZDeviceWidth/35];
    [deterButton addTarget:self action:@selector(deterMethod) forControlEvents:UIControlEventTouchUpInside];
    deterButton.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *thephoneString=[userDefaults objectForKey:@"myPhone"];
    NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
    
    NSString *pattern2 = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern2];
    
    if (_oldpswField.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请您先输入旧密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (![pred2 evaluateWithObject:_newpswField.text] || ![pred2 evaluateWithObject:_confirmpswField.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您输入的新密码或者确认密码不是8～16位数字和字母的结合" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (![_newpswField.text isEqualToString:_confirmpswField.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您输入的新密码和确认密码不一样,请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([pred2 evaluateWithObject:_newpswField.text] && [pred2 evaluateWithObject:_confirmpswField.text] && [_newpswField.text isEqualToString:_confirmpswField.text]) {
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/muser/changePassword"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10.0f];//超过这个时间就算超时，请求失败
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:mytoken forKey:@"token"];
        [parameters setValue:thephoneString forKey:@"mobile"];
        [parameters setValue:_oldpswField.text forKey:@"oldPassword"];
        [parameters setValue:_newpswField.text forKey:@"password"];
        [parameters setValue:@"8" forKey:@"messageTypeId"];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *args = [self convertToJsonData:parameters];
        request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
        // 3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.根据会话对象，创建一个Task任务
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.darkview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, GZDeviceHeight)];
                self.darkview.backgroundColor=[UIColor blackColor];
                self.darkview.alpha=0.6f;
                [self.view addSubview:self.darkview];
                self.view.userInteractionEnabled=NO;
            });
        
            // 10、判断是否请求成功
            if (error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.view.userInteractionEnabled=YES;
                    [self.darkview removeFromSuperview];
                });
                
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
                    theLabel.text=@"你没有连接网络";
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
                    NSLog(@"post error :%@",error.localizedDescription);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.view.userInteractionEnabled=YES;
                        [self.darkview removeFromSuperview];
                    });
                    
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
                    NSDictionary *dict2=[object1 objectForKey:@"resultMap"];
                    NSDictionary *dict3=[dict2 objectForKey:@"user"];
                    NSString *str4=[dict3 objectForKey:@"password"];
                    
                    NSLog(@"解析出来的code：%@",str0);
                    NSLog(@"解析出来的desc：%@",str1);
                    NSLog(@"解析出来的resultMap：%@",dict2);
                    NSLog(@"解析出来的str4：%@",str4);
                    
                    if ([str00 isEqualToString:@"0"]) {
                        
                        NSLog(@"post error :%@",error.localizedDescription);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*5/6)/2, GZDeviceHeight/2, GZDeviceWidth*5/6, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"成功修改密码，请记住你的密码";
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
                        
                        [NSThread sleepForTimeInterval:1.5f];//此方法是一种阻塞执行方式，建议放在子线程中执行，否则会卡住界面。但有时还是需要阻塞执行，如进入欢迎界面需要沉睡3秒才进入主界面时。
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.view.userInteractionEnabled=YES;
                            [self.darkview removeFromSuperview];
                        });
                        
                        LoginViewController *login=[[LoginViewController alloc] init];
                        [self presentViewController:login animated:YES completion:nil];
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.view.userInteractionEnabled=YES;
                            [self.darkview removeFromSuperview];
                        });
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str1 preferredStyle:UIAlertControllerStyleAlert];
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

-(void)backMethod
{
    NSLog(@"dianji");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击空白处关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    [_oldpswField resignFirstResponder];
    [_newpswField resignFirstResponder];
    [_confirmpswField resignFirstResponder];
}

//视图快消失时隐藏键盘
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_oldpswField resignFirstResponder];
    [_newpswField resignFirstResponder];
    [_confirmpswField resignFirstResponder];
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
