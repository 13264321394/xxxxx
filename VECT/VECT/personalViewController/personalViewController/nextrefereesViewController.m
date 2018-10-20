//
//  nextrefereesViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/17.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "nextrefereesViewController.h"
#import "Masonry.h"

@interface nextrefereesViewController ()

@property(nonatomic,assign)float h;

@end

@implementation nextrefereesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.h=20+GZDeviceHeight/20;
    
    UILabel *realnameLabel=[[UILabel alloc] init];
    realnameLabel.text=@"我推荐的人";
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
    
    UIView *view0=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, 10)];
    view0.backgroundColor=[UIColor colorWithRed:255/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    [self.view addSubview:view0];
    
    UILabel *jiedongLabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, StatusbarHeight+44+10, GZDeviceWidth/3, self.h)];
    jiedongLabel.text=@"账号";
    jiedongLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    //jiedongLabel.backgroundColor=[UIColor redColor];
    [self.view addSubview:jiedongLabel];
    
    UILabel *jiedongnumLabel=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*7/10, StatusbarHeight+44+10, GZDeviceWidth/2, self.h)];
    jiedongnumLabel.text=[NSString stringWithFormat:@"%@", _str1];
    jiedongnumLabel.font=[UIFont systemFontOfSize:4+GZDeviceWidth/35];
    jiedongnumLabel.textColor=[UIColor darkGrayColor];
    [self.view addSubview:jiedongnumLabel];
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44+10+self.h, GZDeviceWidth, 1)];
    view1.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view1];
    
    UILabel *jiedongLabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, StatusbarHeight+44+10+self.h+1, GZDeviceWidth/3, self.h)];
    jiedongLabel2.text=@"姓名";
    jiedongLabel2.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    [self.view addSubview:jiedongLabel2];
    
    UILabel *jiedongnumLabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*7/10, StatusbarHeight+44+10+self.h+1, GZDeviceWidth*4/5, self.h)];
    jiedongnumLabel2.text=[NSString stringWithFormat:@"%@", _str2];
    jiedongnumLabel2.font=[UIFont systemFontOfSize:4+GZDeviceWidth/35];
    jiedongnumLabel2.textColor=[UIColor darkGrayColor];
    [self.view addSubview:jiedongnumLabel2];
    
    UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44+10+self.h+1+self.h, GZDeviceWidth, 1)];
    view2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view2];
    
    UILabel *jiedongLabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, StatusbarHeight+44+10+self.h+1+self.h+1, GZDeviceWidth/3, self.h)];
    jiedongLabel3.text=@"联系方式";
    jiedongLabel3.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    [self.view addSubview:jiedongLabel3];
    
    UILabel *jiedongnumLabel3=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*7/10, StatusbarHeight+44+10+self.h+1+self.h+1, GZDeviceWidth*4/5, self.h)];
    jiedongnumLabel3.text=[NSString stringWithFormat:@"%@", _str3];
    jiedongnumLabel3.font=[UIFont systemFontOfSize:4+GZDeviceWidth/35];
    jiedongnumLabel3.textColor=[UIColor darkGrayColor];
    [self.view addSubview:jiedongnumLabel3];
    
    
    UIView *view3=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44+10+self.h+1+self.h+1+self.h, GZDeviceWidth, 1)];
    view3.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view3];
    
    UILabel *jiedongLabel4=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, StatusbarHeight+44+10+self.h+1+self.h+1+self.h+1, GZDeviceWidth/3, self.h)];
    jiedongLabel4.text=@"身份状态";
    jiedongLabel4.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    [self.view addSubview:jiedongLabel4];
    
    
    UILabel *jiedongnumLabel4=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*7/10, StatusbarHeight+44+10+self.h+1+self.h+1+self.h+1, GZDeviceWidth*4/5, self.h)];
    jiedongnumLabel4.font=[UIFont systemFontOfSize:4+GZDeviceWidth/35];
    jiedongnumLabel4.textColor=[UIColor darkGrayColor];
    [self.view addSubview:jiedongnumLabel4];
    
    NSString *renzhenLabel=[[NSString alloc] init];
    //NSInteger m=[_str4 integerValue];
    if ([_str4 isEqualToString:@"1"]) {
        renzhenLabel=@"已认证";
        jiedongnumLabel4.textColor=[UIColor colorWithRed:90/255.0 green:194/255.0 blue:49/255.0 alpha:1.0];
    } else if ([_str4 isEqualToString:@"-1"]) {
        renzhenLabel=@"未实名";
        jiedongnumLabel4.textColor=[UIColor grayColor];
    } else if ([_str4 isEqualToString:@"0"]) {
        renzhenLabel=@"审核中";
        jiedongnumLabel4.textColor=[UIColor grayColor];
    } else if ([_str4 isEqualToString:@"2"]) {
        renzhenLabel=@"认证失败";
        jiedongnumLabel4.textColor=[UIColor redColor];
    } else {
        renzhenLabel=@"未知";
        jiedongnumLabel4.textColor=[UIColor grayColor];
    }
    jiedongnumLabel4.text=[NSString stringWithFormat:@"%@", renzhenLabel];
    
    
    UIView *view4=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44+10+self.h+1+self.h+1+self.h+1+self.h+1, GZDeviceWidth, 1)];
    view4.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view4];
    
    UILabel *jiedongLabel5=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/15, StatusbarHeight+44+10+self.h+1+self.h+1+self.h+1+self.h+1, GZDeviceWidth/3, self.h)];
    jiedongLabel5.text=@"持币总量";
    jiedongLabel5.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];
    [self.view addSubview:jiedongLabel5];
    
    float floatstr=[_str5 floatValue];
    UILabel *jiedongnumLabel5=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth*7/10, StatusbarHeight+44+10+self.h+1+self.h+1+self.h+1+self.h+1, GZDeviceWidth*4/5, self.h)];
    jiedongnumLabel5.text=[NSString stringWithFormat:@"%.3f", floatstr];
    jiedongnumLabel5.font=[UIFont systemFontOfSize:4+GZDeviceWidth/35];
    jiedongnumLabel5.textColor=[UIColor darkGrayColor];
    [self.view addSubview:jiedongnumLabel5];
    
    UIView *view5=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44+10+self.h+1+self.h+1+self.h+1+self.h+1+self.h, GZDeviceWidth, 1)];
    view5.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view5];
    
    // Do any additional setup after loading the view.
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
