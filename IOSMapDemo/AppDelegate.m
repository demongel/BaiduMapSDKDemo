//
//  AppDelegate.m
//  IOSMapDemo
//
//  Created by XHVR on 2017/7/14.
//  Copyright © 2017年 XHVR. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
@interface AppDelegate ()
@property (strong,nonatomic) BMKMapManager* mapManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，输入自己申请的key
    BOOL ret = [_mapManager start:@"zg4WMGjsZnpqf9rP3qZm4q3RcCWM3sOx"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

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
