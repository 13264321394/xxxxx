//
//  morecommunitymemberViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/22.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "morecommunitymemberViewController.h"
#import "Masonry.h"

@interface morecommunitymemberViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *myscrollView;

@end

@implementation morecommunitymemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIView *myView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, 10+GZDeviceHeight/4)];
    myView.backgroundColor=[UIColor colorWithRed:19/255.0 green:163/255.0 blue:242/255.0 alpha:1.0];
    [self.view addSubview:myView];
    
    UIView *theView=[[UIView alloc] initWithFrame:CGRectMake(0, 10+GZDeviceHeight/4, GZDeviceWidth, 10)];
    theView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [self.view addSubview:theView];
    
    UILabel *forgetPawLabel=[[UILabel alloc] init];
    forgetPawLabel.text=@"社区会员详情";
    forgetPawLabel.textColor=[UIColor whiteColor];
    forgetPawLabel.font=[UIFont systemFontOfSize:10+GZDeviceWidth/32];
    forgetPawLabel.textAlignment = NSTextAlignmentCenter;
    [myView addSubview:forgetPawLabel];
    [forgetPawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20+StatusbarHeight);
        make.left.mas_equalTo(GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/2, 44));
    }];
    
    UIButton *backbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/50, StatusbarHeight+7, 30, 30)];
    [backbutton setImage:[UIImage imageNamed:@"theback1.png"] forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:backbutton];
    
    UIImageView *imv=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth*4/5, 20+GZDeviceHeight/4/2, GZDeviceWidth/16, GZDeviceWidth/16*57/59)];
    imv.image=[UIImage imageNamed:@"VECT-52.png"];
    [myView addSubview:imv];
    
    UILabel *mylabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/30, 20+GZDeviceHeight/4/2, GZDeviceWidth/2, 30)];
    //mylabel.backgroundColor=[UIColor cyanColor];
    mylabel.font=[UIFont systemFontOfSize:8.5+GZDeviceWidth/30];
    float myfloat=[_str3 floatValue];
    if (myfloat>0) {
        mylabel.text=[NSString stringWithFormat:@"+%.3f", myfloat];
    } else {
        mylabel.text=[NSString stringWithFormat:@"-%.3f", myfloat];
    }
    
    [myView addSubview:mylabel];
    
    UILabel *vectlabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/30, 20+GZDeviceHeight/4/2+25, GZDeviceWidth/6, 20)];
    //vectlabel.backgroundColor=[UIColor redColor];
    vectlabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    vectlabel.text=@"vect";
    [myView addSubview:vectlabel];
    
    self.myscrollView=[[UIScrollView alloc] init];
    if (StatusbarHeight==44) {
        self.myscrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 20+GZDeviceHeight/4, GZDeviceWidth, GZDeviceHeight-(20+GZDeviceHeight/4)-34)];
    } else {
        self.myscrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 20+GZDeviceHeight/4, GZDeviceWidth, GZDeviceHeight-(20+GZDeviceHeight/4))];
    }
    
    self.myscrollView.backgroundColor=[UIColor cyanColor];
    self.myscrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:self.myscrollView];
    self.myscrollView.contentSize=CGSizeMake(GZDeviceWidth, GZDeviceHeight-(20+GZDeviceHeight/4)+1);//内容大小
    self.myscrollView.showsHorizontalScrollIndicator = NO;
    self.myscrollView.showsVerticalScrollIndicator = NO;
    self.myscrollView.delegate=self;
    
    if (@available(iOS 11.0, *)) {
        self.myscrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UILabel *jiedongLabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4, GZDeviceWidth/2, 30)];
    jiedongLabel.text=@"账号";
    jiedongLabel.font=[UIFont systemFontOfSize:8+GZDeviceWidth/32];
    //jiedongLabel.backgroundColor=[UIColor redColor];
    [self.myscrollView addSubview:jiedongLabel];
    
    UILabel *jiedongnumLabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+30, GZDeviceWidth*4/5, 20)];
    //jiedongnumLabel.text=@"6.2";
    jiedongnumLabel.text=[NSString stringWithFormat:@"%@", _str1];
    jiedongnumLabel.font=[UIFont systemFontOfSize:2+GZDeviceWidth/32];
    [self.myscrollView addSubview:jiedongnumLabel];
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3, GZDeviceWidth-GZDeviceWidth/15*2, 1)];
    view1.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [self.myscrollView addSubview:view1];
    
    UILabel *jiedongLabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+GZDeviceHeight/3/3, GZDeviceWidth/2, 30)];
    jiedongLabel2.text=@"定期算例金额";
    jiedongLabel2.font=[UIFont systemFontOfSize:8+GZDeviceWidth/32];
    //jiedongLabel2.backgroundColor=[UIColor redColor];
    [self.myscrollView addSubview:jiedongLabel2];
    
    UILabel *jiedongnumLabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+30+GZDeviceHeight/3/3, GZDeviceWidth*4/5, 20)];
    //jiedongnumLabel2.text=@"19.88";
    float floatstr2=[_str2 floatValue];
    jiedongnumLabel2.text=[NSString stringWithFormat:@"%.3f", floatstr2];
    jiedongnumLabel2.font=[UIFont systemFontOfSize:2+GZDeviceWidth/32];
    [self.myscrollView addSubview:jiedongnumLabel2];
    
    UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth-GZDeviceWidth/15*2, 1)];
    view2.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [self.myscrollView addSubview:view2];
    
    UILabel *jiedongLabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth/2, 30)];
    jiedongLabel3.text=@"定期收益";
    jiedongLabel3.font=[UIFont systemFontOfSize:8+GZDeviceWidth/32];
    //jiedongLabel3.backgroundColor=[UIColor redColor];
    [self.myscrollView addSubview:jiedongLabel3];
    
    UILabel *jiedongnumLabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+30+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth*4/5, 20)];
    float floatstr3=[_str3 floatValue];
    jiedongnumLabel3.text=[NSString stringWithFormat:@"%.3f", floatstr3];
    jiedongnumLabel3.font=[UIFont systemFontOfSize:2+GZDeviceWidth/32];
    [self.myscrollView addSubview:jiedongnumLabel3];
    
    UIView *view3=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth-GZDeviceWidth/15*2, 1)];
    view3.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [self.myscrollView addSubview:view3];
    
    UILabel *jiedongLabel4=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth/2, 30)];
    jiedongLabel4.text=@"活期算例金额";
    jiedongLabel4.font=[UIFont systemFontOfSize:8+GZDeviceWidth/32];
    //jiedongLabel3.backgroundColor=[UIColor redColor];
    [self.myscrollView addSubview:jiedongLabel4];
    
    UILabel *jiedongnumLabel4=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+30+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth*4/5, 20)];
    float floatstr4=[_str4 floatValue];
    jiedongnumLabel4.text=[NSString stringWithFormat:@"%.3f", floatstr4];
    jiedongnumLabel4.font=[UIFont systemFontOfSize:2+GZDeviceWidth/32];
    [self.myscrollView addSubview:jiedongnumLabel4];
    
    UIView *view4=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth-GZDeviceWidth/15*2, 1)];
    view4.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [self.myscrollView addSubview:view4];
    
    UILabel *jiedongLabel5=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth/2, 30)];
    jiedongLabel5.text=@"活期收益";
    jiedongLabel5.font=[UIFont systemFontOfSize:8+GZDeviceWidth/32];
    [self.myscrollView addSubview:jiedongLabel5];
    
    UILabel *jiedongnumLabel5=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+30+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth*4/5, 20)];
    float floatstr5=[_str5 floatValue];
    jiedongnumLabel5.text=[NSString stringWithFormat:@"%.3f", floatstr5];
    jiedongnumLabel5.font=[UIFont systemFontOfSize:2+GZDeviceWidth/32];
    [self.myscrollView addSubview:jiedongnumLabel5];
    
    UIView *view5=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth-GZDeviceWidth/15*2, 1)];
    view5.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [self.myscrollView addSubview:view5];
    
    UILabel *jiedongLabel6=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth/2, 30)];
    jiedongLabel6.text=@"时间";
    jiedongLabel6.font=[UIFont systemFontOfSize:8+GZDeviceWidth/32];
    //jiedongLabel3.backgroundColor=[UIColor redColor];
    [self.myscrollView addSubview:jiedongLabel6];
    
    UILabel *jiedongnumLabel6=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3/4+30+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth*4/5, 20)];
    jiedongnumLabel6.text=[NSString stringWithFormat:@"%@", _str6];
    jiedongnumLabel6.font=[UIFont systemFontOfSize:2+GZDeviceWidth/32];
    [self.myscrollView addSubview:jiedongnumLabel6];
    
    UIView *view6=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3, GZDeviceWidth-GZDeviceWidth/15*2, 1)];
    view6.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    //view6.backgroundColor=[UIColor redColor];
    [self.myscrollView addSubview:view6];
    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
