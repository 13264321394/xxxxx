//
//  morethawdetailViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/9.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "morethawdetailViewController.h"
#import "Masonry.h"

@interface morethawdetailViewController ()

@end

@implementation morethawdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"str1=%@, str2=%@, str3=%@", _str1,_str2,_str3);
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIView *myView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, 10+GZDeviceHeight/4)];
    myView.backgroundColor=[UIColor colorWithRed:19/255.0 green:163/255.0 blue:242/255.0 alpha:1.0];
    [self.view addSubview:myView];
    
    UIView *theView=[[UIView alloc] initWithFrame:CGRectMake(0, 10+GZDeviceHeight/4, GZDeviceWidth, 10)];
    theView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:theView];
    
    UILabel *forgetPawLabel=[[UILabel alloc] init];
    forgetPawLabel.text=@"解冻记录";
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
    
    UIImageView *imv=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth*4/5, 20+GZDeviceHeight/4/2, GZDeviceWidth/16, GZDeviceWidth/16*57/48)];
    imv.image=[UIImage imageNamed:@"VECTthawdetail.png"];
    [myView addSubview:imv];
    
    UILabel *mylabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/30, 20+GZDeviceHeight/4/2, GZDeviceWidth/2, 30)];
    //mylabel.backgroundColor=[UIColor cyanColor];
    mylabel.font=[UIFont systemFontOfSize:8.5+GZDeviceWidth/30];
    //mylabel.text=@"-19.88";
    float myfloat=[_str2 floatValue];
    //if (myfloat>0) {
    //    mylabel.text=[NSString stringWithFormat:@"+%@", _str2];
    //} else {
        mylabel.text=[NSString stringWithFormat:@"-%.3f", myfloat];
    //}
    
    [myView addSubview:mylabel];
    
    UILabel *vectlabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/30, 20+GZDeviceHeight/4/2+25, GZDeviceWidth/6, 20)];
    //vectlabel.backgroundColor=[UIColor redColor];
    vectlabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    vectlabel.text=@"vect";
    [myView addSubview:vectlabel];
    
    UILabel *jiedongLabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3/4, GZDeviceWidth/3, 30)];
    jiedongLabel.text=@"解冻金额";
    jiedongLabel.font=[UIFont systemFontOfSize:8+GZDeviceWidth/32];
    //jiedongLabel.backgroundColor=[UIColor redColor];
    [self.view addSubview:jiedongLabel];
    
    UILabel *jiedongnumLabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3/4+30, GZDeviceWidth*2/3, 20)];
    float floatstr1=[_str1 floatValue];
    jiedongnumLabel.text=[NSString stringWithFormat:@"%.3f", floatstr1];
    jiedongnumLabel.font=[UIFont systemFontOfSize:2+GZDeviceWidth/32];
    [self.view addSubview:jiedongnumLabel];
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3, GZDeviceWidth-GZDeviceWidth/15, 1)];
    view1.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view1];
    
    UILabel *jiedongLabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3/4+GZDeviceHeight/3/3+1, GZDeviceWidth/2, 30)];
    jiedongLabel2.text=@"本次消耗充值金额";
    jiedongLabel2.font=[UIFont systemFontOfSize:8+GZDeviceWidth/32];
    //jiedongLabel2.backgroundColor=[UIColor redColor];
    [self.view addSubview:jiedongLabel2];
    
    UILabel *jiedongnumLabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3/4+30+GZDeviceHeight/3/3+1, GZDeviceWidth*2/3, 20)];
    //jiedongnumLabel2.text=@"19.88";
    float floatstr2=[_str2 floatValue];
    jiedongnumLabel2.text=[NSString stringWithFormat:@"%.3f", floatstr2];
    jiedongnumLabel2.font=[UIFont systemFontOfSize:2+GZDeviceWidth/32];
    [self.view addSubview:jiedongnumLabel2];
    
    UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3+GZDeviceHeight/3/3+1, GZDeviceWidth-GZDeviceWidth/15, 1)];
    view2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view2];
    
    UILabel *jiedongLabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3/4+GZDeviceHeight/3/3+1+GZDeviceHeight/3/3, GZDeviceWidth/2, 30)];
    jiedongLabel3.text=@"总消耗充值金额";
    jiedongLabel3.font=[UIFont systemFontOfSize:8+GZDeviceWidth/32];
    //jiedongLabel3.backgroundColor=[UIColor redColor];
    [self.view addSubview:jiedongLabel3];
    
    UILabel *jiedongnumLabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3/4+30+GZDeviceHeight/3/3+1+GZDeviceHeight/3/3, GZDeviceWidth*2/3, 20)];
    float erfloat=[_str3 floatValue];
    jiedongnumLabel3.text=[NSString stringWithFormat:@"%.3f", erfloat];
    jiedongnumLabel3.font=[UIFont systemFontOfSize:2+GZDeviceWidth/32];
    [self.view addSubview:jiedongnumLabel3];
    
    UIView *view3=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3+GZDeviceHeight/3/3+1+GZDeviceHeight/3/3, GZDeviceWidth-GZDeviceWidth/15, 1)];
    view3.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view3];
    
    UILabel *jiedongLabel4=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3/4+GZDeviceHeight/3/3+1+GZDeviceHeight/3/3+1+GZDeviceHeight/3/3, GZDeviceWidth/3, 30)];
    jiedongLabel4.text=@"解冻时间";
    jiedongLabel4.font=[UIFont systemFontOfSize:8+GZDeviceWidth/32];
    [self.view addSubview:jiedongLabel4];
    
    UILabel *jiedongnumLabel4=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3/4+30+GZDeviceHeight/3/3+GZDeviceHeight/3/3+1+GZDeviceHeight/3/3, GZDeviceWidth*2/3, 20)];
    jiedongnumLabel4.text=[NSString stringWithFormat:@"%@", _str4];
    jiedongnumLabel4.font=[UIFont systemFontOfSize:2+GZDeviceWidth/32];
    [self.view addSubview:jiedongnumLabel4];
    
    UIView *view4=[[UIView alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, 20+GZDeviceHeight/4+GZDeviceHeight/3/3+GZDeviceHeight/3/3+GZDeviceHeight/3/3+1+GZDeviceHeight/3/3, GZDeviceWidth-GZDeviceWidth/15, 1)];
    view4.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view4];
    
    // Do any additional setup after loading the view.
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
