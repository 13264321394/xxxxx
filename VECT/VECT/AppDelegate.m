//
//  AppDelegate.m
//  VECT
//
//  Created by 方墨 on 2018/5/3.
//  Copyright © 2018年 方墨. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "firstViewController.h"
#import "secondViewController.h"
#import "fourViewController.h"
#import "thirdViewController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:1.0f];//设置启动图片持续的时间长短
    
    // AppDelegate 进行全局设置。凡是Scrollview 及 Scrollview子类都会有适配问题，整个工程使用了无数Scrollview的你心理阴影面积一定不小，别担心，其实可以一行代码解决问题：
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        //self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //NSString *Mark = [userDefaults stringForKey:@"myString"];
    
    //if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"] isEqualToString:@"islogin"])
    //if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"MarkString"] isEqualToString:@"1"])
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"] isEqualToString:@"islogin"])
    {
        //去主界面
        firstViewController *fir=[[firstViewController alloc] init];
        UINavigationController *firNav=[[UINavigationController alloc] initWithRootViewController:fir];
        firNav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"明细"image:[UIImage imageNamed:@"VECT-04.png"] tag:1000];
        // 提示信息
        //firNav.tabBarItem.badgeValue= @"99..";
        
        secondViewController *sec = [[secondViewController alloc]init];
        UINavigationController *secNav = [[UINavigationController alloc]initWithRootViewController:sec];
        secNav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"资产"image:[UIImage imageNamed:@"VECT-05.png"] tag:1001];
        //secNav.tabBarItem.badgeValue= @"new";
        
        thirdViewController *third = [[thirdViewController alloc]init];
        UINavigationController *thirdNav = [[UINavigationController alloc]initWithRootViewController:third];
        thirdNav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"我的"image:[UIImage imageNamed:@"VECT-06.png"] tag:1002];
        //thirdNav.tabBarItem.badgeValue= @"99++";
        
        fourViewController *four=[[fourViewController alloc] init];
        UINavigationController *fourNav=[[UINavigationController alloc] initWithRootViewController:four];
        fourNav.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"VECTfound1.png"] tag:1003];
        
        UITabBarController *tabBars=[[UITabBarController alloc] init];
        tabBars.tabBar.barTintColor=[UIColor whiteColor];
        tabBars.tabBar.translucent=NO;
        //tabBars.tabBar.tintColor=[UIColor blueColor];
        
        tabBars.viewControllers= [NSArray arrayWithObjects:secNav,firNav,fourNav,thirdNav,nil];
        self.window.rootViewController= tabBars;
        
    } else {
        //去登录界面
        LoginViewController *login=[[LoginViewController alloc] init];
        self.window.rootViewController=login;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti1) name:@"noti1" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti2) name:@"noti2" object:nil];
    
    // Override point for customization after application launch.
    return YES;

}

/*
-(void)noti2
{
    LoginViewController *login=[[LoginViewController alloc] init];
    self.window.rootViewController=login;
}
*/
 
-(void)noti1
{
    //NSLog(@"接收 不带参数的消息");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //去主界面
        firstViewController *fir=[[firstViewController alloc] init];
        UINavigationController *firNav=[[UINavigationController alloc] initWithRootViewController:fir];
        firNav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"明细" image:[UIImage imageNamed:@"VECT-04.png"] tag:1000];
        // 提示信息
        //firNav.tabBarItem.badgeValue= @"99..";
        
        secondViewController *sec = [[secondViewController alloc]init];
        UINavigationController *secNav = [[UINavigationController alloc]initWithRootViewController:sec];
        secNav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"资产" image:[UIImage imageNamed:@"VECT-05.png"] tag:1001];
        //secNav.tabBarItem.title=@"明细";
        //secNav.tabBarItem.image=[UIImage imageNamed:@"VECTqw.png"];
        //secNav.tabBarItem.badgeValue= @"new";
        
        thirdViewController *third = [[thirdViewController alloc]init];
        UINavigationController *thirdNav = [[UINavigationController alloc]initWithRootViewController:third];
        thirdNav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"我的"image:[UIImage imageNamed:@"VECT-06.png"] tag:1002];
        //thirdNav.tabBarItem.badgeValue= @"99++";
        
        fourViewController *four=[[fourViewController alloc] init];
        UINavigationController *fourNav=[[UINavigationController alloc] initWithRootViewController:four];
        fourNav.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"VECTfound1.png"] tag:1003];
        
        UITabBarController *tabBars=[[UITabBarController alloc] init];
        tabBars.tabBar.barTintColor=[UIColor whiteColor];
        tabBars.tabBar.translucent=NO;
        //tabBars.tabBar.tintColor=[UIColor blueColor];
        
        tabBars.viewControllers= [NSArray arrayWithObjects:secNav,firNav,fourNav,thirdNav,nil];
        self.window.rootViewController= tabBars;
        
        //[[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
        
        //tabBars.delegate= self;
        //NSLog(@"跳转完成");
        
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"退出后台1");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"退出后台2");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"进入前台");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"退出后台4");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"进程杀死时会调用这个");
}


@end

