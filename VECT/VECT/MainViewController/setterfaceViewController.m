//
//  setterfaceViewController.m
//  VECT
//
//  Created by 方墨 on 2018/7/4.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "setterfaceViewController.h"
#import "Masonry.h"

@interface setterfaceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic,retain)NSArray *dataList;
@property(nonatomic,copy)NSString *cachStr;

@end

@implementation setterfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, GZDeviceWidth, StatusbarHeight+44)];
    //view1.backgroundColor=[UIColor colorWithRed:237/255.0 green:59/255.0 blue:87/255.0 alpha:1.0f];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    
    UILabel *forgetPawLabel=[[UILabel alloc] init];
    forgetPawLabel.text=@"设置";
    forgetPawLabel.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:forgetPawLabel];
    [forgetPawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusbarHeight);
        make.left.mas_equalTo(GZDeviceWidth/4);
        make.size.mas_equalTo(CGSizeMake(GZDeviceWidth/2, 44));
    }];
    
    UIButton *backbutton=[[UIButton alloc] initWithFrame:CGRectMake(GZDeviceWidth/50, StatusbarHeight+7, 18, 30)];
    [backbutton setImage:[UIImage imageNamed:@"返回 copy.png"] forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:backbutton];
    
    UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(0, StatusbarHeight+44, GZDeviceWidth, 10)];
    view2.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view2];
    
    
    NSArray *list = [NSArray arrayWithObjects:@"清除缓存",@"软件版本",nil];
    self.dataList = list;
    
    
    self.tableView=[[UITableView alloc] init];
    if (StatusbarHeight==44) {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,StatusbarHeight+44+10,GZDeviceWidth,GZDeviceHeight-StatusbarHeight-44-34-10) style:UITableViewStylePlain];
    } else {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,StatusbarHeight+44+10,GZDeviceWidth,GZDeviceHeight-StatusbarHeight-44-10) style:UITableViewStylePlain];
    }
    
    self.tableView.pagingEnabled=YES;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.bounces=YES;
 self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    //最重要的就是代理了
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //如果出现偏移64的问题，还需添加这段代码
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
    
    // Do any additional setup after loading the view.
}

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30+GZDeviceHeight/28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    
    if (indexPath.row==0) {
        cell.textLabel.text = @"清除缓存";
        cell.textLabel.font = [UIFont systemFontOfSize:5+GZDeviceWidth/32];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.1f M",[self filePath]];
        self.cachStr=[NSString stringWithFormat:@"%.1f M",[self filePath]];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/35];
    } else if (indexPath.row==1) {
        cell.textLabel.text = @"软件版本";
        cell.textLabel.font = [UIFont systemFontOfSize:5+GZDeviceWidth/32];
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@", currentVersion];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:5+GZDeviceWidth/35];
        
        
    }
    /*
    else if (indexPath.row==1) {
        cell.textLabel.text = @"关于我们";
    } else if (indexPath.row==2) {
        cell.textLabel.text = @"意见反馈";
    } else if (indexPath.row==3) {
        cell.textLabel.text = @"系统检测";
    } else if (indexPath.row==4) {
        cell.textLabel.text = @"给个好评";
    } else if (indexPath.row==5) {
        cell.textLabel.text = @"关注微信";
    } else if (indexPath.row==6) {
        cell.textLabel.text = @"欢迎页";
    } else if (indexPath.row==7) {
        cell.textLabel.text = @"联系电话";
    }
    */
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击cell时，cell的颜色不改变
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//加了这句后cell后面自动出现>
    
    return cell;
}

//点击单元格触发该方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//解决点击cell时延时的问题
    
    if (indexPath.row==0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您确定要清除%@缓存吗？",self.cachStr]  preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [self clearFile];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:action];
        [alert addAction:cancel];
        [self showDetailViewController:alert sender:nil];
        
    }
    /*
    else if (indexPath.row==1) {
        
        aboutusViewController *as=[[aboutusViewController alloc] init];
        [self presentViewController:as animated:YES completion:nil];
    } else if (indexPath.row==2) {
        
        UserFeedBackViewController *uf=[[UserFeedBackViewController alloc] init];
        [self presentViewController:uf animated:YES completion:nil];
    } else if (indexPath.row==3) {
        systemtestingViewController *sys=[[systemtestingViewController alloc] init];
        [self presentViewController:sys animated:YES completion:nil];
    } else if (indexPath.row==4) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1078688750"]];
        
        //1. 跳转到应用评价页
        //NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", @"1078688750"];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        
        //2. 跳转到应用详情页
        //NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", APPID];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        //appid是在iTunesConnect创建应用时自动生成的ID
    } else if (indexPath.row==5) {
        focusWeChatViewController *fw=[[focusWeChatViewController alloc] init];
        [self presentViewController:fw animated:YES completion:nil];
    } else if (indexPath.row==6) {
        [self.view addSubview:self.pageControlV];//打开欢迎页
    } else if (indexPath.row==7) {
        UIWebView *callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"13264321394"]];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }
    */
}

// 显示缓存大小
-( float )filePath
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [self folderSizeAtPath :cachPath];
}

//1:首先我们计算一下 单个文件的大小
-(long)fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
}

//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）
- (float) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0);
}

// 清理缓存
- (void)clearFile
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [ self performSelectorOnMainThread:@selector(clearCachSuccess) withObject:nil waitUntilDone:YES ];
}

//清理成功提示
-(void)clearCachSuccess
{
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];//刷新一行
    //刷新清除缓存后的展示
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"成功清除所有缓存!"  preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
    }];
    
    [alert addAction:action];
    [self showDetailViewController:alert sender:nil];
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
