//
//  RedPacketsView.h
//  EveryDay
//
//  Created by 姜祺 on 15/12/8.
//  Copyright © 2015年 江涛. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^openPackets)(NSString *kid);
@interface RedPacketsView : UIView
@property(nonatomic, copy) openPackets pass;
@property(nonatomic, strong)NSDictionary *data;
@end
