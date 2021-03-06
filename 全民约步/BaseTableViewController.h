//
//  BaseTableViewController.h
//  SunyardFinance
//
//  Created by 李莹 on 15/8/25.
//  Copyright (c) 2015年 Blue Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface BaseTableViewController : UITableViewController
/**
 *  显示message
 */
- (void) showMessage:(NSString*)message;
- (void) darkOrangeButtonAttribute:(UIButton*)button;
- (UILabel*)showPromptBox:(NSString *)message;
- (void) showPromptMessage:(NSString*)message;
- (void)saveTheDataToCachesWithData:(id)data toThePlistFile:(NSString *)fileName;
- (NSArray *)readTheDataFromCachesFromPlistFile:(NSString *)fileName
;

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

@end
