//
//  CustomAnnotationView.h
//  地图demo
//
//  Created by 姜祺 on 16/11/21.
//  Copyright © 2016年 姜祺. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"
@protocol CustomCalloutViewDelegate<NSObject>
-(void)openVideoRtmp:(NSString *)rtmp title:(NSString *)title;
@end
@interface CustomAnnotationView : MAAnnotationView

//@property (nonatomic, readonly) CustomCalloutView *calloutView;
@property (nonatomic, weak) id <CustomCalloutViewDelegate>viewDelegate;
@end
