//
//  WalkDetailsViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/8.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "WalkDetailsViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import "CustomAnnotationView.h"
#import <MAMapKit/MAMapKit.h>
#import <AFNetworking.h>
#import "ComeRunViewController.h"
#import "WatchMemberViewController.h"
@interface WalkDetailsViewController ()<AMapNaviWalkManagerDelegate,MAMapViewDelegate,CustomCalloutViewDelegate>

@property (nonatomic, strong) AMapNaviWalkManager *walkManager;

@property (nonatomic, strong) MAMapView *mapView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *sendBtn;
@end

@implementation WalkDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"约步详情";
    [self initMapView];
    [self initWalkManager];
    [self setHead];
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.sendBtn];
    self.sendBtn.frame = CGRectMake(20, SCREENHEIGHT-144, SCREENWIGTH-40, 40);
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendBtn setBackgroundColor:getColor(@"44464e")];
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 5;
    [self.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.jumpState == kWantMake) {
        [self.sendBtn setTitle:@"确认创建" forState:UIControlStateNormal];
    }else if (self.jumpState == kMake || self.jumpState == kAdd){
        [self.sendBtn setTitle:@"查看成员" forState:UIControlStateNormal];
    }else if (self.jumpState == kWantAdd){
        [self.sendBtn setTitle:@"加入约步" forState:UIControlStateNormal];
        
    }
    
}

-(void)setHead{
    self.titleLabel = [[UILabel alloc]init];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.frame = CGRectMake(40, 40, SCREENWIGTH - 80, 40);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = getColor(@"f79895");
    self.titleLabel.text = [NSString stringWithFormat:@"主题:%@",[self.model objectForKey:@"title"]];
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = 5;
    self.titleLabel.font = DEF_FontSize_18;
    
    self.timeLabel = [[UILabel alloc]init];
    [self.view addSubview:self.timeLabel];
    self.timeLabel.frame = CGRectMake(40, 100, SCREENWIGTH - 80, 40);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.backgroundColor = getColor(@"f79895");
    self.timeLabel.text = [NSString stringWithFormat:@"时间:%@",[self.model objectForKey:@"time"]];
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.layer.cornerRadius = 5;
    self.timeLabel.font = DEF_FontSize_18;

}

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   self.view.bounds.size.width,
                self.                                                   self.view.bounds.size.height)];
        [self.mapView setDelegate:self];
        _mapView.centerCoordinate =  CLLocationCoordinate2DMake(self.startPoint.latitude,self.startPoint.longitude);
        //后台定位
        _mapView.pausesLocationUpdatesAutomatically = NO;
        
        _mapView.allowsBackgroundLocationUpdates = NO;//iOS9以上系统必须配置
        [self.view addSubview:self.mapView];
    }
}

- (void)initWalkManager
{
    if (self.walkManager == nil)
    {
        self.walkManager = [[AMapNaviWalkManager alloc] init];
        [self.walkManager setDelegate:self];
        
        [self.walkManager calculateWalkRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]];
    }
}

- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"onCalculateRouteSuccess");

    
    
    CLLocationCoordinate2D commonPolylineCoords[walkManager.naviRoute.routeCoordinates.count];
    for (int i = 0; i<walkManager.naviRoute.routeCoordinates.count; i++) {
        commonPolylineCoords[i].longitude =walkManager.naviRoute.routeCoordinates[i].longitude;
        commonPolylineCoords[i].latitude =walkManager.naviRoute.routeCoordinates[i].latitude;
    }
    //显示路径或开启导航
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:walkManager.naviRoute.routeCoordinates.count];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
    
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(walkManager.naviRoute.routeCoordinates[0].latitude,walkManager.naviRoute.routeCoordinates[0].longitude);
    pointAnnotation.title = @"起点";
    pointAnnotation.subtitle = @"起点";
    
    MAPointAnnotation *pointAnnotation1 = [[MAPointAnnotation alloc] init];
    pointAnnotation1.coordinate = CLLocationCoordinate2DMake(walkManager.naviRoute.routeCoordinates[walkManager.naviRoute.routeCoordinates.count-1].latitude,walkManager.naviRoute.routeCoordinates[walkManager.naviRoute.routeCoordinates.count-1].longitude);
    pointAnnotation1.title = @"终点";
    pointAnnotation1.subtitle = @"终点";
    [_mapView addAnnotations:@[pointAnnotation,pointAnnotation1]];

//    [_mapView setZoomLevel:16.5 animated:YES];
    [self.mapView showAnnotations:@[pointAnnotation,pointAnnotation1] animated:YES];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = getColor(@"436EEE");
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"标注点"];
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        annotationView.selected = YES;
        annotationView.viewDelegate = self;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0,0);
        
        return annotationView;
    }
    return nil;
}

-(void)sendBtnClick:(id)send{
    
    if (self.jumpState == kWantMake) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        // 拼接请求参数
        NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"title":[self.model objectForKey:@"title"],@"start_address":[self.model objectForKey:@"startAddress"],@"end_address":[self.model objectForKey:@"endAddress"],@"start_x":[NSString stringWithFormat:@"%f",self.startPoint.longitude],@"start_y":[NSString stringWithFormat:@"%f",self.startPoint.latitude],@"end_x":[NSString stringWithFormat:@"%f",self.endPoint.longitude],@"end_y":[NSString stringWithFormat:@"%f",self.endPoint.latitude],@"time":[self.model objectForKey:@"timecuo"]};
        [manager POST:@"http://yuebu.tcgqxx.com/api/yuebu/yuebu_add" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [self showMessage:[responseObject objectForKey:@"msg"]];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ComeRunViewController class]]) {
                    ComeRunViewController *revise =(ComeRunViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else if (self.jumpState == kMake || self.jumpState == kAdd){
        WatchMemberViewController *vc = [[WatchMemberViewController alloc]init];
        vc.kid = [self.model objectForKey:@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.jumpState == kWantAdd){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        // 拼接请求参数
        NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"id":[self.model objectForKey:@"id"]};
        [manager POST:@"http://yuebu.tcgqxx.com/api/yuebu/yuebu_join" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [self showMessage:[responseObject objectForKey:@"msg"]];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ComeRunViewController class]]) {
                    ComeRunViewController *revise =(ComeRunViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
