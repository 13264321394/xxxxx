//
//  VECTViewController.m
//  VECT
//
//  Created by 方墨 on 2018/7/6.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "VECTViewController.h"
#import "Masonry.h"
#import "WCQRCodeScanningVC.h"
#import "brmonViewController.h"
#import "chargemoneyViewController.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "LCProgressHUD.h"

@interface VECTViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *myscrollView;
@property(nonatomic,strong)UIImageView *iv1;
@property(nonatomic,strong)UIImageView *iv2;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic, strong)UIButton *inputbutton;
@property(nonatomic, strong)UIButton *unlockbutton;
@property(nonatomic, copy)NSString *codeAddress;//二维码地址
@property(nonatomic, copy)NSString *codeStr;
@property(nonatomic,strong)UIView *Qrcodeview;
@property(nonatomic,strong)UILabel *joinLabel;
@property(nonatomic,strong)UILabel *label23;
@property(nonatomic,strong)UILabel *label25;
@property(nonatomic,strong)UILabel *label26;
@property(nonatomic,strong)UILabel *label2;
@property(nonatomic,strong)UILabel *label3;
@property(nonatomic,strong)UILabel *label5;
@property(nonatomic,strong)UILabel *label6;
@property(nonatomic,strong)UILabel *label8;
@property(nonatomic,strong)UILabel *label9;
@property(nonatomic,strong)UILabel *label11;
@property(nonatomic,strong)UILabel *label12;
@property(nonatomic,strong)UILabel *label14;
@property(nonatomic,strong)UILabel *label15;
@property(nonatomic,strong)UILabel *label17;
@property(nonatomic,strong)UILabel *label18;
@property(nonatomic,strong)UILabel *label19;
@property(nonatomic,strong)UILabel *label20;
@property(nonatomic,strong)UILabel *label21;
@property(nonatomic,strong)UILabel *label22;
@property(nonatomic,strong)UILabel *label27;
@property(nonatomic,strong)UILabel *label28;
@property(nonatomic,strong)UILabel *label29;
@property(nonatomic,strong)UILabel *label30;
@property(nonatomic,strong)UILabel *labelangel;//天使收益
@property(nonatomic,strong)UILabel *labelangelconversion;//天使收益转换后
@property(nonatomic,strong)UILabel *codeAdlabel;//二维码地址
@property(nonatomic,strong)UIImageView *QrcodeImageView;//二维码图片
@property(nonatomic,assign)double para;
@property(nonatomic,assign)int inpara;

@end

@implementation VECTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *realnameLabel=[[UILabel alloc] init];
    realnameLabel.text=@"VECT";
    realnameLabel.textAlignment = NSTextAlignmentCenter;
    realnameLabel.font=[UIFont systemFontOfSize:8+GZDeviceWidth/35];
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
    
    
    UIButton *chargemoneybutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/30, GZDeviceHeight-(22.0+GZDeviceHeight/27), GZDeviceWidth/2-GZDeviceWidth/30, 22.0+GZDeviceHeight/27)];
    [chargemoneybutton setTitle:@"充币" forState:UIControlStateNormal];
    chargemoneybutton.titleLabel.font=[UIFont systemFontOfSize:8.5+GZDeviceWidth/32];
    chargemoneybutton.backgroundColor=[UIColor colorWithRed:90/255.0 green:194/255.0 blue:49/255.0 alpha:1.0];
    [chargemoneybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chargemoneybutton addTarget:self action:@selector(chargemoneyMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chargemoneybutton];
    
    UIButton *mentionmoneybutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/2, GZDeviceHeight-(22.0+GZDeviceHeight/27), GZDeviceWidth/2-GZDeviceWidth/30, 22.0+GZDeviceHeight/27)];
    [mentionmoneybutton setTitle:@"提币" forState:UIControlStateNormal];
    mentionmoneybutton.titleLabel.font=[UIFont systemFontOfSize:8.5+GZDeviceWidth/32];
    mentionmoneybutton.backgroundColor=[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    [mentionmoneybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mentionmoneybutton addTarget:self action:@selector(mentionmoneyMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mentionmoneybutton];
    
    
    _myscrollView=[[UIScrollView alloc] init];
    //做项目的时候发现UIScrollView 回弹有问题,不能回弹到原来的位置,只能到状态栏下面,在此记录下。主要是 iOS11 新增的 contentInsetAdjustmentBehavior。改成下面的就可以了
    //两者都向下偏移64像素。
    //在iOS 11以下，控制器有automaticallyAdjustsScrollViewInsets属性，默认为YES。所以要设置成NO
    if (@available(iOS 11.0, *)) {
        _myscrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (StatusbarHeight==44) {
        _myscrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44-49)];
    } else {
        _myscrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44-(0+22.0+GZDeviceHeight/27))];
    }
    
    _myscrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:_myscrollView];
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
    [_myscrollView addGestureRecognizer:myTap]; //点击空白区，让二维码消失
    
    if (StatusbarHeight==44) {
        _myscrollView.contentSize=CGSizeMake(GZDeviceWidth, GZDeviceHeight/4+GZDeviceHeight*2/5/3*4+1+10+GZDeviceHeight/4+10+2);//内容大小
    } else{
        _myscrollView.contentSize=CGSizeMake(GZDeviceWidth, GZDeviceHeight/4+GZDeviceHeight*2/5/3*4+1+10+GZDeviceHeight/4+10+2);//内容大小
    }
    
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
    UIButton *meButton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/2+GZDeviceWidth/2/4, GZDeviceHeight/4*3/4.5, GZDeviceWidth/4,32)];
    [meButton setTitle:@"我要提币" forState:UIControlStateNormal];
    [meButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    meButton.titleLabel.font=[UIFont systemFontOfSize:13.f];
    meButton.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    meButton.layer.cornerRadius=16.f;
    [meButton addTarget:self action:@selector(meMethod) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:meButton];
    */
     
    
    _iv1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VECTlogol.png"]];
    _iv1.frame=CGRectMake((GZDeviceWidth-GZDeviceWidth/4/1.5)/2, GZDeviceHeight/4/30, GZDeviceWidth/4/1.5,GZDeviceWidth/4/1.5);
    [iv addSubview:_iv1];
    
    _label23=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/30, GZDeviceHeight/4*0.43, GZDeviceWidth*3.75/5, GZDeviceHeight/4/7)];
    _label23.text=@"0xdd0f2a0dc8c550372cd0c030b33e8c3ef16af1f6";
    _label23.textColor=[UIColor blackColor];
    _label23.lineBreakMode= NSLineBreakByTruncatingMiddle;//一行内容太长时中间以省略号形式
    _label23.font=[UIFont systemFontOfSize:6+GZDeviceWidth/45];
    [iv addSubview:_label23];
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickerweimaImageView)];
    [_label23 addGestureRecognizer:labelTapGestureRecognizer];
    _label23.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    _iv2=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15+GZDeviceWidth*4/5, GZDeviceHeight/4*0.43, GZDeviceHeight/4/7, GZDeviceHeight/4/7)];
    _iv2.image=[UIImage imageNamed:@"VECTerweima.png"];
    [iv addSubview:_iv2];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickerweimaImageView)];
    [_iv2 addGestureRecognizer:tapGesture2];
    _iv2.userInteractionEnabled=YES;
    
    UILabel *label24=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/30, GZDeviceHeight/4*0.60, GZDeviceWidth/10, 15+GZDeviceHeight/30)];
    label24.text=@"总量";
    label24.textColor=[UIColor whiteColor];
    label24.font=[UIFont systemFontOfSize:12.f];
    [iv addSubview:label24];
    
    _label25=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/30+GZDeviceWidth/10, GZDeviceHeight/4*0.60, GZDeviceWidth*3/4, 15+GZDeviceHeight/30)];
    _label25.text=@"00000.000";
    _label25.textColor=[UIColor whiteColor];
    _label25.font=[UIFont systemFontOfSize:27.f];
    [iv addSubview:_label25];
    
    _label26=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/30, GZDeviceHeight/4*0.82, GZDeviceWidth*4/5, 20)];
    _label26.text=@"≈ ¥ 0000000.000000";
    _label26.textColor=[UIColor whiteColor];
    _label26.font=[UIFont systemFontOfSize:12.5f];
    [iv addSubview:_label26];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/4, GZDeviceWidth,GZDeviceHeight*2/5/3*4+1)];
    view.backgroundColor=[UIColor whiteColor];
    [_myscrollView addSubview:view];
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, GZDeviceHeight*2/5/3-0.5, GZDeviceWidth, 1)];
    view1.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [view addSubview:view1];
    
    UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(0, GZDeviceHeight*2/5/3*2-0.5, GZDeviceWidth, 1)];
    view2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [view addSubview:view2];
    
    UIView *view21=[[UIView alloc] initWithFrame:CGRectMake(0, GZDeviceHeight*2/5/3*3-0.5, GZDeviceWidth, 1)];
    view21.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [view addSubview:view21];
    
    UIView *view3=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/2-0.5, 0, 1, GZDeviceHeight*2/5/3*4+1)];
    view3.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [view addSubview:view3];
    
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, GZDeviceWidth/5, GZDeviceHeight*2/5/3*1.5/5)];
    label1.text=@"余额";
    label1.font=[UIFont systemFontOfSize:13.f];
    label1.textColor=[UIColor darkGrayColor];
    [view addSubview:label1];
    
    _label2=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3*1.5/5, GZDeviceWidth*2/5, GZDeviceHeight*2/5/3*2/5)];
    _label2.text=@"0.000";
    _label2.font=[UIFont systemFontOfSize:21.f];
    [view addSubview:_label2];
    
    _label3=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3*3.5/5-2, GZDeviceWidth*2/5, GZDeviceHeight*2/5/1.5/5)];
    _label3.text=@"≈ ¥ 0.000000";
    _label3.font=[UIFont systemFontOfSize:13.f];
    _label3.textColor=[UIColor darkGrayColor];
    [view addSubview:_label3];
    
    UILabel *label4=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, 0, GZDeviceWidth/5, GZDeviceHeight*2/5/3*1.5/5)];
    label4.text=@"定期";
    label4.font=[UIFont systemFontOfSize:13.f];
    label4.textColor=[UIColor darkGrayColor];
    [view addSubview:label4];
    
    _label5=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, GZDeviceHeight*2/5/3*1.5/5, GZDeviceWidth*2.3/5, GZDeviceHeight*2/5/3*2/5)];
    _label5.text=@"0.000";
    _label5.font=[UIFont systemFontOfSize:21.f];
    [view addSubview:_label5];
    
    _label6=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, GZDeviceHeight*2/5/3*3.5/5-2, GZDeviceWidth*2/5, GZDeviceHeight*2/5/1.5/5)];
    _label6.text=@"≈ ¥ 0.000000";
    _label6.font=[UIFont systemFontOfSize:13.f];
    _label6.textColor=[UIColor darkGrayColor];
    [view addSubview:_label6];
    
    UILabel *label7=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3, GZDeviceWidth/5, GZDeviceHeight*2/5/3*1.5/5)];
    label7.text=@"持币收益";
    label7.font=[UIFont systemFontOfSize:13.f];
    label7.textColor=[UIColor darkGrayColor];
    [view addSubview:label7];
    
    _label8=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*1.5/5, GZDeviceWidth*2/5, GZDeviceHeight*2/5/3*2/5)];
    _label8.text=@"0.000";
    _label8.font=[UIFont systemFontOfSize:21.f];
    [view addSubview:_label8];
    
    _label9=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*3.5/5, GZDeviceWidth*2/5, GZDeviceHeight*2/5/1.5/5)];
    _label9.text=@"≈ ¥ 0.000000";
    _label9.font=[UIFont systemFontOfSize:13.f];
    _label9.textColor=[UIColor darkGrayColor];
    [view addSubview:_label9];
    
    UILabel *label10=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, GZDeviceHeight*2/5/3, GZDeviceWidth/5, GZDeviceHeight*2/5/3*1.5/5)];
    label10.text=@"天使收益";
    label10.font=[UIFont systemFontOfSize:13.f];
    label10.textColor=[UIColor darkGrayColor];
    [view addSubview:label10];
    
    _labelangel=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, +GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*1.5/5, GZDeviceWidth*2/5, GZDeviceHeight*2/5/3*2/5)];
    _labelangel.text=@"0.000";
    _labelangel.font=[UIFont systemFontOfSize:21.f];
    [view addSubview:_labelangel];
    
    _labelangelconversion=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*3.5/5, GZDeviceWidth*2/5, GZDeviceHeight*2/5/1.5/5)];
    _labelangelconversion.text=@"≈ ¥ 0.000000";
    _labelangelconversion.font=[UIFont systemFontOfSize:13.f];
    _labelangelconversion.textColor=[UIColor darkGrayColor];
    [view addSubview:_labelangelconversion];
    
    UILabel *label13=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*2+1, GZDeviceWidth/5, GZDeviceHeight*2/5/3*1.5/5)];
    label13.text=@"可提";
    label13.font=[UIFont systemFontOfSize:13.f];
    label13.textColor=[UIColor darkGrayColor];
    [view addSubview:label13];
    
    _label14=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*1.5/5+GZDeviceHeight*2/5/3*2+1, GZDeviceWidth*2/5, GZDeviceHeight*2/5/3*2/5)];
    _label14.text=@"0.000";
    _label14.font=[UIFont systemFontOfSize:21.f];
    [view addSubview:_label14];
    
    _label15=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*3.5/5+GZDeviceHeight*2/5/3*2+1, GZDeviceWidth*2/5, GZDeviceHeight*2/5/1.5/5)];
    _label15.text=@"≈ ¥ 0.000000";
    _label15.font=[UIFont systemFontOfSize:13.f];
    _label15.textColor=[UIColor darkGrayColor];
    [view addSubview:_label15];
    
    UILabel *label30=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3, GZDeviceWidth/5, GZDeviceHeight*2/5/3*1.5/5)];
    label30.text=@"解冻收益";
    label30.font=[UIFont systemFontOfSize:13.f];
    label30.textColor=[UIColor darkGrayColor];
    [view addSubview:label30];
    
    _label27=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*1.5/5+GZDeviceHeight*2/5/3, GZDeviceWidth*2/5, GZDeviceHeight*2/5/3*2/5)];
    _label27.text=@"0.000";
    _label27.font=[UIFont systemFontOfSize:21.f];
    [view addSubview:_label27];
    
    _label28=[[UILabel alloc] initWithFrame:CGRectMake(10, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*3.5/5+GZDeviceHeight*2/5/3, GZDeviceWidth*2/5, GZDeviceHeight*2/5/1.5/5)];
    _label28.text=@"≈ ¥ 0.000000";
    _label28.font=[UIFont systemFontOfSize:13.f];
    _label28.textColor=[UIColor darkGrayColor];
    [view addSubview:_label28];
    
    UILabel *label31=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3, GZDeviceWidth/5, GZDeviceHeight*2/5/3*1.5/5)];
    label31.text=@"赠送收益";
    label31.font=[UIFont systemFontOfSize:13.f];
    label31.textColor=[UIColor darkGrayColor];
    [view addSubview:label31];
    
    _label29=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*1.5/5+GZDeviceHeight*2/5/3, GZDeviceWidth*2/5, GZDeviceHeight*2/5/3*2/5)];
    _label29.text=@"0.0";
    _label29.font=[UIFont systemFontOfSize:21.f];
    [view addSubview:_label29];
    
    _label30=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*3.5/5+GZDeviceHeight*2/5/3, GZDeviceWidth*2/5, GZDeviceHeight*2/5/1.5/5)];
    _label30.text=@"≈ ¥ 0.000000";
    _label30.font=[UIFont systemFontOfSize:13.f];
    _label30.textColor=[UIColor darkGrayColor];
    [view addSubview:_label30];
    
    UILabel *label16=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*2+1, GZDeviceWidth/5, GZDeviceHeight*2/5/3*1.5/5)];
    label16.text=@"冻结";
    label16.font=[UIFont systemFontOfSize:13.f];
    label16.textColor=[UIColor darkGrayColor];
    [view addSubview:label16];
    
    _label17=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*1.5/5+GZDeviceHeight*2/5/3*2+1, GZDeviceWidth*2.3/5, GZDeviceHeight*2/5/3*2/5)];
    _label17.text=@"0.000";
    _label17.font=[UIFont systemFontOfSize:21.f];
    [view addSubview:_label17];
    
    _label18=[[UILabel alloc] initWithFrame:CGRectMake(10+GZDeviceWidth/2-0.5, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3*3.5/5+GZDeviceHeight*2/5/3*2+1, GZDeviceWidth*2/5, GZDeviceHeight*2/5/1.5/5)];
    _label18.text=@"≈ ¥ 0.000000";
    _label18.font=[UIFont systemFontOfSize:13.f];
    _label18.textColor=[UIColor darkGrayColor];
    [view addSubview:_label18];
    
    _unlockbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth-GZDeviceWidth/6-10, GZDeviceHeight*2/5/3+GZDeviceHeight*2/5/3/3*4+1, GZDeviceWidth/6, 10.5+GZDeviceHeight/58)];
    [_unlockbutton setTitle:@"解冻" forState:UIControlStateNormal];
    _unlockbutton.titleLabel.font=[UIFont systemFontOfSize:12.f];
    _unlockbutton.backgroundColor=[UIColor redColor];
    _unlockbutton.layer.cornerRadius=6.f;
    [_unlockbutton addTarget:self action:@selector(unlockMethod) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_unlockbutton];
    
    UIView *view4=[[UIView alloc] initWithFrame:CGRectMake(0, GZDeviceHeight/4+GZDeviceHeight*2/5+10+GZDeviceHeight*2/5/3+1, GZDeviceWidth, GZDeviceHeight/4)];
    view4.backgroundColor=[UIColor whiteColor];
    [_myscrollView addSubview:view4];
    
    _label19=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*0.04, 0, GZDeviceWidth*3/5, GZDeviceHeight*2/4/5)];
    _label19.text=@"VECT奖励计划:20180410";
    _label19.font=[UIFont systemFontOfSize:9.f+GZDeviceWidth/40];
    [view4 addSubview:_label19];
    
    _label20=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*0.04, GZDeviceHeight*2/4/5, GZDeviceWidth*3/5, GZDeviceHeight/4/5)];
    _label20.text=@"开始日期:2018-04-10 00:00:00";
    _label20.font=[UIFont systemFontOfSize:13.f];
    _label20.textColor=[UIColor darkGrayColor];
    [view4 addSubview:_label20];
    
    _label21=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*0.04, GZDeviceHeight*2/4/5+GZDeviceHeight/4/5, GZDeviceWidth*3/5, GZDeviceHeight/4/5)];
    _label21.text=@"结束日期:2018-05-10 00:00:00";
    _label21.font=[UIFont systemFontOfSize:13.f];
    _label21.textColor=[UIColor darkGrayColor];
    [view4 addSubview:_label21];
    
    
    UILabel *dailyratelabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*0.04, GZDeviceHeight*2/4/5+GZDeviceHeight/4/5+GZDeviceHeight/4/5, GZDeviceWidth/7, GZDeviceHeight/4/5)];
    dailyratelabel.text=@"日利率:";
    dailyratelabel.textColor=[UIColor grayColor];
    dailyratelabel.textAlignment=NSTextAlignmentLeft;
    dailyratelabel.font=[UIFont systemFontOfSize:6+GZDeviceWidth/45];
    //dailyratelabel.backgroundColor=[UIColor brownColor];
    [view4 addSubview:dailyratelabel];
    
    
    _label22=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*0.04+GZDeviceWidth/7, GZDeviceHeight*2/4/5+GZDeviceHeight/4/5+GZDeviceHeight/4/5, GZDeviceWidth*3/5, GZDeviceHeight/4/5)];
    _label22.text=@"0.1%";
    _label22.textColor=[UIColor redColor];
    _label22.font=[UIFont systemFontOfSize:9.f+GZDeviceWidth/40];
    [view4 addSubview:_label22];
    
    UIButton *inputButton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth*3/4, GZDeviceHeight/4/3, 5+GZDeviceWidth/6, 5+GZDeviceWidth/6)];
    [inputButton setBackgroundImage:[UIImage imageNamed:@"VECTnowinput.png"] forState:UIControlStateNormal];
    [inputButton addTarget:self action:@selector(inputMethod) forControlEvents:UIControlEventTouchUpInside];
    [view4 addSubview:inputButton];
    _inputbutton=inputButton;
    
    //[self getrequest];//获取到price
    
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

-(void)clickerweimaImageView
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myuserId0=[userDefaults stringForKey:@"myuserId"];
    NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
    
    NSLog(@"点击了二维码图片!");
    _label23.userInteractionEnabled=NO;
    _iv2.userInteractionEnabled=NO;
    
    [LCProgressHUD showLoading:@"正在加载..."];
    
    self.view.userInteractionEnabled=NO;
    
    NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/recharge"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:myuserId0 forKey:@"userId"];
    [parameters setValue:mytoken forKey:@"token"];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *args = [self convertToJsonData:parameters];
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    // 3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务
    NSLog(@"创建一个task任务");
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[tableFooterActivityIndicator stopAnimating];//菊花停止
            //[tableFooterActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏菊花
            
            [LCProgressHUD hide];
            self.view.userInteractionEnabled=YES;
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
                NSLog(@"post success :%@",object1);
                NSString *str0=[object1 objectForKey:@"code"];
                NSString *str00=[NSString stringWithFormat:@"%@", str0];
                NSString *str1=[object1 objectForKey:@"desc"];
                NSDictionary *dict2=[object1 objectForKey:@"resultMap"];
                NSDictionary *dict3=[dict2 objectForKey:@"data"];
                self.codeAddress=[dict3 objectForKey:@"icoCurrSite"];
                NSString *str5=[dict3 objectForKey:@"referralLinks"];
                
                NSLog(@"解析出来的code：%@",str0);
                NSLog(@"解析出来的desc：%@",str1);
                NSLog(@"解析出来的resultMap：%@",dict2);
                //NSLog(@"解析出来的str4：%@",str4);
                NSLog(@"解析出来的str5：%@",str5);
                
                if ([str00 isEqualToString:@"0"]) {
                    [self generateqrcodes];//点击生成二维码图片
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
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未获取到数据" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

//点击生成二维码图片
-(void)generateqrcodes
{
    // 1.创建过滤器 -- 苹果没有将这个字符封装成常量
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.过滤器恢复默认设置
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/帐号和密码) -- 通过KVC设置过滤器,只能设置NSData类型
    //NSString *dataString = @"http://www.baidu.com";
    NSString *dataString = _codeAddress;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    
    // 5.显示二维码
    dispatch_async(dispatch_get_main_queue(), ^{
        self.Qrcodeview=[[UIView alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*4/5)/2, GZDeviceHeight/4, GZDeviceWidth*4/5, GZDeviceWidth*4/5)];
        self.Qrcodeview.backgroundColor=[UIColor colorWithRed:202/255.0 green:235/255.0 blue:216/255.0 alpha:1.0f];
        [self.view addSubview:self.Qrcodeview];
        
        
        UIImageView *todressImageView=[[UIImageView alloc] initWithFrame:CGRectMake((GZDeviceWidth*4/5-80)/2, 0, 70, 70*3/10)];
        todressImageView.image=[UIImage imageNamed:@"todress.png"];
        [self.Qrcodeview addSubview:todressImageView];
        
        
        UILabel *todressLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth*4/5-80)/2, 3, 70, 20)];
        todressLabel.text=@"转入地址";
        todressLabel.textColor=[UIColor whiteColor];
        todressLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/45];
        todressLabel.textAlignment=NSTextAlignmentCenter;
        [self.Qrcodeview addSubview:todressLabel];

        
        self.codeAdlabel=[[UILabel alloc] initWithFrame:CGRectMake(30, (GZDeviceWidth*4/5-GZDeviceWidth*2.3/5)/2/2+GZDeviceWidth*2.83/5, GZDeviceWidth*4/5-30*2, 50)];
        self.codeAdlabel.text=self.codeAddress;
        self.codeAdlabel.textColor=[UIColor blackColor];
        self.self.codeAdlabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
        self.self.codeAdlabel.numberOfLines=0;
        [self.Qrcodeview addSubview:self.codeAdlabel];
        //给codelabel长按手势添加复制功能
        self.codeAdlabel.userInteractionEnabled=YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPre:)];
        //longPress.minimumPressDuration = 0.8; //定义按的时间
        //longPress.numberOfTouchesRequired = 1;
        [self.codeAdlabel addGestureRecognizer:longPress];
        
        UIImageView *QrcodeImageView=[[UIImageView alloc] initWithFrame:CGRectMake((GZDeviceWidth*4/5-GZDeviceWidth*2.3/5)/2, (GZDeviceWidth*4/5-GZDeviceWidth*2.3/5)/2, GZDeviceWidth*2.3/5, GZDeviceWidth*2.3/5)];
        QrcodeImageView.image=[UIImage imageWithCIImage:outputImage];
        QrcodeImageView.image=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
        [self.Qrcodeview addSubview:QrcodeImageView];
        self.QrcodeImageView=QrcodeImageView;
        UITapGestureRecognizer *longP = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longP)];
        self.QrcodeImageView.userInteractionEnabled = YES; // 打开交互
        [self.QrcodeImageView addGestureRecognizer:longP];
    });
}

//长按添加二维码到手机相册
- (void)longP{
    
    UIAlertController *con = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存二维码到手机相册？" preferredStyle:1];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.QrcodeImageView.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),NULL); // 写入相册
    }];
    //  此处的image1为对应image的imageView 请自行修改
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
    [con addAction:action1];
    [con addAction:action];
    [self presentViewController:con animated:YES completion:nil];
}

// 完善回调
-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        UIAlertController *con = [UIAlertController alertControllerWithTitle:@"提示" message:@"图片保存成功！" preferredStyle:1];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:1 handler:nil];
        [con addAction:action];
        [self presentViewController:con animated:YES completion:nil];
    }else{
        UIAlertController *con = [UIAlertController alertControllerWithTitle:@"提示" message:@"图片保存失败！" preferredStyle:1];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:1 handler:nil];
        [con addAction:action];
        [self presentViewController:con animated:YES completion:nil];
    }
}


/*
 根据CIImage生成指定大小的UIImage
 @param image CIImage
 @param size  图片宽度
 @return 生成高清的UIImage
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

// 使label能够成为响应事件，为了能接收到事件（能成为第一响应者）
- (BOOL)canBecomeFirstResponder{
    return YES;
}

// 可以控制响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

//针对响应方法的实现，最主要的复制的两句代码
- (void)copy:(id)sender{
    self.codeAdlabel.backgroundColor=[UIColor whiteColor];
    //UIPasteboard：该类支持写入和读取数据，类似剪贴板
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.codeAdlabel.text;
}

// 处理长按事件
- (void)longPre:(UILongPressGestureRecognizer *)recognizer{
    
    [self becomeFirstResponder]; // 用于UIMenuController显示，缺一不可
    self.codeAdlabel.backgroundColor=[UIColor colorWithRed:127/255.0 green:255/255.0 blue:212/255.0 alpha:1.0];
    //UIMenuController：可以通过这个类实现点击内容，或者长按内容时展示出复制等选择的项，每个选项都是一个UIMenuItem对象
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.codeAdlabel.frame inView:self.codeAdlabel.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
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

- (void)unlockMethod
{
    NSLog(@"点击了资产界面的解冻按钮");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你是否要全部解冻？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击是");
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *myuserId1=[userDefaults stringForKey:@"myuserId"];
        NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
        
        UIActivityIndicatorView *tableFooterActivityIndicator =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //tableFooterActivityIndicator.center=CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
        tableFooterActivityIndicator.center=self.view.center;//把菊花设在屏幕正中心
        //tableFooterActivityIndicator.color=[UIColor redColor];
        [self.view addSubview:tableFooterActivityIndicator];
        [tableFooterActivityIndicator startAnimating];
        self.view.userInteractionEnabled=NO;
        
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/unfreeze"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:myuserId1 forKey:@"userId"];
        [parameters setValue:mytoken forKey:@"token"];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *args = [self convertToJsonData:parameters];
        request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
        // 3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.根据会话对象，创建一个Task任务
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableFooterActivityIndicator stopAnimating];//菊花停止
                [tableFooterActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏菊花
                self.view.userInteractionEnabled=YES;
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
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*0.4)/2, GZDeviceHeight*3/5, GZDeviceWidth*0.4, 20+GZDeviceHeight/25)];
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
                        });
                    } else if ([str00 isEqualToString:@"-1"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*4/5)/2, GZDeviceHeight*3/5, GZDeviceWidth*4/5, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:12.f];
                            theLabel.text=str1;
                            [self.view addSubview:theLabel];
                            
                            //设置动画
                            CATransition *transion=[CATransition animation];
                            transion.type=@"push";//动画方式
                            transion.subtype=@"fromLeft";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
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
                            transion.subtype=@"fromLeft";//设置动画从哪个方向开始
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
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*3/5)/2, GZDeviceHeight*3/5, GZDeviceWidth*3/5, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
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
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                        });
                        
                    }
                }
            }
        }];
        
        //5.最后一步，执行任务，启动请求(resume也是继续执行)。
        [sessionDataTask resume];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击否");
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)inputMethod
{
    NSLog(@"点击了资产界面的现在加入按钮");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认加入?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击是");
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *myuserId2=[userDefaults stringForKey:@"myuserId"];
        NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
        
        UIActivityIndicatorView *tableFooterActivityIndicator =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //tableFooterActivityIndicator.center=CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
        tableFooterActivityIndicator.center=self.view.center;//把菊花设在屏幕正中心
        //tableFooterActivityIndicator.color=[UIColor redColor];
        [self.view addSubview:tableFooterActivityIndicator];
        [tableFooterActivityIndicator startAnimating];
        self.view.userInteractionEnabled=NO;
        
        NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/joinAward"]];
        // 2.创建一个网络请求，分别设置请求方法、请求参数
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:myuserId2 forKey:@"userId"];
        [parameters setValue:mytoken forKey:@"token"];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *args = [self convertToJsonData:parameters];
        request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
        // 3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        // 4.根据会话对象，创建一个Task任务
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableFooterActivityIndicator stopAnimating];//菊花停止
                [tableFooterActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏菊花
                self.view.userInteractionEnabled=YES;
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
                    theLabel.text=@"请您先连接网络！";
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
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            
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
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.joinLabel.text=str1;
                        
                    });
                    
                    if ([str00 isEqualToString:@"0"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*0.4)/2, GZDeviceHeight*3/5, GZDeviceWidth*0.4, 20+GZDeviceHeight/25)];
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
                            transion.subtype=@"fromLeft";//设置动画从哪个方向开始
                            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
                            //不占用主线程
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                
                                [theLabel removeFromSuperview];
                                
                            });//这句话的意思是1.5秒后，把label移出视图
                        });
                    } else if ([str00 isEqualToString:@"-1"]) {
                        //您账户余额为零！认购失败!
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*3/5)/2, GZDeviceHeight*3/5, GZDeviceWidth*3/5, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:12.f];
                            theLabel.text=@"您账户余额为零！认购失败!";
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
                            
                            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth*3/5)/2, GZDeviceHeight*3/5, GZDeviceWidth*3/5, 20+GZDeviceHeight/25)];
                            theLabel.backgroundColor=[UIColor blackColor];
                            theLabel.layer.cornerRadius = 5.f;
                            theLabel.clipsToBounds = YES;
                            theLabel.textColor=[UIColor whiteColor];
                            theLabel.alpha=0.8f;
                            theLabel.textAlignment=NSTextAlignmentCenter;
                            theLabel.font=[UIFont systemFontOfSize:12.f];
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
                        });
                        
                    }
                }
            }
        }];
        
        //5.最后一步，执行任务，启动请求(resume也是继续执行)。
        [sessionDataTask resume];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击否");
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

/*
//我要提币按钮
- (void)meMethod
{
    NSLog(@"woyaotibi~~~~");
    brmonViewController *bm=[[brmonViewController alloc] init];
    [self presentViewController:bm animated:YES completion:nil];
}
*/
 
//请求获取最新的数据
- (void)loadNewData {
    NSLog(@"请求获取最新的数据");
    
    UIView *myview=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44))];
    myview.backgroundColor=[UIColor blackColor];
    myview.alpha=0.1;
    [self.view addSubview:myview];
    
    //UIActivityIndicatorView *tableFooterActivityIndicator =
    //[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //tableFooterActivityIndicator.center=self.view.center;//把菊花设在屏幕正中心
    //tableFooterActivityIndicator.color=[UIColor redColor];
    //[self.view addSubview:tableFooterActivityIndicator];
    //[tableFooterActivityIndicator startAnimating];
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
            [self Incentiveplan];
            //二维码地址
            [self codeaddress];
        });
        
        //[_myscrollView reloadData];
        //拿到当前的刷新控件，结束刷新状态
        //[tableFooterActivityIndicator stopAnimating];
        //[tableFooterActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        //[LCProgressHUD showSuccess:@"加载成功"];
        /*
         [NSTimer scheduledTimerWithTimeInterval:1.0
         target:self selector:@selector(hideHUD)
         userInfo:nil
         repeats:NO];
         */
        [LCProgressHUD hide];
        [myview removeFromSuperview];
        self.view.userInteractionEnabled=YES;
        [self.myscrollView.mj_header endRefreshing];
    });
    [_myscrollView.mj_header beginRefreshing];
}

/*
 -(void)hideHUD {
 
 [LCProgressHUD hide];
 }
 */

//二维码地址
-(void)codeaddress
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myuserId3=[userDefaults stringForKey:@"myuserId"];
    NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
    
    NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/recharge"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.f];//超过这个时间就算超时，请求失败
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:myuserId3 forKey:@"userId"];
    [parameters setValue:mytoken forKey:@"token"];
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
            
            //判断是否请求超时
            if (error.code==-1001) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
                    theLabel.backgroundColor=[UIColor blackColor];
                    theLabel.layer.cornerRadius = 5.f;
                    theLabel.clipsToBounds = YES;
                    theLabel.textColor=[UIColor whiteColor];
                    theLabel.alpha=0.7f;
                    theLabel.textAlignment=NSTextAlignmentCenter;
                    theLabel.font=[UIFont systemFontOfSize:15.f];
                    theLabel.text=@"请求超时";
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
                    theLabel.text=@"请您先连接网络";
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
            
        } else {
            // 如果请求成功，则解析数据。
            NSLog(@"返回的response信息%@",response);
            id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            // 11、判断是否解析成功
            if (error) {
                NSLog(@"post error :%@",error.localizedDescription);
            } else {
                // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                NSLog(@"post success :%@",object1);
                NSString *str0=[object1 objectForKey:@"code"];
                NSString *str00=[NSString stringWithFormat:@"%@", str0];
                NSString *str1=[object1 objectForKey:@"desc"];
                NSDictionary *dict2=[object1 objectForKey:@"resultMap"];
                NSDictionary *dict3=[dict2 objectForKey:@"data"];
                //self.codeAddress=[dict3 objectForKey:@"referralLinks"];
                NSString *str5=[dict3 objectForKey:@"icoCurrSite"];
                self.codeStr=str5;
                
                NSLog(@"解析出来的code：%@",str0);
                NSLog(@"解析出来的desc：%@",str1);
                NSLog(@"解析出来的resultMap：%@",dict2);
                //NSLog(@"解析出来的str4：%@",str4);
                NSLog(@"解析出来的str5：%@",str5);
                
                if ([str00 isEqualToString:@"0"]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.label23.text=str5;
                        
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
    [request setTimeoutInterval:5.0f];//超过这个时间就算超时，请求失败
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
            
            if (error.code==-1001) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/3)/2, GZDeviceHeight*3.5/5, GZDeviceWidth/3, 20+GZDeviceHeight/25)];
                    theLabel.backgroundColor=[UIColor blackColor];
                    theLabel.layer.cornerRadius = 5.f;
                    theLabel.clipsToBounds = YES;
                    theLabel.textColor=[UIColor whiteColor];
                    theLabel.alpha=0.7f;
                    theLabel.textAlignment=NSTextAlignmentCenter;
                    theLabel.font=[UIFont systemFontOfSize:15.f];
                    theLabel.text=@"请求超时";
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
            }
        }else {
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
                    
                    NSString *strr1=[[dic2 objectForKey:@"data"] objectForKey:@"currencyNumbe"];
                    NSString *strr2=[[dic2 objectForKey:@"data"] objectForKey:@"frozenNumber"];
                    NSString *strr3=[[dic2 objectForKey:@"data"] objectForKey:@"currencAvaBal"];
                    NSString *strr4=[[dic2 objectForKey:@"data"] objectForKey:@"fuelNum"];
                    NSString *strr5=[[dic2 objectForKey:@"data"] objectForKey:@"currencyNumbe"];
                    NSString *strr51=[[dic2 objectForKey:@"data"] objectForKey:@"unfreezeEarnings"];
                    //NSString *strr52=[[dic2 objectForKey:@"data"] objectForKey:@"newNumber"];
                    NSString *strr53=[[dic2 objectForKey:@"data"] objectForKey:@"angelEarnings"];//天使收益
                    
                    float flstr1=[strr1 floatValue];
                    float flstr2=[strr2 floatValue];
                    float flstr3=[strr3 floatValue];
                    float flstr4=[strr4 floatValue];
                    float flstr5=[strr5 floatValue];
                    float flstr51=[strr51 floatValue];
                    //float flstr52=[strr52 floatValue];
                    float flstr53=[strr53 floatValue];
                    float flstr6=flstr2+flstr4+flstr53;
                    float flstr7=flstr1+flstr3+flstr51;
                    
                    //冻结
                    NSString *strr6=[NSString stringWithFormat:@"%f", flstr6];
                    //可提
                    NSString *strr7=[NSString stringWithFormat:@"%f", flstr7];
                    NSLog(@"strr1的值:%@", strr1);
                    NSLog(@"strr2的值:%@", strr2);
                    NSLog(@"strr3的值:%@", strr3);
                    NSLog(@"strr4的值:%@", strr4);
                    NSLog(@"strr5的值:%@", strr5);
                    NSLog(@"strr6的值:%@", strr6);
                    NSLog(@"strr7的值:%@", strr7);
                    
                    NSString *symbolString=@"≈ ¥ ";
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.label2.text=[NSString stringWithFormat:@"%.1f", flstr1];
                        float floatstring1=[self.label2.text floatValue];
                        float floatstring2=floatstring1*(self.para);
                        self.label3.text=[symbolString stringByAppendingString:[NSString stringWithFormat:@"%.1f", floatstring2]];
                        
                        self.label5.text=[NSString stringWithFormat:@"%.1f", flstr2];
                        float floatstring3=[self.label5.text floatValue];
                        float floatstring4=floatstring3*(self.para);
                        self.label6.text=[symbolString stringByAppendingString:[NSString stringWithFormat:@"%.3f", floatstring4]];
                        
                        self.label8.text=[NSString stringWithFormat:@"%.3f", flstr3];
                        float floatstring5=[self.label8.text floatValue];
                        float floatstring6=floatstring5*(self.para);
                        self.label9.text=[symbolString stringByAppendingString:[NSString stringWithFormat:@"%f", floatstring6]];
                        
                        self.labelangel.text=[NSString stringWithFormat:@"%.1f", flstr53];
                        float floatstring7=[self.label11.text floatValue];
                        float floatstring8=floatstring7*(self.para);
                        self.labelangelconversion.text=[symbolString stringByAppendingString:[NSString stringWithFormat:@"%.1f", floatstring8]];
                        
                        self.label14.text=[NSString stringWithFormat:@"%.3f", flstr5];
                        float floatstring9=[self.label14.text floatValue];
                        float floatstring10=floatstring9*(self.para);
                        self.label15.text=[symbolString stringByAppendingString:[NSString stringWithFormat:@"%f", floatstring10]];
                        
                        self.label27.text=[NSString stringWithFormat:@"%.1f", flstr51];
                        float floatstring27=[self.label27.text floatValue];
                        float floatstring28=floatstring27*(self.para);
                        self.label28.text=[symbolString stringByAppendingString:[NSString stringWithFormat:@"%.4f", floatstring28]];
                        
                        self.label29.text=[NSString stringWithFormat:@"%.1f", flstr4];
                        float floatstring29=[self.label29.text floatValue];
                        float floatstring30=floatstring29*(self.para);
                        self.label30.text=[symbolString stringByAppendingString:[NSString stringWithFormat:@"%.1f", floatstring30]];
                        
                        //可提
                        self.label14.text=[NSString stringWithFormat:@"%.3f", flstr7];
                        float floatstring100=[self.label14.text floatValue];
                        float floatstring101=floatstring100*(self.para);
                        self.label15.text=[symbolString stringByAppendingString:[NSString stringWithFormat:@"%.6f", floatstring101]];
                        
                        //冻结
                        self.label17.text=[NSString stringWithFormat:@"%.1f", flstr6];
                        float floatstring11=[self.label17.text floatValue];
                        float floatstring12=floatstring11*(self.para);
                        self.label18.text=[symbolString stringByAppendingString:[NSString stringWithFormat:@"%.3f", floatstring12]];
                        
                        //总量
                        //NSLog(@"总量中的参数%f %f %f %f", flstr1, flstr2,flstr3,flstr4);
                        float floatstring13=flstr6+flstr7;
                        self.label25.text=[NSString stringWithFormat:@"%.3f", floatstring13];
                        float floatstring14=floatstring13*(self.para);
                        self.label26.text=[symbolString stringByAppendingString:[NSString stringWithFormat:@"%f", floatstring14]];
                        
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
                }
            }
        }
    }];
    
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

-(void)Incentiveplan
{
    //写入数据请求
    //NSLog(@"BBBBBBBBBBBBBBBBBB奖励计划");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mytoken=[userDefaults stringForKey:@"mytoken"];
    
    NSURL *url = [NSURL URLWithString:[portUrl stringByAppendingString:@"/appUser/incentivePlan"]];
    // 2.创建一个网络请求，分别设置请求方法、请求参数
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
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
        }else {
            // 如果请求成功，则解析数据。
            NSLog(@"返回的response信息%@",response);
            id object1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            // 11、判断是否解析成功
            if (error) {
                NSLog(@"post error :%@",error.localizedDescription);
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
                    
                    NSString *strr0=@"VECT奖励计划:";
                    NSString *strr1=@"起始时间:";
                    NSString *strr2=@"结束时间:";
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.label19.text=[strr0 stringByAppendingString:[[dic2 objectForKey:@"data"] objectForKey:@"tProjectName"]];
                        
                        self.label20.text=[strr1 stringByAppendingString:[[dic2 objectForKey:@"data"] objectForKey:@"tProjectBeginDate"]];
                        //[[dic2 objectForKey:@"data"] objectForKey:@"tProjectBeginDate"];
                        
                        self.label21.text=[strr2 stringByAppendingString:[[dic2 objectForKey:@"data"] objectForKey:@"tProjectCycle"]];
                        //[[dic2 objectForKey:@"data"] objectForKey:@"tProjectCycle"];
                        
                        NSString *rate=[[dic2 objectForKey:@"data"] objectForKey:@"tProjectRate"];
                        float floatrate=[rate floatValue];
                        float floatrate2=floatrate*100;
                        NSLog(@"我要的利率%@", rate);
                        
                        NSString *mystrssd=[NSString stringWithFormat:@"%0.1f", floatrate2];//保留2位小数
                        self.label22.text=[mystrssd stringByAppendingString:@"%"];
                        
                        //self.label22.text=[strr3 stringByAppendingString:[[dic2 objectForKey:@"data"] objectForKey:@"tProjectRate"]];//这种方法不行
                        
                    });
                }
            }
        }
    }];
    
    //5.最后一步，执行任务，(resume也是继续执行)。
    [sessionDataTask resume];
}

//点击空白区让二维码消失
- (void)scrollTap:(id)sender {
    NSLog(@"UITapGesture被调用了");
    [self.view endEditing:YES];
    [_Qrcodeview removeFromSuperview];
    _iv2.userInteractionEnabled=YES;
    _label23.userInteractionEnabled=YES;
}

-(void)chargemoneyMethod
{
    chargemoneyViewController *cgv=[[chargemoneyViewController alloc] init];
    cgv.codeAddressStr=self.codeStr;
    NSLog(@"跳转之前的地址%@", self.codeStr);
    [self presentViewController:cgv animated:YES completion:nil];
}

-(void)mentionmoneyMethod
{
    brmonViewController *bm=[[brmonViewController alloc] init];
    [self presentViewController:bm animated:YES completion:nil];
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
