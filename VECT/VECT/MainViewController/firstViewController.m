//
//  firstViewController.m
//  VECT
//
//  Created by 方墨 on 2018/5/3.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "firstViewController.h"
#import "ATAddAritsViewController.h"
#import "ATUpdateInfoViewController.h"
#import "ATSQLManager.h"
#import "intodetailViewController.h"
#import "rolloutdetailViewController.h"
#import "regularViewController.h"
#import "returnsViewController.h"
#import "thawViewController.h"
#import "communitymemberViewController.h"
#import "Masonry.h"

@interface firstViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITextField * nameTF ;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * artists ;

@property(nonatomic,retain)NSArray *dataList;
@property(nonatomic,strong)UITableView *myTableView;

@end

@implementation firstViewController

-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myphone=[userDefaults stringForKey:@"mymobile"];
    
    if ([myphone isEqualToString:@"13264321394"]) {
      
        [super viewWillAppear:animated];
        ATSQLManager *sqlManager = [ATSQLManager shareSQLManager];
        self.artists = [sqlManager getAllArtistsArrayFromDateBase];
        if (self.artists.count>0) {
            [self.tableView reloadData];
        }
    }
}

-(NSMutableArray *)artists{
    if (!_artists) {
        _artists = [NSMutableArray array];
    }
    return _artists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title = @"明细";
  self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myphone=[userDefaults stringForKey:@"mymobile"];
    NSLog(@"我的手机号==%@", myphone);
    
    if ([myphone isEqualToString:@"13264321394"]) {
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn] ;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshDataClick)];
        
        UIView *myView=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, 1)];
        myView.backgroundColor=[UIColor grayColor];
        [self.view addSubview:myView];
        
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44+1, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44+1+49)) style:UITableViewStylePlain];
        
        if (StatusbarHeight==44) {
            tableView.frame=CGRectMake(0, StatusbarHeight+44+1, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44+1+49+37));
        } else {
            tableView.frame=CGRectMake(0, StatusbarHeight+44+1, GZDeviceWidth, GZDeviceHeight-(StatusbarHeight+44+1+49));
        }
        
        //tableView.pagingEnabled=YES;
        tableView.showsVerticalScrollIndicator=NO;
        //tableView.bounces=YES;
        //tableView.backgroundColor=[UIColor redColor];
        //[tableView setSeparatorColor:[UIColor redColor]];
        // 设置tableView的数据源
        tableView.dataSource = self;
        // 设置tableView的委托
        tableView.delegate = self;
        // 设置tableView的背景图
        //tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
        [self.view addSubview:tableView];
        self.tableView = tableView;
        self.tableView.tableFooterView = [[UIView alloc] init];
    } else {
        UIView *grayView=[[UIView alloc] init];
        grayView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [self.view addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(StatusbarHeight+44);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, GZDeviceHeight-StatusbarHeight-44));
        }];
        
        UIView *myView=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, GZDeviceHeight/4)];
        myView.backgroundColor=[UIColor colorWithRed:19/255.0 green:163/255.0 blue:242/255.0 alpha:1.0];
        [self.view addSubview:myView];
        
        UILabel *myLabel1=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, (GZDeviceHeight/4-GZDeviceHeight/4/3)/2-GZDeviceHeight/4/8, GZDeviceWidth/2, GZDeviceHeight/4/3)];
        myLabel1.text=@"我的资产明细";
        myLabel1.textColor=[UIColor whiteColor];
        //myLabel1.backgroundColor=[UIColor cyanColor];
        myLabel1.font=[UIFont systemFontOfSize:15+GZDeviceWidth/30.f];
        [myView addSubview:myLabel1];
        
        UILabel *myLabel2=[[UILabel alloc] initWithFrame:CGRectMake(GZDeviceWidth/20, GZDeviceHeight/4/2, GZDeviceWidth/3, GZDeviceHeight/4/6)];
        myLabel2.text=@"The detail";
        myLabel2.textColor=[UIColor whiteColor];
        myLabel2.font=[UIFont systemFontOfSize:5+GZDeviceWidth/40.f];
        [myView addSubview:myLabel2];
        
        UIImageView *myImageView=[[UIImageView alloc] initWithFrame:CGRectMake(GZDeviceWidth*3/5.3, GZDeviceHeight/4/2/2, GZDeviceHeight/4/2*1.5, GZDeviceHeight/4/2)];
        myImageView.image=[UIImage imageNamed:@"VECTbag.png"];
        [myView addSubview:myImageView];
        
        NSArray *list = [NSArray arrayWithObjects:@"转入明细",@"转出明细",@"定期明细",@"收益明细",@"解冻明细",@"社区会员明细", nil];
        self.dataList = list;
        
        NSLog(@"数组%@datalist",self.dataList);
        
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44+GZDeviceHeight/5, GZDeviceWidth, GZDeviceHeight) style:UITableViewStylePlain];
        tableView.pagingEnabled=YES;
        tableView.showsVerticalScrollIndicator=NO;
        tableView.bounces=YES;
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        //tableView.backgroundColor=[UIColor redColor];
        //[tableView setSeparatorColor:[UIColor redColor]];
        // 设置tableView的数据源
        tableView.dataSource = self;
        // 设置tableView的委托
        tableView.delegate = self;
        // 设置tableView的背景图
        //tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
        self.myTableView = tableView;
        [self.view addSubview:_myTableView];
        [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(StatusbarHeight+44+GZDeviceHeight/5);
            make.size.mas_equalTo(CGSizeMake(GZDeviceWidth, 6*(30+GZDeviceHeight/30)));
        }];
        self.myTableView.tableFooterView = [[UIView alloc] init];//去掉没有内容的cell
        
        // 新API：`@available(iOS 11.0, *)` 可用来判断系统版本
        if ( @available(iOS 11.0, *) ) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        //iOS11之后不仅要实现代理方法heightForHeaderInSection / heightForFooterInSection，还要实现代理方法viewForHeaderInSection / viewForFooterInSection才能去掉间距。或者添加以下代码关闭高度估算，问题也能解决。
        //self.myTableView.estimatedRowHeight = 0;
        //self.myTableView.estimatedSectionHeaderHeight = 0;
        //self.myTableView.estimatedSectionFooterHeight = 0;
        
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)addBtnClick{
    ATAddAritsViewController *addVc = [[ATAddAritsViewController alloc]init];
    
    [self presentViewController:addVc animated:YES completion:nil];
}

//刷新数据
-(void)refreshDataClick{
    //
    ATSQLManager *sqlManager = [ATSQLManager shareSQLManager];
    self.artists = [sqlManager getAllArtistsArrayFromDateBase];
    if (self.artists.count>0) {
        [self.tableView reloadData];
        NSLog(@"刷新了列表数据");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIView *myView=[[UIView alloc] initWithFrame:self.view.frame];
            myView.backgroundColor=[UIColor whiteColor];
            myView.alpha=0.8f;
            [self.view addSubview:myView];
            
            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*2.1/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
            theLabel.backgroundColor=[UIColor blackColor];
            theLabel.layer.cornerRadius = 5.f;
            theLabel.clipsToBounds = YES;
            theLabel.textColor=[UIColor whiteColor];
            //theLabel.alpha=1.0f;
            theLabel.textAlignment=NSTextAlignmentCenter;
            theLabel.font=[UIFont systemFontOfSize:15.f];
            theLabel.text=@"成功刷新数据";
            [myView addSubview:theLabel];
            //设置动画
            CATransition *transion=[CATransition animation];
            transion.type=@"push";//动画方式
            transion.subtype=@"fromRight";//设置动画从哪个方向开始
            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
            //不占用主线程
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                
                [myView removeFromSuperview];
                [theLabel removeFromSuperview];
            });//这句话的意思是1.5秒后，把label移出视图
        });
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIView *myView=[[UIView alloc] initWithFrame:self.view.frame];
            myView.backgroundColor=[UIColor whiteColor];
            myView.alpha=0.8f;
            [self.view addSubview:myView];
            
            UILabel *theLabel=[[UILabel alloc] initWithFrame:CGRectMake((GZDeviceWidth-GZDeviceWidth/2)/2, GZDeviceHeight*2.1/5, GZDeviceWidth/2, 20+GZDeviceHeight/25)];
            theLabel.backgroundColor=[UIColor blackColor];
            theLabel.layer.cornerRadius = 5.f;
            theLabel.clipsToBounds = YES;
            theLabel.textColor=[UIColor whiteColor];
            //theLabel.alpha=1.0f;
            theLabel.textAlignment=NSTextAlignmentCenter;
            theLabel.font=[UIFont systemFontOfSize:15.f];
            theLabel.text=@"没有可以刷新的数据";
            [myView addSubview:theLabel];
            //设置动画
            CATransition *transion=[CATransition animation];
            transion.type=@"push";//动画方式
            transion.subtype=@"fromRight";//设置动画从哪个方向开始
            [theLabel.layer addAnimation:transion forKey:nil];//给layer添加动画。设置延时效果
            //不占用主线程
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                
                [myView removeFromSuperview];
                [theLabel removeFromSuperview];
            });//这句话的意思是1.5秒后，把label移出视图
        });
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myphone=[userDefaults stringForKey:@"mymobile"];
    
    NSInteger mycount;
    
    if ([myphone isEqualToString:@"13264321394"]) {
        mycount=self.artists.count;
    } else {
        mycount=self.dataList.count;
    }
    
    return mycount;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myphone=[userDefaults stringForKey:@"mymobile"];
    
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if ([myphone isEqualToString:@"13264321394"]) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
        }
        ATAtist *artist = self.artists[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"姓名： %@",artist.name];
        cell.textLabel.font=[UIFont systemFontOfSize:20.f];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"明细：%@", artist.age];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:17.f];
        
        cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WechatIMGd3.png"]];//给cell设置背景图片
        // Configure the cell...
    } else {
        
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
        cell.textLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/32];//改变cell上字体大小
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.imageView.image = [UIImage imageNamed:@"green.png"];
        //cell.textLabel.adjustsFontSizeToFitWidth=NO;//cell字体自动适应大小
        //cell.textLabel.font=[UIFont systemFontOfSize:20.0f];//改变cell上字体大小
        //cell.textLabel.highlightedTextColor=[UIColor redColor];//点击cell后cell上字体变的颜色
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击cell时，cell的颜色不改变
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myphone=[userDefaults stringForKey:@"mymobile"];
    
    CGFloat height;
    
    if ([myphone isEqualToString:@"13264321394"]) {
       height=30+GZDeviceHeight/12;
    } else {
        height=30+GZDeviceHeight/30;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//解决点击cell时延时的问题
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myphone=[userDefaults stringForKey:@"mymobile"];
    
    if ([myphone isEqualToString:@"13264321394"]) {
        ATAtist *artist = self.artists[indexPath.row];
        ATUpdateInfoViewController *updateVc = [[ATUpdateInfoViewController alloc]init];
        updateVc.artist = artist;//属性传值
        [self presentViewController:updateVc animated:YES completion:nil];
    } else {
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
    }
}

//table的删除操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myphone=[userDefaults stringForKey:@"mymobile"];
    
    if ([myphone isEqualToString:@"13264321394"]) {
        ATAtist *artist = self.artists[indexPath.row];
        ATSQLManager *sqlManager = [ATSQLManager shareSQLManager];
        //删除一条艺术家信息
        [sqlManager deleteArtistInfoWithID:artist.id];
        [self.artists removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *deleStr;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myphone=[userDefaults stringForKey:@"mymobile"];
    
    if ([myphone isEqualToString:@"13264321394"]) {
        deleStr=@"删除";
    }
    
    return deleStr;
}

-(void)backClick
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
