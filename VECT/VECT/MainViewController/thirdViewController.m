//
//  thirdViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/3.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "thirdViewController.h"
#import "phoneauthenticationViewController.h"
#import "emailauthenticationViewController.h"
#import "realNameViewController.h"
#import "passwordViewController.h"
#import "refereesViewController.h"
#import "metionmoneyViewController.h"
#import "LoginViewController.h"
#import "setterfaceViewController.h"
#import "AFNetworking.h"

//版本更新
#import "SELUpdateAlert.h"

@interface thirdViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic, assign)float h;

@property(nonatomic,strong)UIScrollView *myscrollView;
@property(nonatomic,strong)UIImageView *iv2;
@property(nonatomic,strong)UILabel *label0;
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UILabel *label2;
@property(nonatomic,strong)UILabel *label3;
@property(nonatomic,strong)UIButton *viewbutton1;
@property(nonatomic,strong)UIButton *viewbutton2;
@property(nonatomic,strong)UIButton *viewbutton3;
@property(nonatomic,strong)UILabel *myweilabel;
@property(nonatomic,strong)UILabel *myemaillabel;
@property(nonatomic,strong)UILabel *myturelabel;

//更新内容描叙
@property(nonatomic,strong)NSArray *versionupdateArray;

@end

@implementation thirdViewController

-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myrealNameString = [userDefaults stringForKey:@"myname"];
    NSString *realnamecertificationString=[userDefaults stringForKey:@"mymobile"];
    NSString *emailauthenticationString=[userDefaults stringForKey:@"myemail"];
    //NSString *myotherrealNameString=[userDefaults stringForKey:@"myotherrealName"];
    
    if (myrealNameString.length==0) {
        _label1.text=@"姓名：";
    } else {
        _label1.text=[NSString stringWithFormat:@"姓名：%@", myrealNameString];
    }
    
    if (realnamecertificationString.length!=0) {
        _viewbutton1.userInteractionEnabled=NO;
        _myweilabel.text=@"已认证";
    } else {
        _viewbutton1.userInteractionEnabled=YES;
        _myweilabel.text=@"未认证";
    }
    
    if (emailauthenticationString.length!=0) {
        _viewbutton2.userInteractionEnabled=NO;
        _myemaillabel.text=@"已认证";
    } else {
        _viewbutton2.userInteractionEnabled=YES;
        _myemaillabel.text=@"未认证";
    }
    
    if (myrealNameString.length!=0) {
        _viewbutton3.userInteractionEnabled=YES;
        _myturelabel.text=@"已认证";
    } else {
        _viewbutton3.userInteractionEnabled=YES;
        _myturelabel.text=@"未认证";
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"我想知道的高度==%f", StatusbarHeight);
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"我的";
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(addItemmmClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"set.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myphone=[userDefaults stringForKey:@"mymobile"];
    NSLog(@"我的手机号==%@", myphone);
    
    if ([myphone isEqualToString:@"13264321394"]) {
        _h=15+GZDeviceHeight/20;
        
        UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44)];
        scrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [self.view addSubview:scrollView];
        scrollView.contentSize=CGSizeMake(GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44+1+49);//内容大小
        scrollView.showsHorizontalScrollIndicator = YES;
        scrollView.showsVerticalScrollIndicator = YES;
        _myscrollView=scrollView;
        
        //做项目的时候发现UIScrollView 回弹有问题,不能回弹到原来的位置,只能到状态栏下面,在此记录下。主要是 iOS11 新增的 contentInsetAdjustmentBehavior。改成下面的就可以了
        //在iOS 11以下，控制器有automaticallyAdjustsScrollViewInsets属性，默认为YES。所以要设置成NO
        if (@available(iOS 11.0, *)) {
            _myscrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, GZDeviceHeight/5)];
        iv.image=[UIImage imageNamed:@"VECTmy.jpg"];
        [_myscrollView addSubview:iv];
        //iv.userInteractionEnabled=YES;
        
        _iv2=[[UIImageView alloc] initWithFrame:CGRectMake((GZDeviceHeight/5-GZDeviceHeight/5*3/5)/2, (GZDeviceHeight/5-GZDeviceHeight/5*3/5)/2, GZDeviceHeight/5*3/5, GZDeviceHeight/5*3/5)];
        _iv2.image=[UIImage imageNamed:@"VECTlogol.png"];
        _iv2.layer.masksToBounds=YES;
        _iv2.layer.cornerRadius=GZDeviceHeight/5*3/5/2.f;//设置为图片宽度的一半出来为圆形
        _iv2.layer.borderWidth=1.0f;//边框宽度
        _iv2.layer.borderColor=[[UIColor whiteColor] CGColor];//边框颜色
        [iv addSubview:_iv2];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *muserString=[userDefaults stringForKey:@"myuserId"];
        NSString *mphoneString=[userDefaults stringForKey:@"myPhone"];
        NSString *mcommunityString=[userDefaults stringForKey:@"mycommunity"];
        
        _label0=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceHeight/5.5-GZDeviceHeight/5*4/5+GZDeviceHeight/5*4/5, GZDeviceHeight/5/5, GZDeviceWidth/2, 20)];
        _label0.textColor=[UIColor whiteColor];
        _label0.font=[UIFont systemFontOfSize:15.f];
        if (muserString.length==0) {
            _label0.text=@"VID：";
        } else {
            _label0.text=[NSString stringWithFormat:@"VID：%@", muserString];
        }
        [iv addSubview:_label0];
        
        _label1=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceHeight/5.5-GZDeviceHeight/5*4/5+GZDeviceHeight/5*4/5, GZDeviceHeight/5/5*2, GZDeviceWidth/2, 20)];
        _label1.text=[NSString stringWithFormat:@"姓名：%@", mphoneString];
        _label1.textColor=[UIColor whiteColor];
        _label1.font=[UIFont systemFontOfSize:15.f];
        [iv addSubview:_label1];
        
        _label2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceHeight/5.5-GZDeviceHeight/5*4/5+GZDeviceHeight/5*4/5, GZDeviceHeight/5/5*3, GZDeviceWidth/2, 20)];
        _label2.text=[NSString stringWithFormat:@"账号：%@", mphoneString];
        _label2.textColor=[UIColor whiteColor];
        _label2.font=[UIFont systemFontOfSize:15.f];
        [iv addSubview:_label2];
        
        _label3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceHeight/5.5-GZDeviceHeight/5*4/5+GZDeviceHeight/5*4/5, GZDeviceHeight/5/5*4, GZDeviceWidth*3/5, 20)];
        //_label3.backgroundColor=[UIColor cyanColor];
        _label3.textColor=[UIColor whiteColor];
        _label3.font=[UIFont systemFontOfSize:10.5f];
        [iv addSubview:_label3];
        if (mcommunityString.length!=0) {
            _label3.text=[NSString stringWithFormat:@"社区服务会员：%@", mcommunityString];
        }
        
        UIView *grayView=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44+GZDeviceHeight/5, GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44-GZDeviceHeight/5)];
        grayView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [_myscrollView addSubview:grayView];
        
        _viewbutton1=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5, GZDeviceWidth, _h)];
        _viewbutton1.backgroundColor=[UIColor whiteColor];
        [_viewbutton1 addTarget:self action:@selector(vb1Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:_viewbutton1];
        UIImageView *imageV1=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/8, (15+GZDeviceHeight/20)/3, (15+GZDeviceHeight/20)/3)];
        imageV1.image=[UIImage imageNamed:@"VECTphone.png"];
        [_viewbutton1 addSubview:imageV1];
        UILabel *mylabel1=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel1.text=@"手机认证";
        mylabel1.font=[UIFont systemFontOfSize:5.0+GZDeviceHeight/60];
        [_viewbutton1 addSubview:mylabel1];
        _myweilabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/6, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        _myweilabel.text=@"未手机认证";
        _myweilabel.font=[UIFont systemFontOfSize:3.0+GZDeviceHeight/80];
        [_viewbutton1 addSubview:_myweilabel];
        UIImageView *myIv1=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv1.image=[UIImage imageNamed:@"VECTcat.png"];
        [_viewbutton1 addSubview:myIv1];
        
        _viewbutton2=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+_h+1, GZDeviceWidth, _h)];
        _viewbutton2.backgroundColor=[UIColor whiteColor];
        [_viewbutton2 addTarget:self action:@selector(vb2Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:_viewbutton2];
        UIImageView *imageV2=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/8, (15+GZDeviceHeight/20)/3, (15+GZDeviceHeight/20)/3)];
        imageV2.image=[UIImage imageNamed:@"VECTemail.png"];
        [_viewbutton2 addSubview:imageV2];
        
        UILabel *mylabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel2.text=@"邮箱认证";
        mylabel2.font=[UIFont systemFontOfSize:5.0+GZDeviceHeight/60];
        [_viewbutton2 addSubview:mylabel2];
        _myemaillabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/6, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        _myemaillabel.text=@"未邮箱认证";
        _myemaillabel.font=[UIFont systemFontOfSize:3.0+GZDeviceHeight/80];
        [_viewbutton2 addSubview:_myemaillabel];
        UIImageView *myIv2=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv2.image=[UIImage imageNamed:@"VECTcat.png"];
        [_viewbutton2 addSubview:myIv2];
        
        _viewbutton3=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+(_h+1)*2, GZDeviceWidth, _h)];
        _viewbutton3.backgroundColor=[UIColor whiteColor];
        [_viewbutton3 addTarget:self action:@selector(vb3Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:_viewbutton3];
        UIImageView *imageV3=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/8, (15+GZDeviceHeight/20)/3, (15+GZDeviceHeight/20)/3*42/43)];
        imageV3.image=[UIImage imageNamed:@"VECTshenfen.png"];
        [_viewbutton3 addSubview:imageV3];
        UILabel *mylabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel3.text=@"实名认证";
        mylabel3.font=[UIFont systemFontOfSize:5.0+GZDeviceHeight/60];
        [_viewbutton3 addSubview:mylabel3];
        _myturelabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/6, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        _myturelabel.text=@"未实名认证";
        _myturelabel.font=[UIFont systemFontOfSize:3.0+GZDeviceHeight/80];
        [_viewbutton3 addSubview:_myturelabel];
        UIImageView *myIv3=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv3.image=[UIImage imageNamed:@"VECTcat.png"];
        [_viewbutton3 addSubview:myIv3];
        
        UIButton *viewbutton4=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+(_h+1)*3+10, GZDeviceWidth, _h)];
        viewbutton4.backgroundColor=[UIColor whiteColor];
        [viewbutton4 addTarget:self action:@selector(vb4Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:viewbutton4];
        UIImageView *imageV4=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/8, (15+GZDeviceHeight/20)/3, (15+GZDeviceHeight/20)/3*42/43)];
        imageV4.image=[UIImage imageNamed:@"VECTkeyde.png"];
        [viewbutton4 addSubview:imageV4];
        UILabel *mylabel4=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel4.text=@"登录密码";
        mylabel4.font=[UIFont systemFontOfSize:5.0+GZDeviceHeight/60];
        [viewbutton4 addSubview:mylabel4];
        
        UIImageView *myIv4=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv4.image=[UIImage imageNamed:@"VECTcat.png"];
        [viewbutton4 addSubview:myIv4];
        
        UIButton *viewbutton6=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+(_h+1)*4+10, GZDeviceWidth, _h)];
        viewbutton6.backgroundColor=[UIColor whiteColor];
        [viewbutton6 addTarget:self action:@selector(vb6Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:viewbutton6];
        UIImageView *imageV6=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/8, (15+GZDeviceHeight/20)/3, (15+GZDeviceHeight/20)/3)];
        imageV6.image=[UIImage imageNamed:@"VECTbluecap.png"];
        [viewbutton6 addSubview:imageV6];
        UILabel *mylabel6=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/3, 20)];
        mylabel6.text=@"我推荐的人";
        mylabel6.font=[UIFont systemFontOfSize:5.0+GZDeviceHeight/60];
        [viewbutton6 addSubview:mylabel6];
        
        UIImageView *myIv6=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv6.image=[UIImage imageNamed:@"VECTcat.png"];
        [viewbutton6 addSubview:myIv6];
        
        UIButton *viewbutton8=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+(_h+1)*5+10, GZDeviceWidth, _h)];
        viewbutton8.backgroundColor=[UIColor whiteColor];
        [viewbutton8 addTarget:self action:@selector(vb8Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:viewbutton8];
        UIImageView *imageV8=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/8, (15+GZDeviceHeight/20)/3, (15+GZDeviceHeight/20)/3)];
        imageV8.image=[UIImage imageNamed:@"VECT-51.png"];
        [viewbutton8 addSubview:imageV8];
        UILabel *mylabel8=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel8.text=@"退出账号";
        mylabel8.font=[UIFont systemFontOfSize:5.0+GZDeviceHeight/60];
        [viewbutton8 addSubview:mylabel8];
        
        UIImageView *myIv8=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv8.image=[UIImage imageNamed:@"VECTcat.png"];
        [viewbutton8 addSubview:myIv8];
        
    } else {
        _h=15+GZDeviceHeight/20;
        
        UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44)];
        scrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [self.view addSubview:scrollView];
        scrollView.contentSize=CGSizeMake(GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44+1+49);//内容大小
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        _myscrollView=scrollView;
        
        //做项目的时候发现UIScrollView 回弹有问题,不能回弹到原来的位置,只能到状态栏下面,在此记录下。主要是 iOS11 新增的 contentInsetAdjustmentBehavior。改成下面的就可以了
        //在iOS 11以下，控制器有automaticallyAdjustsScrollViewInsets属性，默认为YES。所以要设置成NO
        if (@available(iOS 11.0, *)) {
            _myscrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, GZDeviceHeight/5)];
        iv.image=[UIImage imageNamed:@"VECTmy.jpg"];
        [_myscrollView addSubview:iv];
        //iv.userInteractionEnabled=YES;
        
        _iv2=[[UIImageView alloc] initWithFrame:CGRectMake((GZDeviceHeight/5-GZDeviceHeight/5*3/5)/2, (GZDeviceHeight/5-GZDeviceHeight/5*3/5)/2, GZDeviceHeight/5*3/5, GZDeviceHeight/5*3/5)];
        _iv2.image=[UIImage imageNamed:@"VECTlogol.png"];
        _iv2.layer.masksToBounds=YES;
        _iv2.layer.cornerRadius=GZDeviceHeight/5*3/5/2.f;//设置为图片宽度的一半出来为圆形
        _iv2.layer.borderWidth=1.0f;//边框宽度
        _iv2.layer.borderColor=[[UIColor whiteColor] CGColor];//边框颜色
        [iv addSubview:_iv2];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *muserString=[userDefaults stringForKey:@"myuserId"];
        NSString *mphoneString=[userDefaults stringForKey:@"myPhone"];
        NSString *mcommunityString=[userDefaults stringForKey:@"mycommunity"];
        
        _label0=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceHeight/5.5-GZDeviceHeight/5*4/5+GZDeviceHeight/5*4/5, GZDeviceHeight/5/5, GZDeviceWidth/2, 20)];
        _label0.textColor=[UIColor whiteColor];
        _label0.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        if (muserString.length==0) {
            _label0.text=@"VID：";
        } else {
            _label0.text=[NSString stringWithFormat:@"VID：%@", muserString];
        }
        [iv addSubview:_label0];
        
        _label1=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceHeight/5.5-GZDeviceHeight/5*4/5+GZDeviceHeight/5*4/5, GZDeviceHeight/5/5*2, GZDeviceWidth/2, 20)];
        _label1.text=[NSString stringWithFormat:@"姓名：%@", mphoneString];
        _label1.textColor=[UIColor whiteColor];
        _label1.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        [iv addSubview:_label1];
        
        _label2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceHeight/5.5-GZDeviceHeight/5*4/5+GZDeviceHeight/5*4/5, GZDeviceHeight/5/5*3, GZDeviceWidth/2, 20)];
        _label2.text=[NSString stringWithFormat:@"账号：%@", mphoneString];
        _label2.textColor=[UIColor whiteColor];
        _label2.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        [iv addSubview:_label2];
        
        _label3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceHeight/5.5-GZDeviceHeight/5*4/5+GZDeviceHeight/5*4/5, GZDeviceHeight/5/5*4, GZDeviceWidth*3/5, 20)];
        //_label3.backgroundColor=[UIColor cyanColor];
        _label3.textColor=[UIColor whiteColor];
        _label3.font=[UIFont systemFontOfSize:3.5+GZDeviceWidth/40];
        [iv addSubview:_label3];
        if (mcommunityString.length!=0) {
            _label3.text=[NSString stringWithFormat:@"社区服务会员：%@", mcommunityString];
        }
        
        UIView *grayView=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44+GZDeviceHeight/5, GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44-GZDeviceHeight/5)];
        grayView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [_myscrollView addSubview:grayView];
        
        _viewbutton1=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5, GZDeviceWidth, _h)];
        _viewbutton1.backgroundColor=[UIColor whiteColor];
        [_viewbutton1 addTarget:self action:@selector(vb1Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:_viewbutton1];
        UIImageView *imageV1=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/10, (15+GZDeviceHeight/20)/3*1.2, (15+GZDeviceHeight/20)/3*1.2)];
        imageV1.image=[UIImage imageNamed:@"VECTphone.png"];
        [_viewbutton1 addSubview:imageV1];
        UILabel *mylabel1=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel1.text=@"手机认证";
        mylabel1.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        [_viewbutton1 addSubview:mylabel1];
        _myweilabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/4.5, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        _myweilabel.text=@"未认证";
        _myweilabel.textColor=[UIColor grayColor];
        _myweilabel.font=[UIFont systemFontOfSize:3+GZDeviceWidth/35];
        [_viewbutton1 addSubview:_myweilabel];
        UIImageView *myIv1=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv1.image=[UIImage imageNamed:@"VECTcat.png"];
        [_viewbutton1 addSubview:myIv1];
        
        _viewbutton2=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+_h+1, GZDeviceWidth, _h)];
        _viewbutton2.backgroundColor=[UIColor whiteColor];
        [_viewbutton2 addTarget:self action:@selector(vb2Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:_viewbutton2];
        UIImageView *imageV2=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/10, (15+GZDeviceHeight/20)/3*1.2, (15+GZDeviceHeight/20)/3*1.2)];
        imageV2.image=[UIImage imageNamed:@"VECTemail.png"];
        [_viewbutton2 addSubview:imageV2];
        
        UILabel *mylabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel2.text=@"邮箱认证";
        mylabel2.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        [_viewbutton2 addSubview:mylabel2];
        _myemaillabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/4.5, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        _myemaillabel.text=@"未认证";
        _myemaillabel.textColor=[UIColor grayColor];
        _myemaillabel.font=[UIFont systemFontOfSize:3+GZDeviceWidth/35];
        [_viewbutton2 addSubview:_myemaillabel];
        UIImageView *myIv2=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv2.image=[UIImage imageNamed:@"VECTcat.png"];
        [_viewbutton2 addSubview:myIv2];
        
        _viewbutton3=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+(_h+1)*2, GZDeviceWidth, _h)];
        _viewbutton3.backgroundColor=[UIColor whiteColor];
        [_viewbutton3 addTarget:self action:@selector(vb3Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:_viewbutton3];
        UIImageView *imageV3=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/10, (15+GZDeviceHeight/20)/3*1.2, (15+GZDeviceHeight/20)/3*1.2*42/43)];
        imageV3.image=[UIImage imageNamed:@"VECTshenfen.png"];
        [_viewbutton3 addSubview:imageV3];
        UILabel *mylabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel3.text=@"实名认证";
        mylabel3.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        [_viewbutton3 addSubview:mylabel3];
        _myturelabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/4.5, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        _myturelabel.text=@"未认证";
        _myturelabel.textColor=[UIColor grayColor];
        _myturelabel.font=[UIFont systemFontOfSize:3+GZDeviceWidth/35];
        [_viewbutton3 addSubview:_myturelabel];
        UIImageView *myIv3=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv3.image=[UIImage imageNamed:@"VECTcat.png"];
        [_viewbutton3 addSubview:myIv3];
        
        UIButton *viewbutton4=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+(_h+1)*3+10, GZDeviceWidth, _h)];
        viewbutton4.backgroundColor=[UIColor whiteColor];
        [viewbutton4 addTarget:self action:@selector(vb4Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:viewbutton4];
        UIImageView *imageV4=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/10, (15+GZDeviceHeight/20)/3*1.2, (15+GZDeviceHeight/20)/3*1.2*42/43)];
        imageV4.image=[UIImage imageNamed:@"VECTkeyde.png"];
        [viewbutton4 addSubview:imageV4];
        UILabel *mylabel4=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel4.text=@"登录密码";
        mylabel4.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        [viewbutton4 addSubview:mylabel4];
        
        UIImageView *myIv4=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv4.image=[UIImage imageNamed:@"VECTcat.png"];
        [viewbutton4 addSubview:myIv4];
        
        
        UIButton *viewbutton5=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+(_h+1)*4+10, GZDeviceWidth, _h)];
        viewbutton5.backgroundColor=[UIColor whiteColor];
        [viewbutton5 addTarget:self action:@selector(vb5Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:viewbutton5];
        UIImageView *imageV5=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/10, (15+GZDeviceHeight/20)/3*1.2, (15+GZDeviceHeight/20)/3*1.2*42/43)];
        imageV5.image=[UIImage imageNamed:@"VECThuangsuo.png"];
        [viewbutton5 addSubview:imageV5];
        UILabel *mylabel5=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel5.text=@"提币地址";
        mylabel5.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        [viewbutton5 addSubview:mylabel5];
        
        UIImageView *myIv5=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv5.image=[UIImage imageNamed:@"VECTcat.png"];
        [viewbutton5 addSubview:myIv5];
        
        UIButton *viewbutton6=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+(_h+1)*5+10, GZDeviceWidth, _h)];
        viewbutton6.backgroundColor=[UIColor whiteColor];
        [viewbutton6 addTarget:self action:@selector(vb6Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:viewbutton6];
        UIImageView *imageV6=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/10, (15+GZDeviceHeight/20)/3*1.2, (15+GZDeviceHeight/20)/3*1.2)];
        imageV6.image=[UIImage imageNamed:@"VECTbluecap.png"];
        [viewbutton6 addSubview:imageV6];
        UILabel *mylabel6=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/3, 20)];
        mylabel6.text=@"我推荐的人";
        mylabel6.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        [viewbutton6 addSubview:mylabel6];
        
        UIImageView *myIv6=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv6.image=[UIImage imageNamed:@"VECTcat.png"];
        [viewbutton6 addSubview:myIv6];
        
        UIButton *viewbutton7=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+(_h+1)*6+10, GZDeviceWidth, _h)];
        viewbutton7.backgroundColor=[UIColor whiteColor];
        [viewbutton7 addTarget:self action:@selector(vb7Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:viewbutton7];
        UIImageView *imageV7=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/10, (15+GZDeviceHeight/20)/3*1.2, (15+GZDeviceHeight/20)/3*1.2)];
        imageV7.image=[UIImage imageNamed:@"VECT-50-1.png"];
        [viewbutton7 addSubview:imageV7];
        UILabel *mylabel7=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel7.text=@"版本更新";
        mylabel7.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        [viewbutton7 addSubview:mylabel7];
        
        UIImageView *myIv7=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv7.image=[UIImage imageNamed:@"VECTcat.png"];
        [viewbutton7 addSubview:myIv7];
        
        UIButton *viewbutton8=[[UIButton alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/5+(_h+1)*7+10, GZDeviceWidth, _h)];
        viewbutton8.backgroundColor=[UIColor whiteColor];
        [viewbutton8 addTarget:self action:@selector(vb8Method) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:viewbutton8];
        UIImageView *imageV8=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (15+GZDeviceHeight/20)*3/10, (15+GZDeviceHeight/20)/3*1.2, (15+GZDeviceHeight/20)/3*1.2)];
        imageV8.image=[UIImage imageNamed:@"VECT-51.png"];
        [viewbutton8 addSubview:imageV8];
        UILabel *mylabel8=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/8, (15+GZDeviceHeight/20-20)/2, GZDeviceWidth/4, 20)];
        mylabel8.text=@"退出账号";
        mylabel8.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        [viewbutton8 addSubview:mylabel8];
        
        UIImageView *myIv8=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2.5, (15+GZDeviceHeight/20-10)/2, (15+GZDeviceHeight/20)/6, (15+GZDeviceHeight/20)/6)];
        myIv8.image=[UIImage imageNamed:@"VECTcat.png"];
        [viewbutton8 addSubview:myIv8];
        
        //self.versionupdateArray=[[NSArray alloc] init];
        
        //self.versionupdateArray=@[@"1.修复已知bug，优化体验。",@"2.优化iPhone X的适配。",@"3增加一个设置，设置里面可以进行清除缓存操作。",@"4.增加了一个二维码扫描结果界面，可以更方便的看到扫描结果。",@"5.xxx。"];
        
        //[self versionupdatejudgment];//判断是否有新版本
    }
    
    // Do any additional setup after loading the view.
}

/*
-(void)versionupdatejudgment
{
    //2.先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    //NSLog(@"当前工程项目版本号字典=%@", infoDic);
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    //NSLog(@"当前工程项目版本号==%@", currentVersion);
    
    //3.从网络获取appStore版本号
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",@"1386674439"]]] returningResponse:nil error:nil];
    
    if (response == nil) {
        NSLog(@"你没有连接网络哦");
        return;
    }
    
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if(error) {
        NSLog(@"hsUpdateApp Error:%@",error);
        return;
    }
    
    NSArray *array = appInfoDic[@"results"];
    
    if (array.count!=0) {
        
        NSDictionary *dic = array[0];
        NSString *appStoreVersion = dic[@"version"];
        //打印版本号
        //NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion, appStoreVersion);
        //4.当前版本号小于商店版本号,就更新
        
        NSString *string1 = [[currentVersion componentsSeparatedByString:@"."] componentsJoinedByString:@""];//--分隔符
        NSString *string2 = [[appStoreVersion componentsSeparatedByString:@"."] componentsJoinedByString:@""];//--分隔符
        
        NSLog(@"当前版本号:%d\n商店版本号:%d",[string1 intValue], [string2 intValue]);
        
        if([string1 intValue] < [string2 intValue])
        {
            NSLog(@"发现最新版本");
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 处理耗时操作在此次添加
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //在主线程刷新UI
                    [SELUpdateAlert showUpdateAlertWithVersion:appStoreVersion Descriptions:self.versionupdateArray];
                });
            });
            
        } else if ([string1 intValue] == [string2 intValue]) {
            NSLog(@"已是最新版本");
            
        } else {
            NSLog(@"版本号好像比商店大噢!检测到不需要更新");
        }
    }
}
*/

-(void)vb1Method{
    
    NSLog(@"点击了手机认证");
    phoneauthenticationViewController *pa=[[phoneauthenticationViewController alloc] init];
    [self presentViewController:pa animated:YES completion:nil];
}

-(void)vb2Method{
    
    NSLog(@"点击了邮箱认证");
    emailauthenticationViewController *ea=[[emailauthenticationViewController alloc] init];
    [self presentViewController:ea animated:YES completion:nil];
    
}

-(void)vb3Method{
    
    NSLog(@"点击了实名认证");
    realNameViewController *rn=[[realNameViewController alloc] init];
    [self presentViewController:rn animated:YES completion:nil];
}

-(void)vb4Method{
    
    NSLog(@"点击了登录密码");
    passwordViewController *pwv=[[passwordViewController alloc] init];
    [self presentViewController:pwv animated:YES completion:nil];
}

-(void)vb5Method{
    
    NSLog(@"点击了提币地址");
    metionmoneyViewController *mtV=[[metionmoneyViewController alloc] init];
    [self presentViewController:mtV animated:YES completion:nil];
}

-(void)vb6Method{
    
    NSLog(@"点击了我推荐的人");
    refereesViewController *rfee=[[refereesViewController alloc] init];
    [self presentViewController:rfee animated:YES completion:nil];
}

-(void)vb7Method{
    
    NSLog(@"点击了版本更新");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否进行版本更新？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击是");
        
        //版本更新
        [self versionupdate];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击否");
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)vb8Method{
    
    NSLog(@"点击了退出账号");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你是否要退出当前账号？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击是");
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"islogin"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myPhone"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mypassword"];
        LoginViewController *login=[[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutchangeBgColor" object:nil userInfo:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击否");
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
//版本大小比较 方法调用
- (void)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second
{
    NSArray *versions1 = [first componentsSeparatedByString:@"."];
    NSArray *versions2 = [second componentsSeparatedByString:@"."];
    NSMutableArray *ver1Array = [NSMutableArray arrayWithArray:versions1];
    NSMutableArray *ver2Array = [NSMutableArray arrayWithArray:versions2];
    // 确定最大数组
    NSInteger a = (ver1Array.count> ver2Array.count)?ver1Array.count : ver2Array.count;
    // 补成相同位数数组
    if (ver1Array.count < a) {
        for(NSInteger j = ver1Array.count; j < a; j++)
        {
            [ver1Array addObject:@"0"];
        }
    }
    else
    {
        for(NSInteger j = ver2Array.count; j < a; j++)
        {
            [ver2Array addObject:@"0"];
        }
    }
    // 比较版本号
    int result = [self compareArray1:ver1Array andArray2:ver2Array];
    if(result == 1)
    {
        NSLog(@"V1 > V2");
        NSLog(@"当前版本号大于商店版本号");
    }
    else if (result == -1)
    {
        NSLog(@"V1 < V2");
        NSLog(@"当前版本号小于商店版本号，应该进行更新");
    }
    else if (result ==0 )
    {
        NSLog(@"V1 = V2");
        NSLog(@"当前版本号等于商店版本号");
    }
}

// 比较版本号
- (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2
{
    for (int i = 0; i< array2.count; i++) {
        NSInteger a = [[array1 objectAtIndex:i] integerValue];
        NSInteger b = [[array2 objectAtIndex:i] integerValue];
        if (a > b) {
            return 1;
        }
        else if (a < b)
        {
            return -1;
        }
    }
    return 0;
}
*/
 
//版本更新
-(void)versionupdate
{
    
    dispatch_async(dispatch_get_global_queue(0,0),^{//处理耗时操作在此次添加
        
        //2.先获取当前工程项目版本号
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        //NSLog(@"当前工程项目版本号字典=%@", infoDic);
        NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
        //NSLog(@"当前工程项目版本号==%@", currentVersion);
        
        //3.从网络获取appStore版本号
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",@"1386674439"]]] returningResponse:nil error:nil];
        
        //NSLog(@"the response=%@", response);
        
        if (response == nil) {
            NSLog(@"你没有连接网络哦");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*3/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
                theLabel.backgroundColor=[UIColor blackColor];
                theLabel.layer.cornerRadius = 5.f;
                theLabel.clipsToBounds = YES;
                theLabel.textColor=[UIColor whiteColor];
                theLabel.alpha=0.8f;
                theLabel.textAlignment=NSTextAlignmentCenter;
                theLabel.font=[UIFont systemFontOfSize:15.f];
                theLabel.text=@"没有网络";
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
            
            return;
        }
        
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        if(error) {
            NSLog(@"hsUpdateApp Error:%@",error);
            return;
        }
        //NSLog(@"%@",appInfoDic);
        NSArray *array = appInfoDic[@"results"];
        //NSLog(@"字典==%@   数组==%@", appInfoDic, array);
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (array.count==0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"没有找到对应的版本号" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                
                NSDictionary *dic = array[0];
                NSString *appStoreVersion = dic[@"version"];
                //打印版本号
                //NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion, appStoreVersion);
                //4.当前版本号小于商店版本号,就更新
                
                //NSLog(@"当前版本号号号%@", [currentVersion componentsSeparatedByString:@"."]);
                NSString *string1 = [[currentVersion componentsSeparatedByString:@"."] componentsJoinedByString:@""];//--分隔符
                NSString *string2 = [[appStoreVersion componentsSeparatedByString:@"."] componentsJoinedByString:@""];//--分隔符
                NSLog(@"整数str1==%d", [string1 intValue]);
                NSLog(@"整数str2==%d", [string2 intValue]);
                
                if([string1 intValue] < [string2 intValue])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@)，是否前往App Store进行更新?",appStoreVersion] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
                    alert.tag=100;
                    [alert show];
                } else if ([string1 intValue] == [string2 intValue]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*0.55)/2, GZDeviceHeight*3/5, GZDeviceWidth*0.55, 20+GZDeviceHeight/25)];
                        theLabel.backgroundColor=[UIColor blackColor];
                        theLabel.layer.cornerRadius = 5.f;
                        theLabel.clipsToBounds = YES;
                        theLabel.textColor=[UIColor whiteColor];
                        theLabel.alpha=0.8f;
                        theLabel.textAlignment=NSTextAlignmentCenter;
                        theLabel.font=[UIFont systemFontOfSize:15.f];
                        theLabel.text=@"已是最新版本，无需更新";
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
                    NSLog(@"版本号好像比商店大噢!检测到不需要更新");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                        theLabel.backgroundColor=[UIColor blackColor];
                        theLabel.layer.cornerRadius = 5.f;
                        theLabel.clipsToBounds = YES;
                        theLabel.textColor=[UIColor whiteColor];
                        theLabel.alpha=0.8f;
                        theLabel.textAlignment=NSTextAlignmentCenter;
                        theLabel.font=[UIFont systemFontOfSize:15.f];
                        theLabel.text=@"检测到不需要更新";
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
            
            //在主线程刷新UI
            
        });
        
    });
    
    
    
    /*
    //2.先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSLog(@"当前工程项目版本号字典=%@", infoDic);
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    NSLog(@"当前工程项目版本号==%@", currentVersion);
    
    //3.从网络获取appStore版本号
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",@"1386674439"]]] returningResponse:nil error:nil];
    
    NSLog(@"the response=%@", response);
    
    if (response == nil) {
        NSLog(@"你没有连接网络哦");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*3/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
            theLabel.backgroundColor=[UIColor blackColor];
            theLabel.layer.cornerRadius = 5.f;
            theLabel.clipsToBounds = YES;
            theLabel.textColor=[UIColor whiteColor];
            theLabel.alpha=0.8f;
            theLabel.textAlignment=NSTextAlignmentCenter;
            theLabel.font=[UIFont systemFontOfSize:15.f];
            theLabel.text=@"没有网络";
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
        
        return;
    }
    
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if(error) {
        NSLog(@"hsUpdateApp Error:%@",error);
        return;
    }
    //    NSLog(@"%@",appInfoDic);
    NSArray *array = appInfoDic[@"results"];
    //NSLog(@"字典==%@   数组==%@", appInfoDic, array);
    
    if (array.count==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"没有找到对应的版本号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
    
        NSDictionary *dic = array[0];
        NSString *appStoreVersion = dic[@"version"];
        //打印版本号
        //NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion, appStoreVersion);
        //4.当前版本号小于商店版本号,就更新
        
        //NSLog(@"当前版本号号号%@", [currentVersion componentsSeparatedByString:@"."]);
        NSString *string1 = [[currentVersion componentsSeparatedByString:@"."] componentsJoinedByString:@""];//--分隔符
        NSString *string2 = [[appStoreVersion componentsSeparatedByString:@"."] componentsJoinedByString:@""];//--分隔符
        NSLog(@"整数str1==%d", [string1 intValue]);
        NSLog(@"整数str2==%d", [string2 intValue]);
        
        if([string1 intValue] < [string2 intValue])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@)，是否前往App Store进行更新?",appStoreVersion] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
            alert.tag=100;
            [alert show];
        } else if ([string1 intValue] == [string2 intValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*0.55)/2, GZDeviceHeight*3/5, GZDeviceWidth*0.55, 20+GZDeviceHeight/25)];
                theLabel.backgroundColor=[UIColor blackColor];
                theLabel.layer.cornerRadius = 5.f;
                theLabel.clipsToBounds = YES;
                theLabel.textColor=[UIColor whiteColor];
                theLabel.alpha=0.8f;
                theLabel.textAlignment=NSTextAlignmentCenter;
                theLabel.font=[UIFont systemFontOfSize:15.f];
                theLabel.text=@"已是最新版本，无需更新";
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
        } else {
            NSLog(@"版本号好像比商店大噢!检测到不需要更新");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                theLabel.backgroundColor=[UIColor blackColor];
                theLabel.layer.cornerRadius = 5.f;
                theLabel.clipsToBounds = YES;
                theLabel.textColor=[UIColor whiteColor];
                theLabel.alpha=0.8f;
                theLabel.textAlignment=NSTextAlignmentCenter;
                theLabel.font=[UIFont systemFontOfSize:15.f];
                theLabel.text=@"检测到不需要更新";
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
    */
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        //5.实现跳转到应用商店进行更新
        if(buttonIndex==1)
        {
            //6.此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", @"1386674439"]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

-(void)addItemmmClick
{
    setterfaceViewController *sf=[[setterfaceViewController alloc] init];
    [self presentViewController:sf animated:YES completion:nil];
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
