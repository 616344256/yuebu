//
//  AppDelegate.m
//  全民约步
//
//  Created by 姜祺 on 17/6/2.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideMenuController.h"
#import "LeftViewController.h"
#import "MainViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
#import <IQKeyboardManager.h>
#import "MMPDeepSleepPreventer.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"1e885fa3e7cda"
     
          activePlatforms:@[@(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxa578caef273d2a00"
                                       appSecret:@"d4866b72c4e0870a2644a84965a5ac8e"];
                 break;
        
             default:
                 break;
         }
     }];
    
    [AMapServices sharedServices].apiKey = @"436d6af77ef0c92638c44524326a430a";
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    LeftViewController *leftVC = [[LeftViewController alloc]init];
    MainViewController *mainVC = [[MainViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:mainVC];
    leftVC.mainViewControler = nvc;
    SlideMenuController *slideMenuController = [[SlideMenuController alloc] initWithMainViewController:nvc leftMenuViewController:leftVC rightMenuViewController:nil];
    slideMenuController.automaticallyAdjustsScrollViewInsets = YES;
    slideMenuController.delegate = mainVC;
    self.window.rootViewController = slideMenuController;
    [self.window makeKeyWindow];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //播放一段无声音乐,避免被kill
    [[MMPDeepSleepPreventer sharedSingleton] startPreventSleep];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
