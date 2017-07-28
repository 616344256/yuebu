//
//  GetMoneyRecordViewController.h
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "BaseViewController.h"
#import "SlideMenuController.h"
#import "LeftViewController.h"
@interface GetMoneyRecordViewController : BaseViewController<SlideMenuControllerDelegate>
@property (weak, nonatomic) id<LeftMenuProtocol> delegate;

@end
