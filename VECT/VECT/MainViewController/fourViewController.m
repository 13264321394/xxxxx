//
//  fourViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/30.
//  Copyright © 2018年 方墨. All rights reserved.
//

//iOS中使用UISegmentControl进行UITableView切换

#import "fourViewController.h"
#import "informationdetailViewController.h"
#import "LoginViewController.h"
#import "MJRefresh.h"

@interface fourViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *leftTable;
@property(nonatomic, strong)UITableView *rightTable;
//数据源1
@property (nonatomic, strong) NSMutableArray *dataSource1;
//数据源2
@property (nonatomic, strong) NSMutableArray *dataSource2;
@property (nonatomic, assign) int page1;//页数
@property (nonatomic, assign) int total1;//通过数据请求获取到每次加载得到数组的总数量
@property (nonatomic, assign) int page2;//页数
@property (nonatomic, assign) int total2;//通过数据请求获取到每次加载得到数组的总数量
@property (nonatomic, copy) NSString *webStr;
@property(nonatomic, assign)int tag;//记录点到segment的哪一段
@property(nonatomic, assign)int mycount;

@end

@implementation fourViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;//隐藏导航栏
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mycount=0;
    
    self.dataSource1 = [[NSMutableArray alloc] init];//这个地方记着alloc
    self.dataSource2 = [[NSMutableArray alloc] init];//这个地方记着alloc
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, StatusbarHeight+44)];
    view1.backgroundColor=[UIColor colorWithRed:237/255.0 green:59/255.0 blue:87/255.0 alpha:1.0f];
    //view1.backgroundColor=[UIColor colorWithRed:250 / 255.0 green:97 / 215.0 blue:0 / 255.0 alpha:1];
    [self.view addSubview:view1];
    
    //创建导航栏分栏控件.分段控制器
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"公告",@"资讯",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake((GZDeviceWidth-GZDeviceWidth*3/5)/2, StatusbarHeight+(44-32)/2, GZDeviceWidth*3/5, 32);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:252/255.0 green:245/255.0 blue:248/255.0 alpha:1.0f];
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [view1 addSubview:segmentedControl];
    
    UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, 10)];
    view2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view2];
    
    self.leftTable = [[UITableView alloc] init];
    if (StatusbarHeight==44) {
        self.leftTable = [[UITableView alloc] initWithFrame:CGRectMake(0,StatusbarHeight+44+10,GZDeviceWidth,GZDeviceHeight-(StatusbarHeight+44+10+88)) style:UITableViewStylePlain];
    } else {
        self.leftTable = [[UITableView alloc] initWithFrame:CGRectMake(0,StatusbarHeight+44+10,GZDeviceWidth,GZDeviceHeight-(StatusbarHeight+44+10+49)) style:UITableViewStylePlain];
    }
    
    self.leftTable.delegate = self;
    self.leftTable.dataSource = self;
    [self.view addSubview:self.leftTable];
    self.leftTable.tableFooterView = [[UIView alloc] init];
    
    self.page1=1;
    self.page2=1;
    
    self.rightTable = [[UITableView alloc] init];
    if (StatusbarHeight==44) {
        self.rightTable = [[UITableView alloc] initWithFrame:CGRectMake(0,StatusbarHeight+44+10,GZDeviceWidth,GZDeviceHeight-(StatusbarHeight+44+10+88)) style:UITableViewStylePlain];
    } else {
        self.rightTable = [[UITableView alloc] initWithFrame:CGRectMake(0,StatusbarHeight+44+10,GZDeviceWidth,GZDeviceHeight-(StatusbarHeight+44+10+49)) style:UITableViewStylePlain];
    }
    
    self.rightTable.delegate = self;
    self.rightTable.dataSource = self;
    [self.view addSubview:self.rightTable];
    self.rightTable.tableFooterView = [[UIView alloc] init];
    
    
    // Do any additional setup after loading the view.
}

//leftTable下拉刷新
-(void)loadNewData1
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *myuserId5=[userDefaults stringForKey:@"myuserId"];
        NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
        
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/noticePages"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10.0];//超过这个时间就算超时，请求失败
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:mytoken forKey:@"token"];
        [parameters setValue:[NSString stringWithFormat:@"%d", self.page1] forKey:@"page"];
        [parameters setValue:@"10" forKey:@"rows"];
        [parameters setValue:myuserId5 forKey:@"userId"];
        [parameters setValue:@"0" forKey:@"typeId"];
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
                    
                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
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
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                        [theLabel removeFromSuperview];
                        
                    });//这句话的意思是1.5秒后，把label移出视图
                    
                    [self.leftTable.mj_header endRefreshing];
                    //[self.leftTable removeFromSuperview];
                });
            } else {
                // 如果请求成功，则解析数据。
                //NSLog(@"返回的response信息%@",response);
                id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];//解析出返回的数据，如果是字典可以用字典接受
                // 11、判断是否解析成功
                if (error) {
                    NSLog(@"post error :%@",error.localizedDescription);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
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
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            [theLabel removeFromSuperview];
                            
                        });//这句话的意思是1.5秒后，把label移出视图
                        [self.leftTable.mj_header endRefreshing];
                        //[self.leftTable removeFromSuperview];
                    });
                } else {
                    // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                    
                    NSLog(@"post success啊 :%@",object1);
                    NSString *str0=[object1 objectForKey:@"code"];
                    NSString *str00=[NSString stringWithFormat:@"%@", str0];
                    NSString *str1=[object1 objectForKey:@"desc"];
                    NSDictionary *dic2=[object1 objectForKey:@"resultMap"];
                    NSLog(@"公告字典中解析出来的code:%@",str0);
                    NSLog(@"公告字典中解析出来的desc:%@",str1);
                    NSLog(@"公告字典中解析出来的resultMap:%@",dic2);
                    
                    NSString *thetotal=[NSString stringWithFormat:@"%@", [dic2 objectForKey:@"total"]];
                    self.total1 = [thetotal intValue];
                    
                    if ([str00 isEqualToString:@"200"]) {
                        
                        NSMutableArray *mtArr=[[dic2 objectForKey:@"pageInfo"] objectForKey:@"rows"];
                        [self.dataSource1 removeAllObjects];//每次下拉刷新前先移除掉所有的数据
                        for (id obj in mtArr) {
                            
                            [self.dataSource1 addObject:obj];
                        }
                        
                        if (self.dataSource1.count<1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.leftTable.mj_header endRefreshing];
                                // [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                self.leftTable.mj_footer.hidden = YES;
                                //记得提示没有数据
                                //[self.leftTable removeFromSuperview];
                            });
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
                                theLabel.backgroundColor=[UIColor blackColor];
                                theLabel.layer.cornerRadius = 5.f;
                                theLabel.clipsToBounds = YES;
                                theLabel.textColor=[UIColor whiteColor];
                                theLabel.alpha=0.8f;
                                theLabel.textAlignment=NSTextAlignmentCenter;
                                theLabel.font=[UIFont systemFontOfSize:15.f];
                                theLabel.text=@"未查询到数据";
                                [self.view addSubview:theLabel];
                                
                                //设置动画
                                CATransition *transion=[CATransition animation];
                                transion.type=@"push";//动画方式
                                transion.subtype=@"fromRight";//设置动画从哪个方向开始
                                [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                                //不占用主线程
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                    [theLabel removeFromSuperview];
                                    
                                });//这句话的意思是1.5秒后，把label移出视图
                                [self.leftTable.mj_header endRefreshing];
                            });
                            [self.leftTable.mj_header endRefreshing];
                        } else {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
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
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                    
                                    [theLabel removeFromSuperview];
                                    
                                });//这句话的意思是1.5秒后，把label移出视图
                                if (self.dataSource1.count<10) {
                                    [self.leftTable.mj_header endRefreshing];
                                    //self.tableView.mj_footer.hidden = YES;
                                    self.leftTable.mj_footer.state=MJRefreshStateNoMoreData;
                                } else {
                                    [self.leftTable.mj_header endRefreshing];
                                    self.leftTable.mj_footer.hidden = NO;
                                    self.leftTable.mj_footer.state=MJRefreshStateIdle;
                                }
                                [self.leftTable reloadData];
                                [self.leftTable.mj_header endRefreshing];
                            });
                        }
                        [self.leftTable.mj_header endRefreshing];
                        NSLog(@"我要的数组数据元素aaaaaaaaaaaaaaaaaaaaaaaaaaa==%@",self.dataSource1);
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
                            [self.leftTable.mj_header endRefreshing];
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
                            [self.leftTable.mj_header endRefreshing];
                            //[self.tableView reloadData];
                        });
                        
                    }
                }
            }
        }];
        
        //5.最后一步，执行任务，启动请求(resume也是继续执行)。
        [sessionDataTask resume];
    });
}

//rightTable下拉刷新
-(void)loadNewData2
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *myuserId5=[userDefaults stringForKey:@"myuserId"];
        NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
        
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/noticePages"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10.0];//超过这个时间就算超时，请求失败
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:mytoken forKey:@"token"];
        [parameters setValue:[NSString stringWithFormat:@"%d", self.page2] forKey:@"page"];
        [parameters setValue:@"10" forKey:@"rows"];
        [parameters setValue:myuserId5 forKey:@"userId"];
        [parameters setValue:@"1" forKey:@"typeId"];
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
                    
                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
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
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                        [theLabel removeFromSuperview];
                        
                    });//这句话的意思是1.5秒后，把label移出视图
                    
                    [self.rightTable.mj_header endRefreshing];
                    //[self.rightTable removeFromSuperview];
                });
            }else {
                // 如果请求成功，则解析数据。
                //NSLog(@"返回的response信息%@",response);
                id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];//解析出返回的数据，如果是字典可以用字典接受
                // 11、判断是否解析成功
                if (error) {
                    NSLog(@"post error :%@",error.localizedDescription);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
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
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            [theLabel removeFromSuperview];
                            
                        });//这句话的意思是1.5秒后，把label移出视图
                        [self.rightTable.mj_header endRefreshing];
                        [self.rightTable removeFromSuperview];
                    });
                }else {
                    // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                    
                    NSLog(@"post success啊 :%@",object1);
                    NSString *str0=[object1 objectForKey:@"code"];
                    NSString *str00=[NSString stringWithFormat:@"%@", str0];
                    NSString *str1=[object1 objectForKey:@"desc"];
                    NSDictionary *dic2=[object1 objectForKey:@"resultMap"];
                    NSLog(@"公告字典中解析出来的code:%@",str0);
                    NSLog(@"公告字典中解析出来的desc:%@",str1);
                    NSLog(@"公告字典中解析出来的resultMap:%@",dic2);
                    
                    NSString *thetotal=[NSString stringWithFormat:@"%@", [dic2 objectForKey:@"total"]];
                    self.total2 = [thetotal intValue];
                    
                    if ([str00 isEqualToString:@"200"]) {
                        
                        NSMutableArray *mtArr=[[dic2 objectForKey:@"pageInfo"] objectForKey:@"rows"];
                        [self.dataSource2 removeAllObjects];//每次下拉刷新前先移除掉所有的数据
                        for (id obj in mtArr) {
                            
                            [self.dataSource2 addObject:obj];
                        }
                        
                        if (self.dataSource2.count<1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.rightTable.mj_header endRefreshing];
                                // [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                self.rightTable.mj_footer.hidden = YES;
                                //记得提示没有数据
                                //[self.rightTable removeFromSuperview];
                            });
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
                                theLabel.backgroundColor=[UIColor blackColor];
                                theLabel.layer.cornerRadius = 5.f;
                                theLabel.clipsToBounds = YES;
                                theLabel.textColor=[UIColor whiteColor];
                                theLabel.alpha=0.8f;
                                theLabel.textAlignment=NSTextAlignmentCenter;
                                theLabel.font=[UIFont systemFontOfSize:15.f];
                                theLabel.text=@"未查询到数据";
                                [self.view addSubview:theLabel];
                                
                                //设置动画
                                CATransition *transion=[CATransition animation];
                                transion.type=@"push";//动画方式
                                transion.subtype=@"fromRight";//设置动画从哪个方向开始
                                [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                                //不占用主线程
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                    [theLabel removeFromSuperview];
                                    
                                });//这句话的意思是1.5秒后，把label移出视图
                                [self.rightTable.mj_header endRefreshing];
                            });
                        } else {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
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
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                    [theLabel removeFromSuperview];
                                    
                                });//这句话的意思是1.5秒后，把label移出视图
                                if (self.dataSource2.count<10) {
                                    
                                    [self.rightTable.mj_header endRefreshing];
                                    //self.tableView.mj_footer.hidden = YES;
                                    self.rightTable.mj_footer.state=MJRefreshStateNoMoreData;
                                } else {
                                    [self.rightTable.mj_header endRefreshing];
                                    self.rightTable.mj_footer.hidden = NO;
                                    self.rightTable.mj_footer.state=MJRefreshStateIdle;
                                }
                                [self.rightTable reloadData];
                                [self.rightTable.mj_header endRefreshing];
                            });
                        }
                        [self.rightTable.mj_header endRefreshing];
                        NSLog(@"我要的数组数据元素aaaaaaaaaaaaaaaaaaaaaaaaaaa==%@",self.dataSource2);
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
                            [self.rightTable.mj_header endRefreshing];
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
                            [self.rightTable.mj_header endRefreshing];
                            //[self.tableView reloadData];
                        });
                        
                    }
                }
            }
        }];
        
        //5.最后一步，执行任务，启动请求(resume也是继续执行)。
        [sessionDataTask resume];
    });
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

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    //我定义了一个 NSInteger tag，是为了记录我当前选择的是分段控件的左边还是右边。
    NSInteger selecIndex = sender.selectedSegmentIndex;
    NSLog(@"分段控制器的第%lu段", selecIndex);
    switch(selecIndex){
        case 0:
            self.leftTable.hidden = NO;
            self.rightTable.hidden = YES;
            sender.selectedSegmentIndex=0;
            self.tag = 0;
            [self leftdropdownrefresh];//leftTable下拉刷新
            //[self.leftTable.mj_header endRefreshing];//下拉刷新完成后停止下拉刷新
            //[self leftpullonloading];//leftTable上拉加载
            [self.leftTable reloadData];
            break;
            
        case 1:
            self.leftTable.hidden = YES;
            self.rightTable.hidden = NO;
            sender.selectedSegmentIndex = 1;
            self.tag=1;
            [self rightdropdownrefresh];
            //[self.rightTable.mj_header endRefreshing];//下拉刷新完成后停止下拉刷新
            [self rightpullonloading];//rightTable上拉加载
            [self.rightTable reloadData];
            break;
            
        default:
            break;
    }
}

//左边table下拉刷新
-(void)leftdropdownrefresh
{
    //leftTable下拉刷新
    self.leftTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        self.page1 = 1;
        [self loadNewData1];
    }];
    [self.leftTable.mj_header beginRefreshing];
}

//右边table下拉刷新
-(void)rightdropdownrefresh
{
    //rightTable下拉刷新
    self.rightTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        self.page2 = 1;
        [self loadNewData2];
    }];
    [self.rightTable.mj_header beginRefreshing];
}

//右边table上拉加载
-(void)rightpullonloading
{
    //上拉加载
    self.rightTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //页码
        self.page2++;
        [self getMoveDataSource2];
    }];
}

//rightTable上拉加载
-(void)getMoveDataSource2
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *myuserId5=[userDefaults stringForKey:@"myuserId"];
        NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
        
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/intoDetails"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:mytoken forKey:@"token"];
        [parameters setValue:[NSString stringWithFormat:@"%d", self.page2] forKey:@"page"];
        [parameters setValue:@"10" forKey:@"rows"];
        [parameters setValue:myuserId5 forKey:@"userId"];
        [parameters setValue:@"1" forKey:@"typeId"];
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
                    
                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
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
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                        [theLabel removeFromSuperview];
                        
                    });//这句话的意思是1.5秒后，把label移出视图
                    [self.rightTable.mj_footer endRefreshing];
                });
            }else {
                // 如果请求成功，则解析数据。
                //NSLog(@"返回的response信息%@",response);
                id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];//解析出返回的数据，如果是字典可以用字典接受
                // 11、判断是否解析成功
                if (error) {
                    NSLog(@"post error :%@",error.localizedDescription);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
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
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            [theLabel removeFromSuperview];
                            
                        });//这句话的意思是1.5秒后，把label移出视图
                        [self.rightTable.mj_footer endRefreshing];
                        //[self.rightTable removeFromSuperview];
                    });
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
                        
                        NSMutableArray *mtArr=[dic2 objectForKey:@"data"];
                        
                        for (id obj in mtArr) {
                            
                            [self.dataSource2 addObject:obj];
                        }
                        
                        if (self.dataSource2.count<1) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.rightTable.mj_footer endRefreshing];
                                self.rightTable.mj_footer.hidden = YES;
                                //记得提示没有数据
                                [self.rightTable removeFromSuperview];
                            });
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未查询到记录" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            [alertController addAction:action];
                            [self presentViewController:alertController animated:YES completion:nil];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*2.3/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
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
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                    [theLabel removeFromSuperview];
                                    
                                });//这句话的意思是1.5秒后，把label移出视图
                                
                                if (self.dataSource2.count<self.total2) {
                                    self.rightTable.mj_footer.hidden = NO;
                                    self.rightTable.mj_footer.state=MJRefreshStateIdle;
                                    //[self.tableView.mj_footer beginRefreshing];
                                    
                                } else {
                                    //[self.tableView.mj_footer endRefreshing];
                                    //self.tableView.mj_footer.hidden = YES;
                                self.rightTable.mj_footer.state=MJRefreshStateNoMoreData;
                                }
                                [self.rightTable reloadData];
                                
                            });
                        }
                        
                        NSLog(@"个数%lu  上拉加载我要的数组数据元素aaaaaaaaaaaaaaaaaaaaaaaaaaa==%@", self.dataSource2.count,self.dataSource2);
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
                            [self.rightTable.mj_footer endRefreshing];
                            //[self.tableView reloadData];
                        });
                        
                    }
                }
            }
        }];
        //5.最后一步，执行任务，启动请求(resume也是继续执行)。
        [sessionDataTask resume];
    });
}

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.tag==0) {
        return self.dataSource1.count;
    } else if (self.tag==1) {
        return self.dataSource2.count;
    }
    
    return 0;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30+GZDeviceHeight/16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.tag == 0){
        
        static NSString *cellIdentifier =@"cell";
        //从复用池中取cell
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            //cell.backgroundColor = [UIColor clearColor];
            
        }
        //cell.textLabel.text=[self.dataSource1[indexPath.row] objectForKey:@"title"];
        cell.textLabel.text=@"VECT你好";
        cell.textLabel.font=[UIFont systemFontOfSize:16.f];
        cell.detailTextLabel.text=[self.dataSource1[indexPath.row] objectForKey:@"createTime"];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:13.f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击cell时，cell的颜色不改变
        
        return cell;
    } else if (self.tag == 1) {
        static NSString *cellIdentifier =@"cell";
        //从复用池中取cell
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text=[self.dataSource2[indexPath.row] objectForKey:@"title"];
        cell.textLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        cell.detailTextLabel.text=[self.dataSource2[indexPath.row] objectForKey:@"createTime"];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:4+GZDeviceWidth/35];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击cell时，cell的颜色不改变
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//解决点击cell时延时的问题
    
    if (self.tag==0) {
        self.leftTable.hidden = NO;
        self.rightTable.hidden = YES;
        self.tag = 0;
        
    } else if (self.tag==1) {
        self.leftTable.hidden = YES;
        self.rightTable.hidden = NO;
        self.tag = 1;
        informationdetailViewController *ifmd=[[informationdetailViewController alloc] init];
        ifmd.str1=[NSString stringWithFormat:@"%@", [self.dataSource2[indexPath.row] objectForKey:@"ntro"]];
        [self presentViewController:ifmd animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    
    ++self.mycount;
    
    NSLog(@"mycount的值=%d", self.mycount);
    
    if (self.mycount==1) {
        
        [super viewWillAppear:animated];
        NSLog(@"视图出现前的tag值%d", self.tag);
        if (self.tag==0) {
            
            self.leftTable.hidden = NO;
            self.rightTable.hidden = YES;
            self.tag = 0;
            [self leftdropdownrefresh];
            [self.leftTable reloadData];
            //self.automaticallyAdjustsScrollViewInsets = NO;
        } else if (self.tag==1) {
            
            self.leftTable.hidden = YES;
            self.rightTable.hidden = NO;
            self.tag = 1;
            [self rightdropdownrefresh];
            [self.rightTable reloadData];
            //self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
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
