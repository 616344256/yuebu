//
//  BaseViewController.m
//  TianjinBoHai
//
//  Created by 李莹 on 15/1/9.
//  Copyright (c) 2015年 Binky Lee. All rights reserved.
//

#import "BaseViewController.h"

#import "Config.h"
//#import "TBCityIconFont.h"
//#import "UIImage+TBCityIconFont.h"
//#import "NullDataView.h"

@import QuartzCore;

@interface BaseViewController ()
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property(nonatomic, strong) UIView *showView;
@property(nonatomic, strong) UIView *backGroundView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //监听网络方法
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
//    self.conn = [Reachability reachabilityForInternetConnection];
//    [self.conn startNotifier];
    
//    //去掉navagationbar底部黑线
//    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//        NSArray *list=self.navigationController.navigationBar.subviews;
//        for (id obj in list) {
//            if ([obj isKindOfClass:[UIImageView class]]) {
//                UIImageView *imageView=(UIImageView *)obj;
//                NSArray *list2=imageView.subviews;
//                for (id obj2 in list2) {
//                    if ([obj2 isKindOfClass:[UIImageView class]]) {
//                        UIImageView *imageView2=(UIImageView *)obj2;
//                        imageView2.hidden=YES;
//                    }
//                }
//            }
//        }
//    }
    
    self.view.backgroundColor = getColor(grayColor);
    
    [self.navigationController.navigationBar setBarTintColor:getColor(@"44464e")];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    UIColor * color = getColor(orangeColor);
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg"] forBarMetrics:UIBarMetricsDefault];
    
   
    
}

//- (void) showMessage:(NSString*)message{
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
////    [alert show];
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
////    });
//    //第一种方法取Windows，通过数组取，如果不是只有一个那就不好用了
//    //UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
//    
//    //第二种方法取Windows，通过代理取
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    UIWindow * window = appDelegate.window;
//    
//    UIView *showview =  [[UIView alloc]init];
//    showview.backgroundColor = [UIColor grayColor];
//    showview.alpha = 1.0f;
//    showview.layer.cornerRadius = 5.0f;
//    showview.layer.masksToBounds = YES;
//    [window addSubview:showview];
//    
//    UILabel *label = [[UILabel alloc]init];
//    CGRect rectSize = [message boundingRectWithSize:CGSizeMake(290, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:Nil];
//    CGSize LabelSize = rectSize.size;
//    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
//    label.text = message;
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = 1;
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:15];
//    [showview addSubview:label];
//    
//    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width - 20)/2, SCREEN_HEIGHT/2, LabelSize.width+20, LabelSize.height+10);
//    
//    [UIView animateWithDuration:3 animations:^{
//        showview.alpha = 0;
//    }
//                     completion:^(BOOL finished){
//                         [showview removeFromSuperview];
//                     }];
//
//}
- (void)showMessage:(NSString*)message{

    _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    _backGroundView.backgroundColor = [UIColor redColor];
    [self.navigationController.view addSubview:_backGroundView];
    
    UITapGestureRecognizer *singelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss:)];
    [_backGroundView addGestureRecognizer:singelTap];
    
    _showView = [[UIView alloc]init];
    _showView.backgroundColor = [getColor(@"e1f9ef")colorWithAlphaComponent:1];
    _showView.layer.cornerRadius = 7;
    [self.navigationController.view addSubview:_showView];
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.text = message;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.layer.masksToBounds = YES;
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.textColor = [UIColor blackColor];
    promptLabel.font = DEF_FontSize_14;
    promptLabel.numberOfLines = 0;
    
    CGSize labelsize = [message boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil].size;
    
    
    promptLabel.frame = CGRectMake(25, 12.5, 200, labelsize.height);
    _showView.frame = CGRectMake(0, 0, 250, labelsize.height+25);
    _showView.center = self.navigationController.view.center;
    
    [_showView addSubview:promptLabel];
    
    [UIView animateWithDuration:2.0 animations:^{
        _showView.alpha=0;
    } completion:^(BOOL finished) {
        [_showView removeFromSuperview];
        [_backGroundView removeFromSuperview];
        [_backGroundView removeGestureRecognizer:singelTap];
    }];
}

-(void)dismiss:(id)sender{
    
    [_showView removeFromSuperview];
    [_backGroundView removeFromSuperview];
}


- (void)saveTheDataToCachesWithData:(id)data toThePlistFile:(NSString *)fileName
{
    //获取沙盒目录，PS，这里包括以下目录均为Caches，可以修改的
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSLog(@"==%@",paths);
    NSString *docDir = [paths objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Caches 目录未找到");
        return;
    }
    NSArray *array = [[NSArray alloc] initWithObjects:data,nil];
    NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    [array writeToFile:filePath atomically:YES];
}

- (NSArray *)readTheDataFromCachesFromPlistFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
    return array;
}

- (void) showError:(NSError*)error{
    switch (error.code) {
        case NSURLErrorNotConnectedToInternet:
            [self showMessage:@"请检查您的网络"];
            break;
        case NSURLErrorTimedOut:
            [self showMessage:@"请求超时，请查看您的网络"];
            break;
        case NSURLErrorCannotConnectToHost:
            [self showMessage:@"服务器繁忙，请稍后再试"];
            break;
        case NSURLErrorNetworkConnectionLost:
            [self showMessage:@"处理过程中网络中断，请重试"];
            break;
        default:
            [self showMessage:@"网络错误"];
            break;
    }
}

- (void) failureWithCode:(NSString*)code message:(NSString*)message{
    NSLog(@"code:%@,message:%@",code,message);
}

- (MBProgressHUD *)progressHUD {
   if (!_progressHUD) {
      
      _progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
   }
   return _progressHUD;
}

-(void)showprogressHUD{
    
    //    [self.view addSubview:_progressHUD];
    //    [self.view bringSubviewToFront:_progressHUD];
    //    [self.view insertSubview:_progressHUD atIndex:0];
    [self.navigationController.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
}

-(void)hiddenProgressHUD{
    [self.progressHUD hide:YES];
    [self.progressHUD removeFromSuperview];
}

#pragma mark - Reachability

//-(void) dealloc{
//    [self.conn stopNotifier];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

//-(void) networkStateChange{
//    [self checkNetworkState];
//}

//- (void)checkNetworkState{
//    
//    // 1.检测wifi状态
//    
//    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
//    
//    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
//    
//    Reachability *conn = [Reachability reachabilityForInternetConnection];
//    
//    // 3.判断网络状态
//    if ([wifi currentReachabilityStatus] != NotReachable) {
//        // 有wifi
//        NSLog(@"有wifi");
//        [self showMessage:@"wifi已连接"];
//    } else if ([conn currentReachabilityStatus] != NotReachable) {
//        // 没有使用wifi, 使用手机自带网络进
//         [self showMessage:@"手机网络已连接"];
//        NSLog(@"使用手机自带网络进行上网");
//     } else {
//         // 没有网络
//          [self showMessage:@"网络已断开请检查网络"];
//         NSLog(@"没有网络");
//    }
//}

//-(void)nullDataViewMethos{
//    
//    if (!self.nullDataView) {
//        
//        self.nullDataView = [[NullDataView alloc] initNullViewWithFrame:self..bounds andImage:[UIImage imageNamed:@"dataEmpty"] andDescription:@"哎呀，你还没有订单噢~~"];
//        self.nullDataView.desTextColor = getColor(blackColor);
//        self.nullDataView.desTextFont = DEF_FontSize_12;
//        self.nullDataView.backgroundColor = [UIColor whiteColor];
//        self.nullDataView.imageCenter = - 100;
//        [self.tableView addSubview:self.nullDataView];
//    }
//}

@end
