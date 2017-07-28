//
//  BaseViewController.h
//  TianjinBoHai
//
//  Created by 李莹 on 15/1/9.
//  Copyright (c) 2015年 Binky Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Reachability.h"
//#import "MBProgressHUD.h"
#import "MBProgressHUD.h"
#import "Config.h"
@interface BaseViewController : UIViewController
/**
 *  显示message
 */
- (void) showMessage:(NSString*)message;

/**
 *  显示错误信息
 *
 *  @param error 返回的错误信息
 */
- (void) showError:(NSError*)error;
/**
 *  显示错误的code码和信息
 *
 *  @param code    返回的code码
 *  @param message 返回的信息
 */
- (void) failureWithCode:(NSString*)code message:(NSString*)message;

/**
 *  显示大菊花
 */
-(void)showprogressHUD;

/**
 *  隐藏大菊花
 */
-(void)hiddenProgressHUD;

//@property (nonatomic, strong) Reachability* conn;

@property (strong, nonatomic) UIStoryboard * secondStoryBoard;
- (void)saveTheDataToCachesWithData:(id)data toThePlistFile:(NSString *)fileName;
- (NSArray *)readTheDataFromCachesFromPlistFile:(NSString *)fileName;

//无数据视图
//-(void)nullDataViewMethos;
@end
