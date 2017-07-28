//
//  RedPacketRecordViewController.h
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SlideMenuController.h"
#import "LeftViewController.h"
@interface RedPacketRecordViewController : BaseTableViewController<SlideMenuControllerDelegate>
@property (weak, nonatomic) id<LeftMenuProtocol> delegate;

@end
