//
//  ChooseLocationViewController.h
//  全民约步
//
//  Created by 姜祺 on 17/6/5.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#import <AMapSearchKit/AMapCommonObj.h>
typedef void(^CallBackBlcok) (NSDictionary *model);
@interface ChooseLocationViewController : BaseViewController<MAMapViewDelegate>{
    MAMapView* _mapView;
    UIButton* _zoom;
    UILabel *_lblMessage;
    UIButton* _closeButton;
    NSString * _strAnnotation;
}
@property (nonatomic,copy)CallBackBlcok callBackBlock;
@end
