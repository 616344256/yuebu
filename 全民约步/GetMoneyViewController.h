//
//  GetMoneyViewController.h
//  全民约步
//
//  Created by 姜祺 on 17/6/6.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "BaseViewController.h"
#import "SlideMenuController.h"
#import "LeftViewController.h"
@interface GetMoneyViewController : BaseViewController<SlideMenuControllerDelegate>
@property (weak, nonatomic) id<LeftMenuProtocol> delegate;
@end
