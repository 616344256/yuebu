//
//  LeftViewController.h
//  全民约步
//
//  Created by 姜祺 on 17/6/2.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "BaseViewController.h"
#import "SlideMenuController.h"
@protocol LeftMenuProtocol <NSObject>

@required
-(void)changeViewController;

@end
@interface LeftViewController : BaseViewController<SlideMenuControllerDelegate,LeftMenuProtocol>
@property (retain, nonatomic) UIViewController *mainViewControler;
@end
