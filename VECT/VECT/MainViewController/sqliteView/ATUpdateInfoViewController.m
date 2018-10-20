//
//  ATUpdateInfoViewController.m
//  Sqlite3Demo
//
//  Created by 海修杰 on 17/1/10.
//  Copyright © 2017年 qizhiwenhua. All rights reserved.
//

#import "ATUpdateInfoViewController.h"
#import "ATSQLManager.h"
#import "Masonry.h"

#define DEF_DEVICE_WIDTH                [UIScreen mainScreen].bounds.size.width
#define DEF_DEVICE_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define DEF_RESIZE_UI(float)            ((float)/375.0f*DEF_DEVICE_WIDTH)

@interface ATUpdateInfoViewController ()

@property (nonatomic,strong) UITextField * nameTF ;
@property (nonatomic,strong) UITextField * ageTF ;

@end

@implementation ATUpdateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *forgetPawLabel=[[UILabel alloc] init];
    forgetPawLabel.text=@"更新";
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
    
    [self initUI];
    // Do any additional setup after loading the view.
}

-(void)backMethod
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//保存按钮
-(void)saveBtnClick{
    if (self.nameTF.text.length&&self.ageTF.text.length) {
        ATSQLManager *sqlManager = [ATSQLManager shareSQLManager];
        ATAtist *artist = [[ATAtist alloc]init];
        artist.name = self.nameTF.text;
        artist.age  = self.ageTF.text;
        artist.id = self.artist.id;
        [sqlManager updateArtistInfoWithArtist:artist];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)initUI{
    CGFloat titleLbW = DEF_RESIZE_UI(50);
    CGFloat titleTFW = DEF_DEVICE_WIDTH-2*DEF_RESIZE_UI(20)- titleLbW;
    CGFloat rowH = DEF_RESIZE_UI(44);
    
    /*
    self.navigationItem.title = @"修改艺术家";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    */
    
    UIButton *backbutton1=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth-70, StatusbarHeight+7, 60, 30)];
    [backbutton1 setTitle:@"保存" forState:UIControlStateNormal];
    backbutton1.titleLabel.font=[UIFont systemFontOfSize:13.f];
    [backbutton1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backbutton1 addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton1];
    
    UIView *myView=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, 1)];
    myView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:myView];
    
    //姓名
    UILabel *nameLb = [[UILabel alloc]init];
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.textColor = [UIColor blackColor];
    nameLb.font = [UIFont systemFontOfSize:15];
    nameLb.frame = CGRectMake(DEF_RESIZE_UI(20), DEF_RESIZE_UI(80)+65, titleLbW, rowH);
    nameLb.text = @"姓名";
    [self.view addSubview:nameLb];
    
    UITextField *nameTF = [[UITextField alloc]init];
    self.nameTF = nameTF;
    nameTF.text = self.artist.name;
    nameTF.layer.borderColor = [UIColor grayColor].CGColor;
    nameTF.layer.borderWidth = 1;
    nameTF.backgroundColor = [UIColor whiteColor];
    nameTF.placeholder = @"请输入姓名";
    nameTF.textColor = [UIColor blackColor];
    nameTF.font = [UIFont systemFontOfSize:15];
    nameTF.frame = CGRectMake(CGRectGetMaxX(nameLb.frame), DEF_RESIZE_UI(80)+65, titleTFW, rowH);
    [self.view addSubview:nameTF];
    //
    //年龄
    
    UILabel *ageLb = [[UILabel alloc]init];
    ageLb.textAlignment = NSTextAlignmentLeft;
    ageLb.textColor = [UIColor blackColor];
    ageLb.font = [UIFont systemFontOfSize:15];
    ageLb.frame = CGRectMake(DEF_RESIZE_UI(20), CGRectGetMaxY(nameLb.frame)+DEF_RESIZE_UI(10), titleLbW, rowH);
    ageLb.text = @"明细";
    [self.view addSubview:ageLb];
    
    UITextField *ageTF = [[UITextField alloc]init];
    self.ageTF = ageTF;
    ageTF.text = self.artist.age;
    ageTF.layer.borderWidth = 1;
    ageTF.layer.borderColor = [UIColor grayColor].CGColor;
    ageTF.placeholder = @"请输入明细";
    ageTF.backgroundColor = [UIColor whiteColor];
    ageTF.textColor = [UIColor blackColor];
    ageTF.font = [UIFont systemFontOfSize:15];
    ageTF.frame = CGRectMake(CGRectGetMaxX(ageLb.frame), CGRectGetMaxY(nameLb.frame)+DEF_RESIZE_UI(10), titleTFW, rowH);
    [self.view addSubview:ageTF];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end




