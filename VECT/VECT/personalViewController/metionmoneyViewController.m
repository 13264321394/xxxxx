//
//  metionmoneyViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/9.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "metionmoneyViewController.h"
#import "newaddressViewController.h"
#import "metionmoneyTableViewCell.h"
#import "LoginViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"

// 定义static变量
static NSString *const ID = @"cell";

@interface metionmoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
//table引用
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation metionmoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UILabel *realnameLabel=[[UILabel alloc] init];
    realnameLabel.text=@"提币地址";
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
    
    UIButton *addbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth-GZDeviceWidth/50-50, StatusbarHeight+7, 50, 30)];
    [addbutton setTitle:@"添加" forState:UIControlStateNormal];
    addbutton.titleLabel.font=[UIFont systemFontOfSize:4+GZDeviceWidth/35];
    [addbutton setTitleColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [addbutton addTarget:self action:@selector(addMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addbutton];
    
    UIView *theview=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, 10)];
    theview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:theview];
    
    self.dataSource = [[NSMutableArray alloc] init];//这个地方记着alloc
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,StatusbarHeight+44+10,GZDeviceWidth,GZDeviceHeight-StatusbarHeight-44-10) style:UITableViewStylePlain];
    if (StatusbarHeight==44) {
        self.tableView.frame=CGRectMake(0, StatusbarHeight+44+10, GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44-10-34);
    } else {
       self.tableView.frame=CGRectMake(0, StatusbarHeight+44+10, GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44-10);
    }
    
    //最重要的就是代理了
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    //[self.tableView setEditing:YES animated:YES];//开启表格的编辑模式
    [self.tableView setEditing:NO animated:YES];//取消编辑状态。可以取消cell左边的那个红色减号按钮
    self.tableView.tableFooterView = [[UIView alloc] init];  
    
    //[self getDataFromWeb];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        [self loadNewData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView reloadData];
    
    
    // Do any additional setup after loading the view.
}

//下拉刷新
-(void)loadNewData
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
                    [self.dataSource removeAllObjects];//每次下拉刷新前先移除掉所有的数据
                    
                    for (id obj in mtArr) {
                        
                        [self.dataSource addObject:obj];
                    }
                    
                    if (self.dataSource.count<1) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView.mj_header endRefreshing];
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
                            [self.tableView.mj_header endRefreshing];
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
                        [self.tableView reloadData];
                    });
                    
                }
            }
        }
    }];
    
    //5.最后一步，执行任务，启动请求(resume也是继续执行)。
    [sessionDataTask resume];
}

//设置行是否可以编辑。 UITableViewDataSource协议中定义的方法。该方法的返回值决定某行是否可编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//若不实现此方法，则默认为删除模式。
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //表示支持默认操作
    //return UITableViewCellEditingStyleNone;
    //表示支持新增操作
    //return UITableViewCellEditingStyleInsert;
    //表示支持删除操作
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

//进行删除操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/delAddr"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *idstring=[userDefaults stringForKey:@"myuserId"];
    NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
    
    [parameters setValue:mytoken forKey:@"token"];
    [parameters setValue:idstring forKey:@"userId"];
    [parameters setValue:[NSString stringWithFormat:@"%@", [self.dataSource[indexPath.row] objectForKey:@"id"]] forKey:@"userWithdrawAddrId"];
    
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
                //NSString *str0=[object1 objectForKey:@"code"];
                //NSString *str00=[NSString stringWithFormat:@"%@", str0];
                //NSString *str1=[object1 objectForKey:@"desc"];
                //NSDictionary *dict2=[object1 objectForKey:@"resultMap"];
                //NSLog(@"解析出来的code：%@",str0);
                //NSLog(@"解析出来的desc：%@",str1);
                //NSLog(@"解析出来的resultMap：%@",dict2);
            }
        }
    }];
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
    
    // 删除数组中的对应数据,注意cityList 要是可变的集合才能够进行删除或新增操作
    [self.dataSource removeObjectAtIndex:indexPath.row];
    //tableView刷新方式   设置tableView带动画效果 删除数据
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
    //取消编辑状态
    [tableView setEditing:NO animated:YES];
    
}

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

//cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier =@"cell";
    //从复用池中取cell
    metionmoneyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[metionmoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //cell.backgroundColor = [UIColor colorWithRed:27/255.0 green:130/255.0 blue:207/255.0 alpha:1.0];
    }
    
    if (self.dataSource.count>0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.labelAddress.text=[NSString stringWithFormat:@"%@", [self.dataSource[indexPath.row] objectForKey:@"label"]];
            cell.labelAddress.textColor=[UIColor whiteColor];
            cell.labelAddress.lineBreakMode= NSLineBreakByTruncatingMiddle;//一行内容太长时中间以省略号形式
            cell.labelAddress.font=[UIFont systemFontOfSize:21.5f];
            
            cell.labelTime.text=[NSString stringWithFormat:@"添加时间：%@", [NSString stringWithFormat:@"%@", [self.dataSource[indexPath.row] objectForKey:@"crateTime"]]];
            cell.labelTime.textColor=[UIColor whiteColor];
            cell.labelTime.lineBreakMode= NSLineBreakByTruncatingMiddle;//一行内容太长时中间以省略号形式
            cell.labelTime.font=[UIFont systemFontOfSize:16.f];
            
            cell.labelNextAddress.text=[NSString stringWithFormat:@"%@", [self.dataSource[indexPath.row] objectForKey:@"walletAddr"]];
            cell.labelNextAddress.textColor=[UIColor whiteColor];
            cell.labelNextAddress.lineBreakMode= NSLineBreakByTruncatingMiddle;//一行内容太长时中间以省略号形式
            cell.labelNextAddress.font=[UIFont systemFontOfSize:16.f];
            
        });
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击cell时，cell的颜色不改变
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏分割线
    
    
    return cell;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0+GZDeviceHeight/12;
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
*/

/*
-(void)getDataFromWeb
{
    
    UIActivityIndicatorView *tableFooterActivityIndicator =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //tableFooterActivityIndicator.center=CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
    tableFooterActivityIndicator.center=self.view.center;//把菊花设在屏幕正中心
    tableFooterActivityIndicator.color=[UIColor lightGrayColor];
    [self.view addSubview:tableFooterActivityIndicator];
    [tableFooterActivityIndicator startAnimating];
    
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableFooterActivityIndicator stopAnimating];
            [tableFooterActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        });
        
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                    [theLabel removeFromSuperview];
                    
                });//这句话的意思是1.5秒后，把label移出视图
            });
        }else {
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
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                        [theLabel removeFromSuperview];
                        
                    });//这句话的意思是1.5秒后，把label移出视图
                    
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
                        
                        [self.dataSource addObject:obj];
                    }
                    
                    if (self.dataSource.count<1) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
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
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
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
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            [theLabel removeFromSuperview];
                            
                            //[NSThread sleepForTimeInterval:1.4f];//设置启动图片持续的时间长短
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"islogin"];
                            LoginViewController *login=[[LoginViewController alloc] init];
                            [self presentViewController:login animated:YES completion:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBgColor" object:nil userInfo:nil];
                            
                        });//这句话的意思是1.5秒后，把label移出视图
                    });

                } else {
                    
                }
            }
        }
    }];
    
    //5.最后一步，执行任务，启动请求(resume也是继续执行)。
    [sessionDataTask resume];
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

-(void)addMethod
{
    NSLog(@"点击了添加按钮");
    
    newaddressViewController *nd=[[newaddressViewController alloc] init];
    [self presentViewController:nd animated:YES completion:nil];
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
