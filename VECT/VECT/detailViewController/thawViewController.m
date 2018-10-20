//
//  thawViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/9.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "thawViewController.h"
#import "morethawdetailViewController.h"
#import "LoginViewController.h"
#import "thedetailTableViewCell.h"
#import "Masonry.h"
#import "MJRefresh.h"

@interface thawViewController ()<UITableViewDataSource,UITableViewDelegate>

/**数据源*/
@property(nonatomic,strong) NSMutableArray *dataSource;
/**table引用*/
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int total;

@end

@implementation thawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.dataSource = [[NSMutableArray alloc] init];//这个地方记着alloc
    
    UILabel *forgetPawLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-80)/2, StatusbarHeight, 80, 30)];
    forgetPawLabel.text=@"解冻明细";
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
    
    UIView *theview=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, 10)];
    theview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:theview];
    
    self.tableView=[[UITableView alloc] init];
    if (StatusbarHeight==44) {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,StatusbarHeight+44+10,GZDeviceWidth,GZDeviceHeight-StatusbarHeight-44-10-34) style:UITableViewStylePlain];
    } else {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,StatusbarHeight+44+10,GZDeviceWidth,GZDeviceHeight-StatusbarHeight-44-10) style:UITableViewStylePlain];
    }
    
    //最重要的就是代理了
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];  
    
    self.page=1;
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        self.page = 1;
        [self loadNewData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上拉加载
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //页码
        self.page++;
        [self getMoveDataSource];
    }];
    
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

//上拉加载
-(void)getMoveDataSource
{
    //UIActivityIndicatorView *tableFooterActivityIndicator =
    //[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //tableFooterActivityIndicator.center=CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
    //tableFooterActivityIndicator.center=self.view.center;//把菊花设在屏幕正中心
    //tableFooterActivityIndicator.color=[UIColor lightGrayColor];
    //[self.view addSubview:tableFooterActivityIndicator];
    //[tableFooterActivityIndicator startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *myuserId8=[userDefaults stringForKey:@"myuserId"];
        NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
        
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/showUnfreeze"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10.0];//超过这个时间就算超时，请求失败
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:mytoken forKey:@"token"];
        [parameters setValue:[NSString stringWithFormat:@"%d", self.page] forKey:@"page"];
        [parameters setValue:@"10" forKey:@"PageSize"];
        [parameters setValue:@"id" forKey:@"Sort"];
        [parameters setValue:@"desc" forKey:@"Order"];
        [parameters setValue:myuserId8 forKey:@"userId"];
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
                    theLabel.text=@"请您先连接网络";
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
                    [self.tableView.mj_footer endRefreshing];
                });
            } else {
                // 如果请求成功，则解析数据。
                //NSLog(@"返回的response信息%@",response);
                id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];//解析出返回的数据，如果是字典可以用字典接受
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
                        [self.tableView.mj_footer endRefreshing];
                        [self.tableView removeFromSuperview];
                    });
                } else {
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
                        
                        NSMutableArray *mtArr=[dic2 objectForKey:@"data"];
                        
                        for (id obj in mtArr) {
                            
                            [self.dataSource addObject:obj];
                        }
                        
                        if (self.dataSource.count<1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tableView.mj_footer endRefreshing];
                                self.tableView.mj_footer.hidden = YES;
                                //记得提示没有数据
                                [self.tableView removeFromSuperview];
                            });
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未查询到记录" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            [alertController addAction:action];
                            [self presentViewController:alertController animated:YES completion:nil];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
                                theLabel.backgroundColor=[UIColor blackColor];
                                theLabel.layer.cornerRadius = 5.f;
                                theLabel.clipsToBounds = YES;
                                theLabel.textColor=[UIColor whiteColor];
                                theLabel.alpha=0.8f;
                                theLabel.textAlignment=NSTextAlignmentCenter;
                                theLabel.font=[UIFont systemFontOfSize:15.f];
                                theLabel.text=@"查询成功!";
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
                                
                                if (self.dataSource.count<self.total) {
                                    self.tableView.mj_footer.hidden = NO;
                                    self.tableView.mj_footer.state=MJRefreshStateIdle;
                                    //[self.tableView.mj_footer beginRefreshing];
                                    
                                } else {
                                    //[self.tableView.mj_footer endRefreshing];
                                    //self.tableView.mj_footer.hidden = YES;
                                    self.tableView.mj_footer.state=MJRefreshStateNoMoreData;
                                }
                                [self.tableView reloadData];
                            });
                        }
                        
                        NSLog(@"我要的数组数据元素aaaaaaaaaaaaaaaaaaaaaaaaaaa==%@",self.dataSource);
                    } else if ([str00 isEqualToString:@"23"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*3/5)/2, GZDeviceHeight*3.5/5, GZDeviceWidth*3/5, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"缓存已过期，请重新登录";
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromRight";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                [theLabel removeFromSuperview];
                                
                                //[NSThread sleepForTimeInterval:1.4f];//设置启动图片持续的时间长短
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"islogin"];
                                LoginViewController *login=[[LoginViewController alloc] init];
                                [self presentViewController:login animated:YES completion:nil];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBgColor" object:nil userInfo:nil];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                            [self.tableView.mj_footer endRefreshing];
                        });
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
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
                            [self.tableView.mj_footer endRefreshing];
                            //[self.tableView reloadData];
                        });
                        
                    }
                }
            }
        }];
        //5.最后一步，执行任务，启动请求(resume也是继续执行)。
        [sessionDataTask resume];
        //[tableFooterActivityIndicator stopAnimating];
        //[tableFooterActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    });
}

//下拉刷新
-(void)loadNewData
{
    //UIActivityIndicatorView *tableFooterActivityIndicator =
    //[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //tableFooterActivityIndicator.center=CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
    //tableFooterActivityIndicator.center=self.view.center;//把菊花设在屏幕正中心
    //tableFooterActivityIndicator.color=[UIColor lightGrayColor];
    //[self.view addSubview:tableFooterActivityIndicator];
    //[tableFooterActivityIndicator startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *myuserId8=[userDefaults stringForKey:@"myuserId"];
        NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
        
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/showUnfreeze"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10.0];//超过这个时间就算超时，请求失败
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:mytoken forKey:@"token"];
        [parameters setValue:[NSString stringWithFormat:@"%d", self.page] forKey:@"page"];
        [parameters setValue:@"10" forKey:@"PageSize"];
        [parameters setValue:@"id" forKey:@"Sort"];
        [parameters setValue:@"desc" forKey:@"Order"];
        [parameters setValue:myuserId8 forKey:@"userId"];
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
                    theLabel.text=@"请您先连接网络";
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
                    [self.tableView.mj_header endRefreshing];
                });
            } else {
                // 如果请求成功，则解析数据。
                //NSLog(@"返回的response信息%@",response);
                id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];//解析出返回的数据，如果是字典可以用字典接受
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
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView removeFromSuperview];
                    });
                } else {
                    // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                    
                    NSLog(@"post success啊 :%@",object1);
                    NSString *str0=[object1 objectForKey:@"code"];
                    NSString *str00=[NSString stringWithFormat:@"%@", str0];
                    NSString *str1=[object1 objectForKey:@"desc"];
                    NSDictionary *dic2=[object1 objectForKey:@"resultMap"];
                    NSLog(@"字典中解析出来的code:%@",str0);
                    NSLog(@"字典中解析出来的desc:%@",str1);
                    NSLog(@"字典中解析出来的resultMap:%@",dic2);
                    
                    NSString *thetotal=[NSString stringWithFormat:@"%@", [dic2 objectForKey:@"total"]];
                    self.total = [thetotal intValue];
                    
                    if ([str00 isEqualToString:@"0"]) {
                        
                        NSMutableArray *mtArr=[dic2 objectForKey:@"data"];
                        [self.dataSource removeAllObjects];
                        for (id obj in mtArr) {
                            
                            [self.dataSource addObject:obj];
                        }
                        
                        if (self.dataSource.count<1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tableView.mj_header endRefreshing];
                                self.tableView.mj_footer.hidden = YES;
                                //记得提示没有数据
                                [self.tableView removeFromSuperview];
                            });
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未查询到记录" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            [alertController addAction:action];
                            [self presentViewController:alertController animated:YES completion:nil];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
                                theLabel.backgroundColor=[UIColor blackColor];
                                theLabel.layer.cornerRadius = 5.f;
                                theLabel.clipsToBounds = YES;
                                theLabel.textColor=[UIColor whiteColor];
                                theLabel.alpha=0.8f;
                                theLabel.textAlignment=NSTextAlignmentCenter;
                                theLabel.font=[UIFont systemFontOfSize:15.f];
                                theLabel.text=@"查询成功!";
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
                                
                                if (self.dataSource.count<10) {
                                    //self.tableView.mj_footer.hidden = YES;
                                    self.tableView.mj_footer.state=MJRefreshStateNoMoreData;
                                } else {
                                    self.tableView.mj_footer.hidden = NO;
                                    self.tableView.mj_footer.state=MJRefreshStateIdle;
                                }
                                [self.tableView reloadData];
                                [self.tableView.mj_header endRefreshing];
                            });
                        }
                        
                        NSLog(@"我要的数组数据元素aaaaaaaaaaaaaaaaaaaaaaaaaaa==%@",self.dataSource);
                    } else if ([str00 isEqualToString:@"23"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*3/5)/2, GZDeviceHeight*3.5/5, GZDeviceWidth*3/5, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"缓存已过期，请重新登录";
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromRight";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                [theLabel removeFromSuperview];
                                
                                //[NSThread sleepForTimeInterval:1.4f];//设置启动图片持续的时间长短
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"islogin"];
                                LoginViewController *login=[[LoginViewController alloc] init];
                                [self presentViewController:login animated:YES completion:nil];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBgColor" object:nil userInfo:nil];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                            [self.tableView.mj_header endRefreshing];
                        });
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
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
                            [self.tableView.mj_header endRefreshing];
                            //[self.tableView reloadData];
                        });
                        
                    }
                }
            }
        }];
        //5.最后一步，执行任务，启动请求(resume也是继续执行)。
        [sessionDataTask resume];
        //[tableFooterActivityIndicator stopAnimating];
        //[tableFooterActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    });
}

//cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier =@"cell";
    //从复用池中取cell
    thedetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[thedetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        cell.iconImageView.image=[UIImage imageNamed:@"VECTthaw.png"];
        
        
        float floatstr1=[[self.dataSource[indexPath.row] objectForKey:@"tUnfreezeNumber"] floatValue];
        cell.label1.text=[NSString stringWithFormat:@"解冻金额:%.2f",
                             floatstr1];
        cell.label1.font=[UIFont systemFontOfSize:3.5+GZDeviceWidth/35];
        cell.label1.textColor = [UIColor blackColor];
        
        cell.label2.text=[self.dataSource[indexPath.row] objectForKey:@"detail"];
        cell.label2.font=[UIFont systemFontOfSize:5+GZDeviceWidth/35];
        cell.label2.textColor=[UIColor grayColor];
        
        float floatstr=[[self.dataSource[indexPath.row] objectForKey:@"tUserConsume"] floatValue];
        cell.label3.text=[NSString stringWithFormat:@"-%.3f", floatstr];
        cell.label3.font=[UIFont systemFontOfSize:5+GZDeviceWidth/35];
        cell.label3.textColor=[UIColor grayColor];
        
        /*
        float floatstr1=[[self.dataSource[indexPath.row] objectForKey:@"tUnfreezeNumber"] floatValue];
        cell.textLabel.text=[NSString stringWithFormat:@"解冻金额:%f",
                             floatstr1];
        cell.textLabel.font=[UIFont systemFontOfSize:15.f];
        
        float floatstr=[[self.dataSource[indexPath.row] objectForKey:@"tUserConsume"] floatValue];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@                                              -%f", [self.dataSource[indexPath.row] objectForKey:@"detail"], floatstr];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:13.f];
        cell.detailTextLabel.textColor=[UIColor darkGrayColor];
        */
         
        /*
        UILabel *label = [[UILabel alloc] init]; //定义一个在cell最右边显示的label
        float floatstr2=[[self.dataSource[indexPath.row] objectForKey:@"tUserConsume"] floatValue];
        NSString *str=[NSString stringWithFormat:@"-%f", floatstr2];
        label.text = str;
        label.textColor=[UIColor lightGrayColor];
        label.font = [UIFont boldSystemFontOfSize:14.f];
        [label sizeToFit];
        label.backgroundColor = [UIColor clearColor];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            label.frame =CGRectMake(GZDeviceWidth-label.frame.size.width - 10,(70-label.frame.size.height)/2, label.frame.size.width, label.frame.size.height);
        } else {
            label.frame =CGRectMake(GZDeviceWidth- label.frame.size.width - 20, 12, label.frame.size.width, label.frame.size.height);
        }
        [cell.contentView addSubview:label];
        */
        
        //cell.imageView.image=[UIImage imageNamed:@"VECTthaw.png"];
        
    });
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击cell时，cell的颜色不改变
    
    return cell;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//解决点击cell时延时的问题
    
    morethawdetailViewController *mdv=[[morethawdetailViewController alloc] init];
    mdv.str1=[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"tUnfreezeNumber"];
    mdv.str2=[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"tUnfreezeNumber"];
    mdv.str3=[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"tUserConsume"];
    mdv.str4=[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"tUserDate"];
    [self presentViewController:mdv animated:YES completion:nil];
}

/*
-(void)getDataFromWeb
{
    
    
}
*/

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
    NSLog(@"点击了返回按钮");
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
