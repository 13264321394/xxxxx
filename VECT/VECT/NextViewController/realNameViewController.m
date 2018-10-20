//
//  realNameViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/6.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "realNameViewController.h"
#import "UploaddocumentsViewController.h"
#import "thirdViewController.h"
#import "LoginViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"

@interface realNameViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UITextField *nameField;
@property(nonatomic,strong)UITextField *phoneTextField;
//@property(nonatomic,strong)UITextField *emailTextField;
//@property(nonatomic,strong)UITextField *shenfenTextField;
@property(nonatomic,retain)NSArray *dataList;
@property (nonatomic,copy)NSString *sexPick;
@property(nonatomic,strong)UIScrollView *myscrollView;
@property(nonatomic,strong)UIScrollView *scrollView1;
@property(nonatomic,assign)float h;
@property(nonatomic,strong)UIButton *deterButton;
@property(nonatomic,strong)UIView *view0;
@property(nonatomic,strong)UIButton *deterButtonnext;

@end

@implementation realNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *realnameLabel=[[UILabel alloc] init];
    realnameLabel.text=@"实名认证";
    realnameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:realnameLabel];
    [realnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight);
        make.left.mas_equalTo(GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/2, 44));
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mytype=[userDefaults stringForKey:@"mytype"];
    
    NSLog(@"mytype mytype mytype mytype==%@", mytype);
    
    if (![mytype isEqualToString:@"1"]) {
        
        _myscrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight)];
        _myscrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [self.view addSubview:_myscrollView];
        _myscrollView.contentSize=CGSizeMake(GZDeviceWidth, 20+44+GZDeviceHeight/4+GZDeviceHeight*2/5+10+GZDeviceHeight/4);//内容大小
        _myscrollView.showsHorizontalScrollIndicator = YES;
        _myscrollView.showsVerticalScrollIndicator = YES;
        _myscrollView.delegate=self;
        
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
        [_myscrollView addGestureRecognizer:myTap];
        
        //下拉刷新
        _myscrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //刷新时候，需要执行的代码。一般是请求最新数据，请求成功之后，刷新列表
            [self loadNewData];
        }];
        // 马上进入刷新状态
        [_myscrollView.mj_header beginRefreshing];
        
        
        //做项目的时候发现UIScrollView 回弹有问题,不能回弹到原来的位置,只能到状态栏下面,在此记录下。主要是 iOS11 新增的 contentInsetAdjustmentBehavior。改成下面的就可以了
        //在iOS 11以下，控制器有automaticallyAdjustsScrollViewInsets属性，默认为YES。所以要设置成NO
        if (@available(iOS 11.0, *)) {
            _myscrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        

    }
    
    if ([mytype isEqualToString:@"1"]) {
        //实名认证通过
        [self realnameauthentication];
    } else if([mytype isEqualToString:@"2"]) {
        //审核被拒绝
        [self throughrealnameauthentication];
    } else if ([mytype isEqualToString:@"0"]) {
        //正在审核
        [self isreviewing];
    } else if([mytype isEqualToString:@"-1"] || [mytype isEqualToString:@""]) {
        //没有提交实名认证
        [self norealnameauthentication];
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mytype=[userDefaults stringForKey:@"mytype"];
    if (![mytype isEqualToString:@"1"]) {
        [super viewWillAppear:animated];
        [_myscrollView.mj_header beginRefreshing];
    }
}

- (void)scrollTap:(id)sender {
    [self.view endEditing:YES];
}

-(void)mybutton
{
    self.deterButton=[[UIButton alloc] init];
    [self.deterButton setTitle:@"提 交" forState:UIControlStateNormal];
    self.deterButton.titleLabel.font=[UIFont systemFontOfSize:18.f];
    self.deterButton.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    [self.deterButton addTarget:self action:@selector(deterMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.myscrollView addSubview:self.deterButton];
    [self.deterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GZDeviceHeight-(25+GZDeviceHeight/30)-StatusbarHeight-44);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 25+GZDeviceHeight/30));
    }];
}

- (void)loadNewData {
    NSLog(@"请求获取最新的数据");
    
    //这里假设2秒之后获取到了最新的数据，刷新tableview，并且结束刷新控件的刷新状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //刷新列表0ii
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            //数据请求部分
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *myuserId0=[userDefaults stringForKey:@"myuserId"];
            NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
            
            NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/rest/imgUpload/isRealName"]];
            // 2.创建一个网络请求，分别设置请求方法、请求参数
            NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setValue:mytoken forKey:@"token"];
            [parameters setValue:myuserId0 forKey:@"id"];
            
            request.HTTPMethod = @"POST";
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSString *args = [self convertToJsonData:parameters];
            request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
            // 3.获得会话对象
            NSURLSession *session = [NSURLSession sharedSession];
            // 4.根据会话对象，创建一个Task任务
            NSLog(@"创建一个task任务");
            NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
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
                        NSDictionary *dict2=[object1 objectForKey:@"resultMap"];
                        
                        NSLog(@"解析出来的dd code：%@",str0);
                        NSLog(@"解析出来的dd desc：%@",str1);
                        NSLog(@"解析出来的dd resultMap：%@",dict2);
                        NSString *str2=[[[object1 objectForKey:@"resultMap"] objectForKey:@"tuser"] objectForKey:@"type"];
                        
                        NSLog(@"解析出来的type====：%@",str2);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if ([str00 isEqualToString:@"200"]) {
                                
                                if ([str2 isEqualToString:@"0"]) {
                                    [self.deterButton removeFromSuperview];
                                    [self mybutton];
                                    self.deterButton.enabled=NO;
                                    self.deterButton.userInteractionEnabled=NO; self.deterButton.backgroundColor=[UIColor grayColor];
                                    //thelabe.textColor=[UIColor orangeColor];
                                    //thelabe.text=@"你提交的实名认证信息正在审核中...";
                                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*9/10)/2, GZDeviceHeight*3.5/5, GZDeviceWidth*9/10, 20+GZDeviceHeight/25)];
                                    theLabel.backgroundColor=[UIColor blackColor];
                                    theLabel.textColor=[UIColor whiteColor];
                                    theLabel.alpha=0.8f;
                                    theLabel.textAlignment=NSTextAlignmentCenter;
                                    theLabel.font=[UIFont systemFontOfSize:13.f];
                                    theLabel.text=@"你上次提交的实名认证信息正在审核中...";
                                    [self.view addSubview:theLabel];
                                    
                                    //设置动画
                                    CATransition *transion=[CATransition animation];
                                    transion.type=@"push";//动画方式
                                    transion.subtype=@"fromRight";//设置动画从哪个方向开始
                                    [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                                    //不占用主线程
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                        
                                        [theLabel removeFromSuperview];
                                        
                                    });//这句话的意思是1.5秒后，把label移出视图
                                } else if ([str2 isEqualToString:@"1"]) {
                                    //[self realnameauthentication];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        UIView *theView=[[UIView alloc] initWithFrame:self.view.frame];
                                        theView.backgroundColor=[UIColor blackColor];
                                        [self.view addSubview:theView];
                                        theView.alpha=0.6;
                                        
                                        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*0.8)/2, GZDeviceHeight*3.5/5, GZDeviceWidth*0.8, 20+GZDeviceHeight/25)];
                                        theLabel.backgroundColor=[UIColor blackColor];
                                        theLabel.layer.cornerRadius = 5.f;
                                        theLabel.clipsToBounds = YES;
                                        theLabel.textColor=[UIColor whiteColor];
                                        theLabel.alpha=0.8f;
                                        theLabel.textAlignment=NSTextAlignmentCenter;
                                        theLabel.font=[UIFont systemFontOfSize:15.f];
                                        theLabel.text=@"成功通过审核，即将跳转到登录界面";
                                        [self.view addSubview:theLabel];
                                        
                                        //设置动画
                                        CATransition *transion=[CATransition animation];
                                        transion.type=@"push";//动画方式
                                        transion.subtype=@"fromRight";//设置动画从哪个方向开始
                                        [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                                        //不占用主线程
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                            
                                            [theLabel removeFromSuperview];
                                            [theView removeFromSuperview];
                                            
                                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"islogin"];
                                            LoginViewController *login=[[LoginViewController alloc] init];
                                            [self presentViewController:login animated:YES completion:nil];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBgColor" object:nil userInfo:nil];
                                            
                                        });//这句话的意思是1.5秒后，把label移出视图
                                    });
                                    
                                } else if ([str2 isEqualToString:@"2"]) {
                                    
                                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*9/10)/2, GZDeviceHeight*3.5/5, GZDeviceWidth*9/10, 20+GZDeviceHeight/25)];
                                    theLabel.backgroundColor=[UIColor blackColor];
                                    theLabel.textColor=[UIColor whiteColor];
                                    theLabel.alpha=0.8f;
                                    theLabel.textAlignment=NSTextAlignmentCenter;
                                    theLabel.font=[UIFont systemFontOfSize:13.f];
                                    theLabel.text=@"你上次提交的实名认证信息失败,请重新提交";
                                    [self.view addSubview:theLabel];
                                    
                                    //设置动画
                                    CATransition *transion=[CATransition animation];
                                    transion.type=@"push";//动画方式
                                    transion.subtype=@"fromRight";//设置动画从哪个方向开始
                                    [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                                    //不占用主线程
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                        
                                        [theLabel removeFromSuperview];
                                        
                                    });//这句话的意思是1.5秒后，把label移出视图
                                    [self.deterButton removeFromSuperview];
                                    [self mybutton];
                                    self.deterButton.enabled=YES;
                                    self.deterButton.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
                                } else if ([str2 isEqualToString:@"-1"] || [str2 isEqualToString:@""]) {
                                    [self.deterButton removeFromSuperview];
                                    [self mybutton];
                                    self.deterButton.enabled=YES;
                                    self.deterButton.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
                                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*9/10)/2, GZDeviceHeight*3.5/5, GZDeviceWidth*9/10, 20+GZDeviceHeight/25)];
                                    theLabel.backgroundColor=[UIColor blackColor];
                                    theLabel.textColor=[UIColor whiteColor];
                                    theLabel.alpha=0.8f;
                                    theLabel.textAlignment=NSTextAlignmentCenter;
                                    theLabel.font=[UIFont systemFontOfSize:13.f];
                                    theLabel.text=@"请先提交实名认证信息";
                                    [self.view addSubview:theLabel];
                                    
                                    //设置动画
                                    CATransition *transion=[CATransition animation];
                                    transion.type=@"push";//动画方式
                                    transion.subtype=@"fromRight";//设置动画从哪个方向开始
                                    [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                                    //不占用主线程
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                        [theLabel removeFromSuperview];
                                        
                                    });//这句话的意思是1.5秒后，把label移出视图
                                }
                            } else {
                                
                                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*3/4)/2, GZDeviceHeight*3.5/5, GZDeviceWidth*3/4, 20+GZDeviceHeight/25)];
                                theLabel.backgroundColor=[UIColor blackColor];
                                theLabel.textColor=[UIColor whiteColor];
                                theLabel.alpha=0.8f;
                                theLabel.textAlignment=NSTextAlignmentCenter;
                                theLabel.font=[UIFont systemFontOfSize:13.f];
                                theLabel.text=str1;
                                [self.view addSubview:theLabel];
                                
                                //设置动画
                                CATransition *transion=[CATransition animation];
                                transion.type=@"push";//动画方式
                                transion.subtype=@"fromRight";//设置动画从哪个方向开始
                                [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                                //不占用主线程
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                    
                                    [theLabel removeFromSuperview];
                                    
                                });//这句话的意思是1.5秒后，把label移出视图
                                
                            }
                        });
                    }
                }
            }];
            //5.最后一步，执行任务，(resume也是继续执行)。
            [sessionDataTask resume];
        });
        //[_myscrollView reloadData];
        //拿到当前的刷新控件，结束刷新状态
        [self.myscrollView.mj_header endRefreshing];
    });
}

//没有提交过实名认证信息
-(void)norealnameauthentication
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self auditnotice];//刚注册，登陆成功后没完成实名认证前弹出的公告详情
        
        UILabel *nameLabel=[[UILabel alloc] init];
        nameLabel.text=@"姓名";
        [self.myscrollView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
        }];
        
        self.nameField=[[UITextField alloc] init];
        self.nameField.placeholder=@"请输入您的真实姓名";
        self.nameField.keyboardType=UIKeyboardTypeNamePhonePad;//支持中文
        self.nameField.rightViewMode=UITextFieldViewModeAlways;
        self.nameField.adjustsFontSizeToFitWidth = YES;
        [self.nameField setClearsOnBeginEditing:YES];
        [self.myscrollView addSubview:self.nameField];
        [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(10+GZDeviceWidth/4);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
        }];
        
        UIView *grayView1=[[UIView alloc] init];
        grayView1.backgroundColor=[UIColor lightGrayColor];
        [self.myscrollView addSubview:grayView1];
        [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+GZDeviceHeight/20);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
        }];
        
        UILabel *sexLabel=[[UILabel alloc] init];
        sexLabel.text=@"性别";
        [self.myscrollView addSubview:sexLabel];
        [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+GZDeviceHeight/20+1);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
        }];
        
        UIPickerView *pickView=[[UIPickerView alloc] init];
        pickView.delegate=self;
        pickView.dataSource=self;
        //pickView.backgroundColor=[UIColor purpleColor];
        pickView.showsSelectionIndicator=YES;
        [self.myscrollView addSubview:pickView];
        [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+GZDeviceHeight/20+1);
            make.left.mas_equalTo(10+GZDeviceWidth/4);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
        }];
        
        NSArray *list = [NSArray arrayWithObjects:@"男",@"女", nil];
        self.dataList = list;
        self.sexPick=self.dataList[0];
        
        UIView *grayView2=[[UIView alloc] init];
        grayView2.backgroundColor=[UIColor lightGrayColor];
        [self.myscrollView addSubview:grayView2];
        [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
        }];
        
        UILabel *phoneLabel=[[UILabel alloc] init];
        phoneLabel.text=@"身份证号";
        [self.myscrollView addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/3, 20+GZDeviceHeight/20));
        }];
        
        self.phoneTextField=[[UITextField alloc] init];
        self.phoneTextField.placeholder=@"请输入身份证号";
        self.phoneTextField.keyboardType=UIKeyboardTypeASCIICapable;
        self.phoneTextField.clearButtonMode = UITextFieldViewModeAlways;//输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
        //_phoneTextField.rightViewMode=UITextFieldViewModeAlways;
        self.phoneTextField.adjustsFontSizeToFitWidth = YES;
        [self.phoneTextField setClearsOnBeginEditing:YES];
        [self.myscrollView addSubview:self.phoneTextField];
        [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
            make.left.mas_equalTo(10+GZDeviceWidth/4);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-10-GZDeviceWidth/4, 20+GZDeviceHeight/20));
        }];
        
        UIView *grayView3=[[UIView alloc] init];
        grayView3.backgroundColor=[UIColor lightGrayColor];
        [self.myscrollView addSubview:grayView3];
        [grayView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
        }];
        
        UIButton *uploadButton=[[UIButton alloc] init];
        uploadButton.backgroundColor=[UIColor whiteColor];
        [uploadButton addTarget:self action:@selector(uploadMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.myscrollView addSubview:uploadButton];
        [uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-10*2, 20+GZDeviceHeight/20));
        }];
        
        UILabel *uploadLabel=[[UILabel alloc] init];
        uploadLabel.text=@"上传证件";
        [self.myscrollView addSubview:uploadLabel];
        [uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+(GZDeviceHeight/20)+1+(20+GZDeviceHeight/20)+1+(20+GZDeviceHeight/20)+1);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
        }];
        
        self.deterButton=[[UIButton alloc] init];
        [self.deterButton setTitle:@"提 交" forState:UIControlStateNormal];
        self.deterButton.titleLabel.font=[UIFont systemFontOfSize:18.f];
        self.deterButton.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
        [self.deterButton addTarget:self action:@selector(deterMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.myscrollView addSubview:self.deterButton];
        [self.deterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(GZDeviceHeight-(25+GZDeviceHeight/30)-StatusbarHeight-44);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 25+GZDeviceHeight/30));
        }];
    });
}

//正在审核
-(void)isreviewing
{
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.text=@"姓名";
    [self.myscrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    _nameField=[[UITextField alloc] init];
    _nameField.placeholder=@"请输入您的真实姓名";
    _nameField.keyboardType=UIKeyboardTypeNamePhonePad;//支持中文
    _nameField.rightViewMode=UITextFieldViewModeAlways;
    _nameField.adjustsFontSizeToFitWidth = YES;
    [_nameField setClearsOnBeginEditing:YES];
    [self.myscrollView addSubview:_nameField];
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
    }];
    
    UIView *grayView1=[[UIView alloc] init];
    grayView1.backgroundColor=[UIColor lightGrayColor];
    [self.myscrollView addSubview:grayView1];
    [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UILabel *sexLabel=[[UILabel alloc] init];
    sexLabel.text=@"性别";
    [self.myscrollView addSubview:sexLabel];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.delegate=self;
    pickView.dataSource=self;
    //pickView.backgroundColor=[UIColor purpleColor];
    pickView.showsSelectionIndicator=YES;
    [self.myscrollView addSubview:pickView];
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
    }];
    
    NSArray *list = [NSArray arrayWithObjects:@"男",@"女", nil];
    self.dataList = list;
    _sexPick=self.dataList[0];
    
    UIView *grayView2=[[UIView alloc] init];
    grayView2.backgroundColor=[UIColor lightGrayColor];
    [self.myscrollView addSubview:grayView2];
    [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UILabel *phoneLabel=[[UILabel alloc] init];
    phoneLabel.text=@"身份证号";
    [self.myscrollView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/3, 20+GZDeviceHeight/20));
    }];
    
    _phoneTextField=[[UITextField alloc] init];
    _phoneTextField.placeholder=@"请输入身份证号";
    _phoneTextField.keyboardType=UIKeyboardTypeASCIICapable;
    _phoneTextField.clearButtonMode = UITextFieldViewModeAlways;//输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    //_phoneTextField.rightViewMode=UITextFieldViewModeAlways;
    _phoneTextField.adjustsFontSizeToFitWidth = YES;
    [_phoneTextField setClearsOnBeginEditing:YES];
    [self.myscrollView addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-10-GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    UIView *grayView3=[[UIView alloc] init];
    grayView3.backgroundColor=[UIColor lightGrayColor];
    [self.myscrollView addSubview:grayView3];
    [grayView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UIButton *uploadButton=[[UIButton alloc] init];
    uploadButton.backgroundColor=[UIColor whiteColor];
    [uploadButton addTarget:self action:@selector(uploadMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.myscrollView addSubview:uploadButton];
    [uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-10*2, 20+GZDeviceHeight/20));
    }];
    
    UILabel *uploadLabel=[[UILabel alloc] init];
    uploadLabel.text=@"上传证件";
    [self.myscrollView addSubview:uploadLabel];
    [uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+(GZDeviceHeight/20)+1+(20+GZDeviceHeight/20)+1+(20+GZDeviceHeight/20)+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    _deterButton.enabled=NO;
    _deterButton.backgroundColor=[UIColor grayColor];
}

//公告详情
-(void)auditnotice
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        self.view0=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, GZDeviceHeight)];
        self.view0.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:self.view0];
        
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, StatusbarHeight+44)];
        view1.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
        [self.view0 addSubview:view1];
        
        UILabel *gongaoLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, StatusbarHeight, GZDeviceWidth/2, 44)];
        gongaoLabel.text=@"公告详情";
        gongaoLabel.textAlignment=NSTextAlignmentCenter;
        gongaoLabel.font=[UIFont systemFontOfSize:20.f];
        gongaoLabel.textColor=[UIColor whiteColor];
        [self.view0 addSubview:gongaoLabel];
        
        NSString *str = @"\n公告致尊敬的vect会员：\n       自vect钱包推广奖励政策上线以来，截止到现在短短的一个半月内我们vect钱包注册用户已突破5万人，为更好的使广大vect会员及时了解vect项目的最新进展，提升注册用户的参与感，经vect运营委员会研究决定，自５月２４日起，新注册钱包的会员需要添加VECT官方客服发送本人姓名以及注册账号，方可通过认证并获得注册奖励。感恩各位VECT会员，前进的路上与各位相伴，我们一直在努力，只为更好的将来！\n注：实名审核时间为周1至周6, 9:00—18:00";
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 3; //设置行间距
        NSDictionary *attributeDict = @{
                                        NSFontAttributeName: [UIFont systemFontOfSize:15.f],
                                        NSForegroundColorAttributeName: [UIColor blackColor],
                                        NSKernAttributeName: @2, NSParagraphStyleAttributeName: paragraph};
        //3，根据属性字典和字符串，计算字符串使用指定的属性设置时候，占用空间的大小，返回CGRect类型
        CGSize contentSize = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attributeDict
                                               context:nil].size;//计算文字大小
        
        //4，构建带格式的文本字符串
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attributeDict];
        //5，构建label
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(10, StatusbarHeight+44, contentSize.width, contentSize.height);
        textLabel.numberOfLines = 0; //设置分行显示，必须必须设置这个属性
        //6,将格式化的文本添加到label上。
        textLabel.attributedText = attributeStr;
        [self.view0 addSubview:textLabel];
        
        UILabel *nextlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, StatusbarHeight+44+textLabel.frame.size.height, GZDeviceWidth-10*2, 30)];
        nextlabel.text=@"VECT运营团队";
        nextlabel.textAlignment=NSTextAlignmentRight;
        [self.view0 addSubview:nextlabel];
        
        //图片的宽高
        float wd=(GZDeviceWidth-GZDeviceWidth/10*2-GZDeviceWidth/20*2)/3;
        
        UILabel *abovelabel1=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/10, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/50, wd, 20)];
        abovelabel1.text=@"VECT官方客服";
        //abovelabel1.backgroundColor=[UIColor cyanColor];
        abovelabel1.font=[UIFont systemFontOfSize:10.f];
        abovelabel1.textAlignment=NSTextAlignmentCenter;
        [self.view0 addSubview:abovelabel1];
        
        UILabel *neabovelabel1=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/10, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/50*2, wd, 20)];
        neabovelabel1.text=@"伊一";
        //neabovelabel1.backgroundColor=[UIColor cyanColor];
        neabovelabel1.font=[UIFont systemFontOfSize:10.f];
        neabovelabel1.textAlignment=NSTextAlignmentCenter;
        [self.view0 addSubview:neabovelabel1];
        
        UILabel *abovelabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/10+wd+GZDeviceWidth/20, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/50, wd, 20)];
        abovelabel2.text=@"VECT官方客服";
        //abovelabel2.backgroundColor=[UIColor cyanColor];
        abovelabel2.font=[UIFont systemFontOfSize:10.f];
        abovelabel2.textAlignment=NSTextAlignmentCenter;
        [self.view0 addSubview:abovelabel2];
        
        UILabel *neabovelabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/10+wd+GZDeviceWidth/20, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/50*2, wd, 20)];
        neabovelabel2.text=@"雅楠";
        //neabovelabel2.backgroundColor=[UIColor cyanColor];
        neabovelabel2.font=[UIFont systemFontOfSize:10.f];
        neabovelabel2.textAlignment=NSTextAlignmentCenter;
        [self.view0 addSubview:neabovelabel2];
        
        UILabel *abovelabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/10+wd+GZDeviceWidth/20+wd+GZDeviceWidth/20, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/50, wd, 20)];
        abovelabel3.text=@"VECT官方客服";
        //abovelabel3.backgroundColor=[UIColor cyanColor];
        abovelabel3.font=[UIFont systemFontOfSize:10.f];
        abovelabel3.textAlignment=NSTextAlignmentCenter;
        [self.view0 addSubview:abovelabel3];
        
        UILabel *neabovelabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/10+wd+GZDeviceWidth/20+wd+GZDeviceWidth/20, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/50*2, wd, 20)];
        neabovelabel3.text=@"曼妮";
        //neabovelabel3.backgroundColor=[UIColor cyanColor];
        neabovelabel3.font=[UIFont systemFontOfSize:10.f];
        neabovelabel3.textAlignment=NSTextAlignmentCenter;
        [self.view0 addSubview:neabovelabel3];
        
        UIImageView *iv1=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/10, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/15, wd, wd)];
        iv1.image=[UIImage imageNamed:@"WechatIMG14.png"];
        [self.view0 addSubview:iv1];
        
        UIImageView *iv2=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/10+wd+GZDeviceWidth/20, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/15, wd, wd)];
        iv2.image=[UIImage imageNamed:@"WechatIMG15.png"];
        [self.view0 addSubview:iv2];
        
        UIImageView *iv3=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/10+wd+GZDeviceWidth/20+wd+GZDeviceWidth/20, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/15, wd, wd)];
        iv3.image=[UIImage imageNamed:@"WechatIMG16.png"];
        [self.view0 addSubview:iv3];
        
        UILabel *boomlabel1=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/10, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/15+wd, wd, 20)];
        boomlabel1.text=@"微信号VECT007";
        //boomlabel1.backgroundColor=[UIColor cyanColor];
        boomlabel1.font=[UIFont systemFontOfSize:10.f];
        boomlabel1.textAlignment=NSTextAlignmentCenter;
        [self.view0 addSubview:boomlabel1];
        
        UILabel *boomlabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/10+wd+GZDeviceWidth/20, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/15+wd, wd, 20)];
        boomlabel2.text=@"微信号VECT005";
        //boomlabel2.backgroundColor=[UIColor cyanColor];
        boomlabel2.font=[UIFont systemFontOfSize:10.f];
        boomlabel2.textAlignment=NSTextAlignmentCenter;
        [self.view0 addSubview:boomlabel2];
        
        UILabel *boomlabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/10+wd+GZDeviceWidth/20+wd+GZDeviceWidth/20, StatusbarHeight+44+textLabel.frame.size.height+GZDeviceHeight/20+GZDeviceHeight/15+wd, wd, 20)];
        boomlabel3.text=@"微信号VECT006";
        //boomlabel3.backgroundColor=[UIColor cyanColor];
        boomlabel3.font=[UIFont systemFontOfSize:10.f];
        boomlabel3.textAlignment=NSTextAlignmentCenter;
        [self.view0 addSubview:boomlabel3];
        
        UIButton *checkbox=[[UIButton alloc]initWithFrame:CGRectZero];
        [self.view0 addSubview:checkbox];
        checkbox.frame=CGRectMake(GZDeviceWidth/15,GZDeviceHeight-GZDeviceHeight/6,30,30);
        [checkbox setImage:[UIImage imageNamed:@"WechatIMG19.png"]forState:UIControlStateNormal];
        //设置正常时图片为    check_off.png
        [checkbox setImage:[UIImage imageNamed:@"WechatIMG20.png"]forState:UIControlStateSelected];
        //设置点击选中状态图片为check_on.png
        [checkbox addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
        [checkbox setSelected:YES];//设置按钮得状态是否为选中（可在此根据具体情况来设置按钮得初始状态）
        
        UILabel *agreelabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15+20+GZDeviceWidth/20, GZDeviceHeight-GZDeviceHeight/6, GZDeviceWidth*2/3, 30)];
        agreelabel.font=[UIFont systemFontOfSize:20.f];
        agreelabel.text=@"我已阅读并同意实名认证";
        [self.view0 addSubview:agreelabel];
        
        self.deterButtonnext=[[UIButton alloc] init];
        [self.deterButtonnext setTitle:@"确定" forState:UIControlStateNormal];
        self.deterButtonnext.titleLabel.font=[UIFont systemFontOfSize:18.f];
        self.deterButtonnext.backgroundColor=[UIColor lightGrayColor];
        self.deterButtonnext.userInteractionEnabled=NO;
        self.deterButton.userInteractionEnabled=NO;
        [self.deterButtonnext addTarget:self action:@selector(deternextMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.view0 addSubview:self.deterButtonnext];
        [self.deterButtonnext mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.top.mas_equalTo(300);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 25+GZDeviceHeight/30));
        }];
    });
}

-(void)deternextMethod
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view0 removeFromSuperview];
    });
}

//实现checkboxClick方法
-(void)checkboxClick:(UIButton*)btn{
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    if(btn.selected)
    {
        NSLog(@"没点击勾");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.deterButtonnext.userInteractionEnabled=NO;
            self.deterButton.userInteractionEnabled=NO;
            self.deterButtonnext.backgroundColor=[UIColor lightGrayColor];
        });
        
    } else {
        NSLog(@"点击了勾");
        //在此实现打勾时的方法
        dispatch_async(dispatch_get_main_queue(), ^{
            self.deterButtonnext.userInteractionEnabled=YES;
            self.deterButton.userInteractionEnabled=YES;
            self.deterButtonnext.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
        });
    }
}

//认证通过
-(void)realnameauthentication
{
    //[self auditnotice];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //self.myscrollView.userInteractionEnabled=NO;
        //[self.myscrollView removeFromSuperview];
        
        UIButton *backbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/50, StatusbarHeight+7, 18, 30)];
        [backbutton setImage:[UIImage imageNamed:@"返回 copy.png"] forState:UIControlStateNormal];
        [backbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [backbutton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backbutton];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        UIScrollView *scrollView1=[[UIScrollView alloc] init];
        
        if (StatusbarHeight==44) {
            scrollView1=[[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44)-34)];
        } else {
            scrollView1=[[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44))];
        }
        
        //UIScrollView *scrollView1=[[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44))];
        //scrollView1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        
        scrollView1.backgroundColor = [UIColor whiteColor];
        scrollView1.contentSize=CGSizeMake(GZDeviceWidth, 30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20+GZDeviceHeight/3.5+5+GZDeviceHeight/25+GZDeviceHeight/3.5+5+GZDeviceHeight/25+GZDeviceHeight/3.5+5+GZDeviceHeight/25+10+10);//内容大小
        scrollView1.showsHorizontalScrollIndicator = YES;
        scrollView1.showsVerticalScrollIndicator = YES;
        scrollView1.delegate=self;
        [self.view addSubview:scrollView1];
        
        UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, 10)];
        headView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [scrollView1 addSubview:headView];
        
        UILabel *namelabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, 10, GZDeviceWidth/5, 30+GZDeviceWidth/20)];
        namelabel.text=@"姓名";
        [scrollView1 addSubview:namelabel];
        
        UILabel *namelabeldd=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/20+GZDeviceWidth/3, 10, GZDeviceWidth/5, 30+GZDeviceWidth/20)];
        namelabeldd.text=[NSString stringWithFormat:@"%@", [userDefaults stringForKey:@"themyname"]];
        namelabeldd.textColor=[UIColor darkGrayColor];
        [scrollView1 addSubview:namelabeldd];
        
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 10+30+GZDeviceWidth/20, GZDeviceWidth, 1)];
        view1.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [scrollView1 addSubview:view1];
        
        UILabel *sexlabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, 10+30+GZDeviceWidth/20+1, GZDeviceWidth/5, 30+GZDeviceWidth/20)];
        sexlabel.text=@"性别";
        [scrollView1 addSubview:sexlabel];
        
        UILabel *sexlabeldd=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/20+GZDeviceWidth/3, 10+30+GZDeviceWidth/20+1, GZDeviceWidth/5, 30+GZDeviceWidth/20)];
        NSString *s5=[NSString stringWithFormat:@"%@",[userDefaults stringForKey:@"themysex"]];
        if ([s5 isEqualToString:@"0"]) {
            sexlabeldd.text=@"女";
        } else {
            sexlabeldd.text=@"男";
        }
        sexlabeldd.textColor=[UIColor darkGrayColor];
        [scrollView1 addSubview:sexlabeldd];
        
        UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(0, 10+30+GZDeviceWidth/20+30+GZDeviceWidth/20+1, GZDeviceWidth, 1)];
        view2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [scrollView1 addSubview:view2];
        
        UILabel *crlabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, 10+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20, GZDeviceWidth/3, 30+GZDeviceWidth/20)];
        crlabel.text=@"身份证号";
        [scrollView1 addSubview:crlabel];
        
        UILabel *crlabeldd=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/20+GZDeviceWidth/3, 10+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20, GZDeviceWidth/2+20, 30+GZDeviceWidth/20)];
        crlabeldd.font=[UIFont systemFontOfSize:15.f];
        crlabeldd.text=[NSString stringWithFormat:@"%@", [userDefaults stringForKey:@"themyshenfenID"]];
        crlabeldd.textColor=[UIColor darkGrayColor];
        [scrollView1 addSubview:crlabeldd];
        
        UIView *view3=[[UIView alloc] initWithFrame:CGRectMake(0, 10+30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20, GZDeviceWidth, 10)];
        view3.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [scrollView1 addSubview:view3];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *imaStr=@"http://vectwallet.com/myimg/";
            NSError *error1=nil;
            NSURL *url1=[NSURL URLWithString:[imaStr stringByAppendingString:[NSString stringWithFormat:@"%@", [userDefaults stringForKey:@"themyimagepath3"]]]];
            NSURLRequest *request1=[[NSURLRequest alloc] initWithURL:url1];
            NSData *imgData1=[NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:&error1];
            
            NSError *error2=nil;
            NSURL *url2=[NSURL URLWithString:[imaStr stringByAppendingString:[NSString stringWithFormat:@"%@", [userDefaults stringForKey:@"themyimagepath1"]]]];
            NSURLRequest *request2=[[NSURLRequest alloc] initWithURL:url2];
            NSData *imgData2=[NSURLConnection sendSynchronousRequest:request2 returningResponse:nil error:&error2];
            
            NSError *error3=nil;
            NSURL *url3=[NSURL URLWithString:[imaStr stringByAppendingString:[NSString stringWithFormat:@"%@", [userDefaults stringForKey:@"themyimagepath2"]]]];
            NSURLRequest *request3=[[NSURLRequest alloc] initWithURL:url3];
            NSData *imgData3=[NSURLConnection sendSynchronousRequest:request3 returningResponse:nil error:&error3];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *pathimageView1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10+30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20+10,GZDeviceWidth, GZDeviceHeight/3.5)];
                [scrollView1 addSubview:pathimageView1];
                UIImage *img1=nil;
                if(imgData1)
                {
                    img1=[UIImage imageWithData:imgData1];
                    pathimageView1.image=img1;
                }
                
                UIImageView *pathimageView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10+30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20+GZDeviceHeight/3.5+5+GZDeviceHeight/25+10,GZDeviceWidth, GZDeviceHeight/3.5)];
                [scrollView1 addSubview:pathimageView2];
                UIImage *img2=nil;
                if(imgData2)
                {
                    img2=[UIImage imageWithData:imgData2];
                    pathimageView2.image=img2;
                }
                
                UIImageView *pathimageView3=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10+30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20+GZDeviceHeight/3.5+5+GZDeviceHeight/25+GZDeviceHeight/3.5+5+GZDeviceHeight/25+10,GZDeviceWidth, GZDeviceHeight/3.5)];
                [scrollView1 addSubview:pathimageView3];
                UIImage *img3=nil;
                if(imgData3)
                {
                    img3=[UIImage imageWithData:imgData3];
                    pathimageView3.image=img3;
                }
            });
        });
        
        //下面这个方法图片显示出来比较慢，所以用上面的方法代替
        /*
         //处理耗时的逻辑操作
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
         //complex logic operation
         
         UIImage *image1=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imaStr stringByAppendingString:[NSString stringWithFormat:@"%@", [userDefaults stringForKey:@"themyimagepath3"]]]]]]];
         UIImage *image2=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imaStr stringByAppendingString:[NSString stringWithFormat:@"%@", [userDefaults stringForKey:@"themyimagepath1"]]]]]]];
         UIImage *image3=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imaStr stringByAppendingString:[NSString stringWithFormat:@"%@", [userDefaults stringForKey:@"themyimagepath2"]]]]]]];
         
         dispatch_async(dispatch_get_main_queue(), ^{
         UIImageView *pathimageView1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20,GZDeviceWidth, GZDeviceHeight/3.5)];
         pathimageView1.image=image1;
         [scrollView1 addSubview:pathimageView1];
         
         UIImageView *pathimageView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20+GZDeviceHeight/3.5+5+GZDeviceHeight/25,GZDeviceWidth, GZDeviceHeight/3.5)];
         pathimageView2.image=image2;
         [scrollView1 addSubview:pathimageView2];
         
         UIImageView *pathimageView3=[[UIImageView alloc] initWithFrame:CGRectMake(0, 30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20+GZDeviceHeight/3.5+5+GZDeviceHeight/25+GZDeviceHeight/3.5+5+GZDeviceHeight/25,GZDeviceWidth, GZDeviceHeight/3.5)];
         pathimageView3.image=image3;
         [scrollView1 addSubview:pathimageView3];
         });
         });
         */
        
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 10+30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20+GZDeviceHeight/3.5+10, GZDeviceWidth, 5+GZDeviceHeight/25)];
        label1.text=@"身份证正面";
        label1.font=[UIFont systemFontOfSize:13.f];
        label1.textColor=[UIColor darkGrayColor];
        label1.textAlignment=NSTextAlignmentCenter;
        [scrollView1 addSubview:label1];
        
        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 10+30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20+GZDeviceHeight/3.5+5+GZDeviceHeight/25+GZDeviceHeight/3.5+10, GZDeviceWidth, 5+GZDeviceHeight/25)];
        label2.text=@"身份证反面";
        label2.font=[UIFont systemFontOfSize:13.f];
        label2.textColor=[UIColor darkGrayColor];
        label2.textAlignment=NSTextAlignmentCenter;
        [scrollView1 addSubview:label2];
        
        UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(0, 10+30+GZDeviceWidth/20+30+GZDeviceWidth/20+1+1+30+GZDeviceWidth/20+GZDeviceHeight/3.5+5+GZDeviceHeight/25+GZDeviceHeight/3.5+5+GZDeviceHeight/25+GZDeviceHeight/3.5+10, GZDeviceWidth, 5+GZDeviceHeight/25)];
        label3.text=@"手执身份证";
        label3.font=[UIFont systemFontOfSize:13.f];
        label3.textColor=[UIColor darkGrayColor];
        label3.textAlignment=NSTextAlignmentCenter;
        [scrollView1 addSubview:label3];
        
        //NSLog(@"进入到了通过界面");
        
    });
}

//实名认证审核被拒
-(void)throughrealnameauthentication
{
    
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.text=@"姓名";
    [self.myscrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    _nameField=[[UITextField alloc] init];
    _nameField.placeholder=@"请输入您的真实姓名";
    _nameField.keyboardType=UIKeyboardTypeNamePhonePad;//支持中文
    _nameField.rightViewMode=UITextFieldViewModeAlways;
    _nameField.adjustsFontSizeToFitWidth = YES;
    [_nameField setClearsOnBeginEditing:YES];
    [self.myscrollView addSubview:_nameField];
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
    }];
    
    UIView *grayView1=[[UIView alloc] init];
    grayView1.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.myscrollView addSubview:grayView1];
    [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UILabel *sexLabel=[[UILabel alloc] init];
    sexLabel.text=@"性别";
    [self.myscrollView addSubview:sexLabel];
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.delegate=self;
    pickView.dataSource=self;
    //pickView.backgroundColor=[UIColor purpleColor];
    pickView.showsSelectionIndicator=YES;
    [self.myscrollView addSubview:pickView];
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-GZDeviceWidth/4-10, 20+GZDeviceHeight/20));
    }];
    
    NSArray *list = [NSArray arrayWithObjects:@"男",@"女", nil];
    self.dataList = list;
    _sexPick=self.dataList[0];
    
    UIView *grayView2=[[UIView alloc] init];
    grayView2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.myscrollView addSubview:grayView2];
    [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UILabel *phoneLabel=[[UILabel alloc] init];
    phoneLabel.text=@"身份证号";
    [self.myscrollView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/3, 20+GZDeviceHeight/20));
    }];
    
    _phoneTextField=[[UITextField alloc] init];
    _phoneTextField.placeholder=@"请输入身份证号";
    _phoneTextField.keyboardType=UIKeyboardTypeASCIICapable;
    _phoneTextField.clearButtonMode = UITextFieldViewModeAlways;//输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    //_phoneTextField.rightViewMode=UITextFieldViewModeAlways;
    _phoneTextField.adjustsFontSizeToFitWidth = YES;
    [_phoneTextField setClearsOnBeginEditing:YES];
    [self.myscrollView addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(10+GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth-10-GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    UIView *grayView3=[[UIView alloc] init];
    grayView3.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.myscrollView addSubview:grayView3];
    [grayView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 1));
    }];
    
    UILabel *uploadLabel=[[UILabel alloc] init];
    uploadLabel.text=@"上传证件";
    [self.myscrollView addSubview:uploadLabel];
    [uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+(GZDeviceHeight/20)+1+(20+GZDeviceHeight/20)+1+(20+GZDeviceHeight/20)+1);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/4, 20+GZDeviceHeight/20));
    }];
    
    UIButton *uploadButton=[[UIButton alloc] init];
    uploadButton.backgroundColor=[UIColor whiteColor];
    [uploadButton addTarget:self action:@selector(uploadMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.myscrollView addSubview:uploadButton];
    [uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1+20+GZDeviceHeight/20+1);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 20+GZDeviceHeight/20));
    }];
    
    _deterButton=[[UIButton alloc] init];
    [_deterButton setTitle:@"确 认" forState:UIControlStateNormal];
    _deterButton.titleLabel.font=[UIFont systemFontOfSize:18.f];
    _deterButton.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    [_deterButton addTarget:self action:@selector(deterMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.myscrollView addSubview:_deterButton];
    [_deterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GZDeviceHeight-(25+GZDeviceHeight/30)-20-44);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 25+GZDeviceHeight/30));
    }];
    
    NSLog(@"性别：%@", _sexPick);
}

-(void)deterMethod
{
    NSLog(@"点击了实名认证界面的确认按钮");
    
    //NSString *frontstr=@"http://vectwallet.com";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myuserId0=[userDefaults stringForKey:@"myuserId"];
    NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
    
    NSString *path1=[userDefaults stringForKey:@"imagepath1"];
    NSString *path2=[userDefaults stringForKey:@"imagepath2"];
    NSString *path3=[userDefaults stringForKey:@"imagepath3"];
    
    NSLog(@"上传的ipmagepath1==%@", path1);
    
    if ((_nameField.text.length==0) || (_phoneTextField.text.length==0))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入姓名，性别，身份证" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (_phoneTextField.text.length!=18) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"身份证格式不对" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ((path1.length==0) || (path2.length==0) || (path3.length==0)) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择上传照片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ((_nameField.text.length!=0) && (_phoneTextField.text.length!=0) && (_phoneTextField.text.length==18) && (path1.length!=0) && (path2.length!=0) && (path3.length!=0)) {
        
        
        NSLog(@"点击了确定按钮后的路径1=%@", path1);
        NSLog(@"点击了确定按钮后的路径2=%@", path2);
        NSLog(@"点击了确定按钮后的路径3=%@", path3);
        NSLog(@"点击了确定按钮后的userId=%@", myuserId0);
        NSLog(@"点击了确定按钮后的身份证=%@", _phoneTextField.text);
        NSLog(@"点击了确定按钮后的性别=%@", _sexPick);
        NSLog(@"点击了确定按钮后的姓名=%@", _nameField.text);
        
         
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/rest/imgUpload/updateUser"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:mytoken forKey:@"token"];
        [parameters setValue:myuserId0 forKey:@"id"];
        [parameters setValue:_phoneTextField.text forKey:@"user_no"];
        [parameters setValue:_nameField.text forKey:@"username"];
        [parameters setValue:_sexPick forKey:@"sexNo"];
        [parameters setValue:path1 forKey:@"zm"];
        [parameters setValue:path2 forKey:@"fm"];
        [parameters setValue:path3 forKey:@"sc"];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *args = [self convertToJsonData:parameters];
        request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
        // 3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.根据会话对象，创建一个Task任务
        NSLog(@"创建一个task任务");
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
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
                    NSDictionary *dict2=[object1 objectForKey:@"resultMap"];
                    
                    NSLog(@"解析出来的code：%@",str0);
                    NSLog(@"解析出来的desc：%@",str1);
                    NSLog(@"解析出来的resultMap：%@",dict2);
                    //NSLog(@"解析出来的str4：%@",str4);
                    
                    if ([str00 isEqualToString:@"200"]) {
                        
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [userDefaults setObject:self.nameField.text forKey:@"myname"];
                            [userDefaults setObject:self.sexPick forKey:@"mysex"];
                            [userDefaults setObject:self.phoneTextField.text forKey:@"myIdcard"];
                        });
                        
                        NSLog(@"存取的性别%@", [userDefaults stringForKey:@"mysex"]);
                        
                        //[userDefaults setObject:@"1" forKey:@"myotherrealName"];
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"成功提交实名认证信息，请等待审核结果!" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alertController addAction:action];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.deterButton.userInteractionEnabled=NO;
                            self.deterButton.backgroundColor=[UIColor lightGrayColor];
                        });
                        
                        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/rest/imgUpload/isRealName"]];
                        // 2.创建一个网络请求，分别设置请求方法、请求参数
                        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
                        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                        [parameters setValue:myuserId0 forKey:@"id"];
                        request.HTTPMethod = @"POST";
                        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                        NSString *args = [self convertToJsonData:parameters];
                        request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
                        // 3.获得会话对象
                        NSURLSession *session = [NSURLSession sharedSession];
                        // 4.根据会话对象，创建一个Task任务
                        NSLog(@"创建一个task任务");
                        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                            
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
                                    //NSString *str00=[NSString stringWithFormat:@"%@", str0];
                                    NSString *str1=[object1 objectForKey:@"desc"];
                                    NSDictionary *dict2=[object1 objectForKey:@"resultMap"];
                                    
                                    NSLog(@"解析出来 的code：%@",str0);
                                    NSLog(@"解析出来 的desc：%@",str1);
                                    NSLog(@"解析出来 的resultMap：%@",dict2);
                                    //NSLog(@"解析出来的str4：%@",str4);
                                    
                                }
                            }
                        }];
                        //5.最后一步，执行任务，(resume也是继续执行)。
                        [sessionDataTask resume];
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提交失败，请重新提交!" preferredStyle:UIAlertControllerStyleAlert];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nameField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    //[_shenfenTextField resignFirstResponder];
    //[_emailTextField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)uploadMethod
{
    NSLog(@"点击了上传证件按钮");
    UploaddocumentsViewController *ud=[[UploaddocumentsViewController alloc] init];
    [self presentViewController:ud animated:YES completion:nil];
}

-(void)backMethod
{
    NSLog(@"dianji");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_dataList objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _sexPick=_dataList[row];
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
