//
//  secondViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/3.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "secondViewController.h"
#import "Masonry.h"
#import "WCQRCodeScanningVC.h"
#import "brmonViewController.h"
#import "VECTViewController.h"
#import "secondTableViewCell.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "LCProgressHUD.h"

#import <MapKit/MapKit.h>
#import "locationGPS.h"
#import "Myanotation.h"
#import "LocationManager.h"

#import <CoreImage/CoreImage.h>

@interface secondViewController ()<MKMapViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain)NSArray *dataList;
@property(nonatomic,strong)UITableView *myTableView;
@property (strong, nonatomic)MKMapView *mapView;
@property (strong, nonatomic)UILabel *addressLabel;
@property (strong, nonatomic)UILabel *longitudeLabel;//经度
@property (strong, nonatomic)UILabel *latitudeLabel;//纬度
@property (strong, nonatomic)UILabel *distanceLabel;

@property(nonatomic,strong)UIScrollView *myscrollView;
@property(nonatomic,assign)double para;
@property(nonatomic,assign)int inpara;
@property(nonatomic,assign)float numtotal;
@property(nonatomic,copy)NSString *totalassetsStr;
@property (strong, nonatomic)UILabel *numtotalassLabel;

@end

@implementation secondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"资产";
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"scanning.png"]style:UIBarButtonItemStylePlain target:self action:@selector(refreshDataClick)];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"扫一扫" style:UIBarButtonItemStylePlain target:self action:@selector(refreshDataClick)];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myphone=[userDefaults stringForKey:@"mymobile"];
    NSLog(@"我的手机号==%@", myphone);
    
    if ([myphone isEqualToString:@"13264321394"]) {
        if (StatusbarHeight==44) {
            self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44+49+37))];
        } else {
            self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44+49))];
        }
        
        self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44+49))];
        self.mapView.mapType =  MKMapTypeStandard;
        //显示指南针
        self.mapView.showsCompass = YES;
        //显示比例尺
        self.mapView.showsScale = YES;
        //显示用户所在的位置
        self.mapView.showsUserLocation = YES;
        
        self.mapView.delegate =self;
        
        [self.view addSubview:self.mapView];
        
        locationGPS *loc = [locationGPS sharedlocationGPS];
        [loc getAuthorization];//授权
        [loc startLocation];//开始定位
        
        //跟踪用户位置
        self.mapView.userTrackingMode = MKUserTrackingModeFollow;
        //地图类型
        //    self.mapView.mapType = MKMapTypeSatellite;
        self.mapView.delegate = self;
        
        UIImageView *myimageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, GZDeviceHeight-(StatusbarHeight+44+49)-GZDeviceWidth/8*2, GZDeviceWidth/8, GZDeviceWidth/8)];
        myimageView.image=[UIImage imageNamed:@"btn_map_locate_hl.png"];
        [self.view addSubview:myimageView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [myimageView addGestureRecognizer:tapGesture];
        myimageView.userInteractionEnabled = YES;
        
        UIView *myView=[[UIView alloc] init];
        if (StatusbarHeight==44) {
            myView.frame=CGRectMake(0, GZDeviceHeight-(StatusbarHeight+44+49)-GZDeviceWidth/8*2+GZDeviceWidth/8, GZDeviceWidth, GZDeviceHeight-(GZDeviceHeight-(StatusbarHeight+44+49)-GZDeviceWidth/8*2+GZDeviceWidth/8)-49);
            
            self.addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, GZDeviceWidth*3/4, 30)];
            [myView addSubview:self.addressLabel];
            
            self.longitudeLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, (GZDeviceHeight-(GZDeviceHeight-(StatusbarHeight+44+49)-GZDeviceWidth/8*2+GZDeviceWidth/8)-49-37)/3, GZDeviceWidth*5/6, 30)];
            self.longitudeLabel.font=[UIFont systemFontOfSize:15.f];
            [myView addSubview:self.longitudeLabel];
            
            self.distanceLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, (GZDeviceHeight-(GZDeviceHeight-(StatusbarHeight+44+49)-GZDeviceWidth/8*2+GZDeviceWidth/8)-49-37)*2/3, GZDeviceWidth*2/3, 30)];
            [myView addSubview:self.distanceLabel];
        } else {
            myView.frame=CGRectMake(0, GZDeviceHeight-(StatusbarHeight+44+49)-GZDeviceWidth/8*2+GZDeviceWidth/8, GZDeviceWidth, GZDeviceHeight-(GZDeviceHeight-(StatusbarHeight+44+49)-GZDeviceWidth/8*2+GZDeviceWidth/8)-49);
            
            self.addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, GZDeviceWidth*3/4, 30)];
            [myView addSubview:self.addressLabel];
            
            self.longitudeLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, (GZDeviceHeight-(GZDeviceHeight-(StatusbarHeight+44+49)-GZDeviceWidth/8*2+GZDeviceWidth/8)-49)/3, GZDeviceWidth*5/6, 30)];
            self.longitudeLabel.font=[UIFont systemFontOfSize:15.f];
            [myView addSubview:self.longitudeLabel];
            
            self.distanceLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, (GZDeviceHeight-(GZDeviceHeight-(StatusbarHeight+44+49)-GZDeviceWidth/8*2+GZDeviceWidth/8)-49)*2/3, GZDeviceWidth*2/3, 30)];
            [myView addSubview:self.distanceLabel];
        }
        myView.backgroundColor=[UIColor whiteColor];
        myView.alpha=0.8f;
        [self.view addSubview:myView];
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self.mapView addGestureRecognizer:tapGesturRecognizer];
        
    } else {
        
        //[self getrequest];//获取到price
        
        _myscrollView=[[UIScrollView alloc] init];
        
        if (@available(iOS 11.0, *)) {
            _myscrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        if (StatusbarHeight==44) {
            _myscrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44-49-34)];
        } else {
            _myscrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44)];
        }
        
        _myscrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [self.view addSubview:_myscrollView];
        _myscrollView.showsHorizontalScrollIndicator = YES;
        _myscrollView.showsVerticalScrollIndicator = YES;
        _myscrollView.delegate=self;
        
        //下拉刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //刷新时候，需要执行的代码。一般是请求最新数据，请求成功之后，刷新列表
            [self loadNewData];
        }];
        _myscrollView.mj_header=header;
        // 设置文字
        [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即刷新~" forState:MJRefreshStatePulling];
        [header setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
        
        // 设置字体
        header.stateLabel.font = [UIFont systemFontOfSize:3+GZDeviceWidth/35];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:2+GZDeviceWidth/35];
        // 设置颜色
        //header.stateLabel.textColor = [UIColor redColor];
        //header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
        // 马上进入刷新状态
        
        [header beginRefreshing];
        
        UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, GZDeviceHeight/4)];
        iv.image=[UIImage imageNamed:@"VECTpfs.png"];
        [_myscrollView addSubview:iv];
        iv.userInteractionEnabled=YES;
        
        /*
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, GZDeviceHeight/4)];
        //view1.backgroundColor=[UIColor colorWithRed:42 green:131 blue:209 alpha:1.0];
        view1.backgroundColor=[UIColor colorWithRed:19/255.0 green:163/255.0 blue:242/255.0 alpha:1.0];
        [_myscrollView addSubview:view1];
        */
         
        UILabel *totalassetsLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/4*2/5, GZDeviceWidth, 35)];
        totalassetsLabel.text=@"总资产";
        totalassetsLabel.textColor=[UIColor whiteColor];
        totalassetsLabel.font=[UIFont systemFontOfSize:8+GZDeviceWidth/28];
        totalassetsLabel.textAlignment=NSTextAlignmentCenter;
        [iv addSubview:totalassetsLabel];
        
        UILabel *numtotalassLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,  GZDeviceHeight/4*2/3, GZDeviceWidth, 35)];
        numtotalassLabel.textColor=[UIColor whiteColor];
        numtotalassLabel.text=@" ¥ 000000.000000";
        numtotalassLabel.font=[UIFont systemFontOfSize:8+GZDeviceWidth/30];
        numtotalassLabel.textAlignment=NSTextAlignmentCenter;
        [iv addSubview:numtotalassLabel];
        self.numtotalassLabel=numtotalassLabel;
        
        NSArray *list = [NSArray arrayWithObjects:@"VECT", nil];
        self.dataList = list;
        
        NSLog(@"数组%@datalist",self.dataList);
        
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/4, GZDeviceWidth, GZDeviceHeight) style:UITableViewStylePlain];
        tableView.pagingEnabled=YES;
        tableView.showsVerticalScrollIndicator=NO;
        tableView.bounces=YES;
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        tableView.dataSource = self;
        tableView.delegate = self;
        self.myTableView = tableView;
        [_myscrollView addSubview:_myTableView];
        [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(GZDeviceHeight/4);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, self.dataList.count*(30+GZDeviceHeight/17)));
        }];
        
        self.myTableView.tableFooterView = [[UIView alloc] init];//去掉没有内容的cell
        
        // 新API：`@available(iOS 11.0, *)` 可用来判断系统版本
        if ( @available(iOS 11.0, *) ) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    // Do any additional setup after loading the view.
}

//获取到price
-(void)getrequest
{
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"https://open.ucoins.cc/api/v1/ticker/VECT_UT"];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //4.根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSLog(@"get请求到的===%@",dict);
            NSString *tsr=[dict objectForKey:@"price"];
            
            NSLog(@"price价格%@",tsr);
            
            self.para=[tsr doubleValue];
            
            double doupara=self.para*1000000;
            NSString *doustr=[NSString stringWithFormat:@"%f", doupara];
            self.inpara=[doustr intValue];
            
            NSLog(@"我要的整数阿==%d", self.inpara);
            
            if (self.inpara==0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*0.52)/2, GZDeviceHeight*3.5/5, GZDeviceWidth*0.52, 20+GZDeviceHeight/25)];
                    theLabel.backgroundColor=[UIColor blackColor];
                    theLabel.layer.cornerRadius = 5.f;
                    theLabel.clipsToBounds = YES;
                    theLabel.textColor=[UIColor whiteColor];
                    theLabel.alpha=0.8f;
                    theLabel.textAlignment=NSTextAlignmentCenter;
                    theLabel.font=[UIFont systemFontOfSize:15.f];
                    theLabel.text=@"未获取到VECT_UT价格";
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
                });
            }
        }
    }];
    
    //5.执行任务
    [dataTask resume];
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

//请求获取最新的数据
- (void)loadNewData {
    NSLog(@"请求获取最新的数据");
    
    UIView *myview=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44))];
    myview.backgroundColor=[UIColor blackColor];
    myview.alpha=0.1;
    [self.view addSubview:myview];
    
    [LCProgressHUD showLoading:@"正在加载..."];
    self.view.userInteractionEnabled=NO;
    
    //这里假设2秒之后获取到了最新的数据，刷新tableview，并且结束刷新控件的刷新状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //刷新列表0ii
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self getrequest];//获取到price
            
            //请求用户资产信息
            [self Assetinformation];
            //请求奖励计划
            //[self Incentiveplan];
            //二维码地址
            //[self codeaddress];
        });
        
        [LCProgressHUD hide];
        [myview removeFromSuperview];
        self.view.userInteractionEnabled=YES;
        [self.myscrollView.mj_header endRefreshing];
    });
    [_myscrollView.mj_header beginRefreshing];
}

//请求用户资产信息
-(void)Assetinformation
{
    //写入数据请求
    //NSLog(@"BBBBBBBBBBBBBBBBBB用户资产信息");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myuserId4=[userDefaults stringForKey:@"myuserId"];
    NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
    
    NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/tWallet"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:myuserId4 forKey:@"userId"];
    [parameters setValue:mytoken forKey:@"token"];
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
                    
                    NSString *strr1=[[dic2 objectForKey:@"data"] objectForKey:@"currencyNumbe"];
                    NSString *strr2=[[dic2 objectForKey:@"data"] objectForKey:@"frozenNumber"];
                    NSString *strr3=[[dic2 objectForKey:@"data"] objectForKey:@"currencAvaBal"];
                    NSString *strr4=[[dic2 objectForKey:@"data"] objectForKey:@"fuelNum"];
                    
                    NSString *strr51=[[dic2 objectForKey:@"data"] objectForKey:@"unfreezeEarnings"];
                    //NSString *strr52=[[dic2 objectForKey:@"data"] objectForKey:@"newNumber"];
                    NSString *strr53=[[dic2 objectForKey:@"data"] objectForKey:@"angelEarnings"];
                    
                    float flstr1=[strr1 floatValue];
                    float flstr2=[strr2 floatValue];
                    float flstr3=[strr3 floatValue];
                    float flstr4=[strr4 floatValue];
                    
                    float flstr51=[strr51 floatValue];
                    //float flstr52=[strr52 floatValue];
                    float flstr53=[strr53 floatValue];
                    float flstr6=flstr1+flstr3+flstr51+flstr2+flstr4+flstr53;
                    
                    
                    self.numtotal=flstr6;
                    float numtotal=flstr6*self.para;
                    
                    NSLog(@"总量=%f  价格=%f", flstr6, self.para);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.numtotalassLabel.text=[NSString stringWithFormat:@" ¥ %f", numtotal];
                        
                        self.totalassetsStr=[NSString stringWithFormat:@"%f", numtotal];
                        
                        [self.myTableView reloadData];
                        
                        self.numtotalassLabel.text=[NSString stringWithFormat:@" ¥ %f", numtotal];
                        
                        if (self.inpara!=0) {
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:15.f];
                            theLabel.text=@"刷新成功";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏分割线
    
    static NSString *CellWithIdentifier = @"Cell";
    secondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
    if (cell == nil) {
        cell = [[secondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    
    if (indexPath.row==0) {
        cell.imageView.image=[UIImage imageNamed:@"VECTlogol3.png"];
        
        cell.labelName.text=[self.dataList objectAtIndex:indexPath.row];;
        cell.labelName.font=[UIFont systemFontOfSize:21.f];
        
        cell.labelAssets.text=[NSString stringWithFormat:@"%.3f", self.numtotal];
        cell.labelAssets.textColor=[UIColor darkGrayColor];
        cell.labelAssets.font=[UIFont systemFontOfSize:18.f];
    }
    
    //cell.textLabel.highlightedTextColor=[UIColor redColor];//点击cell后cell上字体变的颜色
    cell.backgroundColor=[UIColor colorWithRed:255/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏分割线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击cell时，cell的颜色不改变
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30+GZDeviceHeight/17;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//解决点击cell时延时的问题
    
    //NSLog(@"行%ld", (long)indexPath.row);
    
    if (indexPath.row==0) {
        VECTViewController *vc=[[VECTViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }

}


/**
 * 当用户位置更新，就会调用
 *
 * userLocation 表示地图上面那可蓝色的大头针的数据
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    userLocation.title = [NSString stringWithFormat:@"经度：%f",center.longitude];
    userLocation.subtitle = [NSString stringWithFormat:@"纬度：%f",center.latitude];
    
    NSLog(@"定位：纬度%f 经度%f --- %i",center.latitude,center.longitude,mapView.showsUserLocation);
    
    if (mapView.showsUserLocation) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //监听MapView点击
            NSLog(@"添加监听");
            [mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        });
    }
    
    
    //设置地图的中心点，（以用户所在的位置为中心点）
    //    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //设置地图的显示范围
    //    MKCoordinateSpan span = MKCoordinateSpanMake(0.023666, 0.016093);
    //    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    //    [mapView setRegion:region animated:YES];
    
}

//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    //获取跨度
//    NSLog(@"%f  %f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //如果是定位的大头针就不用自定义
    if (![annotation isKindOfClass:[Myanotation class]]) {
        return nil;
    }
    
    static NSString *ID = @"anno";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
    }
    
    Myanotation *anno = annotation;
    annoView.image = [UIImage imageNamed:@"map_locate_blue"];
    annoView.annotation = anno;
    
    return annoView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView--%@",view);
}

-(void)clickImage
{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:tap.view];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    NSLog(@"%@",self.mapView.annotations);
    NSMutableArray *array = [NSMutableArray array];
    NSUInteger count = self.mapView.annotations.count;
    if (count > 1) {
        for (id obj in self.mapView.annotations) {
            if (![obj isKindOfClass:[MKUserLocation class]]) {
                [array addObject:obj];
            }
        }
        [self.mapView removeAnnotations:array];
    }
    
    if (self.mapView.annotations.count>0) {
        MKUserLocation *locationAnno = self.mapView.annotations[0];
        
        Myanotation *anno = [[Myanotation alloc] init];
        
        anno.coordinate = coordinate;
        anno.title = [NSString stringWithFormat:@"经度：%f",coordinate.longitude];
        anno.subtitle = [NSString stringWithFormat:@"纬度：%f",coordinate.latitude];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.longitudeLabel.text = [NSString stringWithFormat:@"纬度:%f   经度:%f",coordinate.latitude,coordinate.longitude];
        });
        
        //self.latitudeLabel.text = [NSString stringWithFormat:@"纬度：%f",coordinate.latitude];
        //反地理编码
        LocationManager *locManager = [[LocationManager alloc] init];
        [locManager reverseGeocodeWithlatitude:coordinate.latitude longitude:coordinate.longitude success:^(NSString *address) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.addressLabel.text = [NSString stringWithFormat:@"%@",address];
            });
            
            NSLog(@"地理位置为%@", address);
            
        } failure:^{
            NSLog(@"地理定位失败");
        }];
        
        //距离
        double distance = [locManager countLineDistanceDest:coordinate.longitude dest_Lat:coordinate.latitude self_Lon:locationAnno.coordinate.longitude self_Lat:locationAnno.coordinate.latitude];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.distanceLabel.text = [NSString stringWithFormat:@"距您%d米",(int)distance];
        });
        
        NSLog(@"距您%d米", (int)distance);
        
        [self.mapView addAnnotation:anno];
        [self.mapView setCenterCoordinate:coordinate animated:YES];
    }
}

-(void)refreshDataClick
{
    WCQRCodeScanningVC *wr=[[WCQRCodeScanningVC alloc] init];
    [self presentViewController:wr animated:YES completion:nil];
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 static NSString *CellWithIdentifier = @"Cell";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
 }
 cell.tag=indexPath.row;
 NSUInteger row = [indexPath row];
 _myTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
 UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VECT-28.png"]];
 cell.accessoryView = imageView;
 
 if (indexPath.row==0) {
 cell.imageView.image=[UIImage imageNamed:@"VECTinput.png"];
 } else if (indexPath.row==1) {
 cell.imageView.image=[UIImage imageNamed:@"VECToutput.png"];
 } else if (indexPath.row==2) {
 cell.imageView.image=[UIImage imageNamed:@"VECTregular.png"];
 } else if (indexPath.row==3) {
 cell.imageView.image=[UIImage imageNamed:@"VECTearnings.png"];
 } else if (indexPath.row==4) {
 cell.imageView.image=[UIImage imageNamed:@"VECTthaw.png"];
 } else if (indexPath.row==5) {
 cell.imageView.image=[UIImage imageNamed:@"VECT-53.png"];
 }
 
 cell.textLabel.text = [self.dataList objectAtIndex:row];
 //cell.selectionStyle = UITableViewCellSelectionStyleNone;
 //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 //cell.imageView.image = [UIImage imageNamed:@"green.png"];
 //cell.textLabel.adjustsFontSizeToFitWidth=NO;//cell字体自动适应大小
 //cell.textLabel.font=[UIFont systemFontOfSize:20.0f];//改变cell上字体大小
 //cell.textLabel.highlightedTextColor=[UIColor redColor];//点击cell后cell上字体变的颜色
 
 return cell;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 
 return _dataList.count;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 return 30+GZDeviceHeight/30;
 
 }
 
 //点击单元格触发该方法
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (indexPath.row==0) {
 intodetailViewController *idv=[[intodetailViewController alloc] init];
 [self presentViewController:idv animated:YES completion:nil];
 } else if (indexPath.row==1) {
 rolloutdetailViewController *rdv=[[rolloutdetailViewController alloc] init];
 [self presentViewController:rdv animated:YES completion:nil];
 
 } else if (indexPath.row==2) {
 regularViewController *rv=[[regularViewController alloc] init];
 [self presentViewController:rv animated:YES completion:nil];
 
 } else if (indexPath.row==3) {
 
 returnsViewController *rtv=[[returnsViewController alloc] init];
 [self presentViewController:rtv animated:YES completion:nil];
 
 } else if (indexPath.row==4) {
 
 thawViewController *tv=[[thawViewController alloc] init];
 [self presentViewController:tv animated:YES completion:nil];
 } else if (indexPath.row==5) {
 communitymemberViewController *cv=[[communitymemberViewController alloc] init];
 [self presentViewController:cv animated:YES completion:nil];
 }
 
 //[tableView deselectRowAtIndexPath:indexPath animated:YES];
 //点击推出页面
 //DetailViewController *rvc = [[DetailViewController alloc] init];
 //[self.navigationController pushViewController:rvc animated:YES];
 
 }
 */

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

