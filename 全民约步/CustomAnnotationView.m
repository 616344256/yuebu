//
//  CustomAnnotationView.m
//  地图demo
//
//  Created by 姜祺 on 16/11/21.
//  Copyright © 2016年 姜祺. All rights reserved.
//

#import "CustomAnnotationView.h"
@interface CustomAnnotationView ()

//@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;
@property (nonatomic,strong, readwrite)UIButton *clickBtn;

@end
@implementation CustomAnnotationView

#define kCalloutWidth       200.0
#define kCalloutHeight      70.0

-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
//        self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
//        [self addSubview:self.calloutView];
//        self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.clickBtn.frame = CGRectMake(0, 0, self.calloutView.frame.size.width, self.calloutView.frame.size.height);
////        self.clickBtn.backgroundColor = [UIColor redColor];
//        [self.calloutView addSubview:self.clickBtn];
////        self.calloutView.userInteractionEnabled = YES;
//        [self.clickBtn addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
        
         UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    [self clickBtn1];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.calloutView.image = [UIImage imageNamed:@"video"];
//        self.calloutView.title = self.annotation.title;
//        self.calloutView.subtitle = self.annotation.subtitle;
//        NSLog(@"%@",self.annotation.title);
//    });
    
}

-(void)clickBtn1{
    if ([_viewDelegate respondsToSelector:@selector(openVideoRtmp:title:)]) {
        [_viewDelegate openVideoRtmp:self.annotation.title title:self.annotation.subtitle];
    }
}

-(void)event{

    [self clickBtn1];
}

@end
