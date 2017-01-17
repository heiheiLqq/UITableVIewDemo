//
//  AppDelegate.m
//  UITableVIewDemo
//
//  Created by zzh on 2017/1/16.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZHShopTableViewController.h"
#import "ZZHCircleTableViewController.h"
#import "ZZHFriendTableViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    UITabBarController * tabbar = [[UITabBarController alloc]init];
    

    ZZHFriendTableViewController * vc1 = [[ZZHFriendTableViewController alloc] initWithNibName:@"ZZHFriendTableViewController" bundle:nil];
    vc1.title = @"好友列表";
    UINavigationController * naVc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    
    ZZHCircleTableViewController * vc2 = [[ZZHCircleTableViewController alloc] initWithNibName:@"ZZHCircleTableViewController" bundle:nil];
    vc2.title = @"朋友圈";
    UINavigationController * naVc2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    
    ZZHShopTableViewController * vc3 = [[ZZHShopTableViewController alloc] initWithNibName:@"ZZHShopTableViewController" bundle:nil];
    vc3.title = @"购物车";
    UINavigationController * naVc3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    
    tabbar.viewControllers = [NSArray arrayWithObjects: naVc1, naVc2,naVc3, nil];
    self.window.rootViewController = tabbar;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
