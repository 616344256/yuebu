//
//  UserLocation.h
//  全民约步
//
//  Created by 姜祺 on 17/8/4.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface UserLocation : NSObject
@property(nonatomic,assign)CLLocationDegrees latitude;
@property(nonatomic,assign)CLLocationDegrees longitude;
@end
