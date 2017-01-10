//
//  AppDelegate.m
//  FindBusiness
//
//  Created by 星空浩 on 2016/12/28.
//  Copyright © 2016年 DFYG_YF3. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNaviController.h"
#import "WebViewController.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#define BaiduKey @"KzS8feqrC50kyiyxk9tGapMLWy72DwGD"

@interface AppDelegate ()<BMKGeneralDelegate>{
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setBaiduSDK];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)setBaiduSDK
{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BaiduKey generalDelegate:self];
    if (!ret) {
        NSLog(@"baidumap start failed!");
    }
}

-(void)setupUI
{
    BaseNaviController *navi = [[BaseNaviController alloc]initWithRootViewController:[[WebViewController alloc]init]];
    [self.window setRootViewController:navi];
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
