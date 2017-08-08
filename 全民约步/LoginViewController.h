//
//  LoginViewController.h
//  渥易家
//
//  Created by 姜祺 on 17/7/26.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "BaseViewController.h"
#import "SlideMenuController.h"
#import "LeftViewController.h"
@interface LoginViewController : BaseViewController<SlideMenuControllerDelegate>
@property (weak, nonatomic) id<LeftMenuProtocol> delegate;

@end
