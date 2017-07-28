//
//  BaseTableViewController.m
//  SunyardFinance
//
//  Created by 李莹 on 15/8/25.
//  Copyright (c) 2015年 Blue Mobi. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MBProgressHUD.h"
#import "Config.h"


@interface BaseTableViewController ()
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property(nonatomic, strong) UIView *showView;
@property(nonatomic, strong) UIView *backGroundView;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = getColor(grayColor);
    
    [self.navigationController.navigationBar setBarTintColor:getColor(@"44464e")];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIColor * color = getColor(orangeColor);
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg"] forBarMetrics:UIBarMetricsDefault];
   
    
   
    self.navigationController.navigationBar.translucent = NO;
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    
    [self.view addSubview:_progressHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void) showMessage:(NSString*)message{
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
////    [alert show];
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
//    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width - 20)/2, SCREEN_HEIGHT - 100, LabelSize.width+20, LabelSize.height+10);
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


- (void) darkOrangeButtonAttribute:(UIButton*)button{
    [button setBackgroundColor:getColor(orangeColor)];
    [button.layer setCornerRadius:5];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
}

- (BOOL)shouldAutorotate{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

-(UILabel*)showPromptBox:(NSString *)message{
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 75, SCREEN_HEIGHT / 2.0 - 60, 150, 20)];
    promptLabel.text = message;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.layer.cornerRadius = 3;
    promptLabel.layer.masksToBounds = YES;
//    promptLabel.backgroundColor = getColor(blueColor);
    promptLabel.textColor = [UIColor whiteColor];
//    promptLabel.font = DEF_FontSize_14;
    
    [UIView animateWithDuration:3.0 animations:^{
        promptLabel.alpha=0;
    } completion:^(BOOL finished) {
        [promptLabel removeFromSuperview];
    }];
    return promptLabel;
}

- (void) showPromptMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
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
        [self showMessage:@"未知错误"];
             break;
    }
}

- (void) failureWithCode:(NSString*)code message:(NSString*)message{
    NSLog(@"code:%@,message:%@",code,message);
}

-(void)showprogressHUD{
    [_progressHUD show:YES];
}

-(void)hiddenProgressHUD{
    [_progressHUD hide:YES];
}
@end
