//
//  WalkDetailsViewController.h
//  全民约步
//
//  Created by 姜祺 on 17/6/8.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
typedef NS_ENUM(NSInteger, kJumpState){
    kWantMake,
    kMake,
    kWantAdd,
    kAdd,
};
@interface WalkDetailsViewController : BaseViewController
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;
@property (nonatomic,strong) NSDictionary *model;
@property (nonatomic, assign) kJumpState jumpState;
@end
