//
//  MainViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/2.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+SlideMenuControllerOC.h"
//#import "StepManager.h"
#import <CoreMotion/CoreMotion.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "sendRedPacketViewController.h"
#import "OpenRedPacketViewController.h"
#import "UIButton+WebCache.h"
#import "RedPacketsView.h"
#import <AFNetworking.h>
#import "CustomAnnotationView.h"
#import "LoginViewController.h"
@interface MainViewController ()<MAMapViewDelegate,AMapSearchDelegate,CustomCalloutViewDelegate>
{
    NSTimer *_timer;
    NSInteger num;
    NSString *redPacketId;
    NSString *redNum;
}
@property(nonatomic,strong)CMPedometer *stepCounter;
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)MAMapView *mapView;
@property (nonatomic, strong) UIButton *gpsButton;
@property(nonatomic,strong) UIButton *openRedPacketBtn;
@property(nonatomic,strong) UIButton *putInRedPacketBtn;
@property(nonatomic,strong)NSMutableArray *pointArr;
@property(nonatomic,strong)AFHTTPSessionManager *locationManager;
@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 [self.navigationController setNavigationBarHidden:YES animated:NO];
     [self.slideMenuController addLeftGestures];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_img"]) {
     
        [self.leftButton sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] valueForKey:@"User_img"] forState:UIControlStateNormal];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.slideMenuController removeLeftGestures];
//    [timer invalidate];   // 将定时器从运行循环中移除，
//    timer = nil;
}

-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0 ,btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, 10.0)];//图片距离右边框距离减少图片的宽度，其它不边
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *headView = [[UIView alloc]init];
    [self.view addSubview:headView];
    headView.frame = CGRectMake(0, 0, SCREENWIGTH, 64);
    headView.backgroundColor = getColor(@"44464e");
    
    
    self.pointArr = [[NSMutableArray alloc]init];
    self.locationManager = [AFHTTPSessionManager manager];
    
    self.locationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.locationManager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(10, 20, 40, 40);
    [self.leftButton setImage:[UIImage imageNamed:@"点击登录"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(toggleLeft) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.layer.masksToBounds = YES;
    self.leftButton.layer.cornerRadius = 20;
    [headView addSubview:self.leftButton];
    
    UILabel  *nameLabel = [[UILabel alloc]init];
    [headView addSubview:nameLabel];
    nameLabel.frame = CGRectMake(0, 30, SCREENWIGTH, 20);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"一起约步";
    nameLabel.font = DEF_FontSize_18;

    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(SCREENWIGTH - 110, 20, 110, 40);
    
    [self.rightButton setImage:[UIImage imageNamed:@"步数"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"0步" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [rightButton addTarget:self action:@selector(toggleLeft) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:self.rightButton];
    [headView addSubview:self.rightButton];
   
    [self startTime];
    [self setMapView];
    [self setBtn];
    
}

-(void)setMapView
{
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    _mapView.showTraffic = YES;
    _mapView.showsCompass = YES;
    _mapView.scrollEnabled = NO;
    _mapView.distanceFilter = 3.0f;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    _mapView.zoomLevel = 17;
    //自定义定位经度圈样式
    _mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
    //地图跟踪模式
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    //后台定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    [self.view addSubview:_mapView];
    
    self.gpsButton = [self makeGPSButtonView];
    self.gpsButton.center = CGPointMake(CGRectGetMidX(self.gpsButton.bounds) + 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(self.gpsButton.bounds) - 84+64);
    [self.view addSubview:self.gpsButton];
    
    
}

-(void)setBtn{

    self.openRedPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.openRedPacketBtn];
    self.openRedPacketBtn.frame = CGRectMake(SCREENWIGTH - 120, SCREENHEIGHT - 200 + 64, 100, 40);
    [self.openRedPacketBtn setTitle:@"开红包" forState:UIControlStateNormal];
    [self.openRedPacketBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.openRedPacketBtn setBackgroundColor:getColor(@"de524e")];
    self.openRedPacketBtn.layer.masksToBounds = YES;
    self.openRedPacketBtn.layer.cornerRadius = 20;
    [self.openRedPacketBtn addTarget:self action:@selector(openRedPacketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.putInRedPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.putInRedPacketBtn];
    self.putInRedPacketBtn.frame = CGRectMake(SCREENWIGTH - 120, SCREENHEIGHT - 260 + 64, 100, 40);
    [self.putInRedPacketBtn setTitle:@"埋红包" forState:UIControlStateNormal];
    [self.putInRedPacketBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.putInRedPacketBtn setBackgroundColor:getColor(@"de524e")];
    self.putInRedPacketBtn.layer.masksToBounds = YES;
    self.putInRedPacketBtn.layer.cornerRadius = 20;
    [self.putInRedPacketBtn addTarget:self action:@selector(putInRedPacketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
    }
}


-(void)startTime{

    //先判断设备是否支持计步功能
    if ([CMPedometer isStepCountingAvailable]) {
        
        self.stepCounter = [[CMPedometer alloc]init];
        
        NSDate *toDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *fromDate =
        [dateFormatter dateFromString:[dateFormatter stringFromDate:toDate]];

        [self.stepCounter startPedometerUpdatesFromDate:fromDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            num = [pedometerData.numberOfSteps integerValue];
            [self.rightButton setTitle:[NSString stringWithFormat:@"%@步",pedometerData.numberOfSteps] forState:UIControlStateNormal];
        }];
    }else{
        NSLog(@"记步功能不可用");
        [self showMessage:@"计步功能不可用"];
    }
}

///当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标，示例代码如下：
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
     
        @autoreleasepool {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]) {
                
                NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"x":[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude],@"y":[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude],@"num":[NSString stringWithFormat:@"%ld",num]};
                
                [self.locationManager POST:@"http://yuebu.tcgqxx.com/api/yuebu/bushu" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //                NSLog(@"%@",responseObject);
                    
                    if ([responseObject objectForKey:@"result"]&&[responseObject objectForKey:@"result"] != [NSNull null] &&[[responseObject objectForKey:@"result"] count] != 0) {
                        
                        if ([[[responseObject objectForKey:@"result"][0] objectForKey:@"juli"] integerValue] <= 10) {
                            RedPacketsView *view = [[RedPacketsView alloc]init];
                            view.frame = CGRectMake(0, 0, SCREENWIGTH, SCREENHEIGHT);
                            view.data = @{@"img":[[responseObject objectForKey:@"result"][0] objectForKey:@"img"],@"title":[[responseObject objectForKey:@"result"][0] objectForKey:@"title"],@"hongbao_id":[[responseObject objectForKey:@"result"][0] objectForKey:@"hid"] };
                            view.pass = ^(NSString *kid){
                                NSLog(@"抢红包");
                                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                
                                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                                
                                manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                                
                                NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"hongbao_id":kid};
                                
                                [manager POST:@"http://yuebu.tcgqxx.com/api/hongbao/open_hongbao" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    NSLog(@"%@",responseObject);
                                    [self showMessage:[responseObject objectForKey:@"msg"]];
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                }];
                            };
                            
                            [self.view addSubview:view];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [view removeFromSuperview];
                                
                            });
                        }
                        
                        if (![[[responseObject objectForKey:@"result"][0] objectForKey:@"hongbao_id"] isEqual:redPacketId]||![[NSString stringWithFormat:@"%lu",[[responseObject objectForKey:@"result"] count]] isEqual:redNum]) {
                            [_mapView removeAnnotations:self.pointArr];
                            [self.pointArr removeAllObjects];
                            redPacketId = [[responseObject objectForKey:@"result"][0] objectForKey:@"hongbao_id"];
                            redNum = [NSString stringWithFormat:@"%lu",[[responseObject objectForKey:@"result"] count]];
                            
                            for (NSDictionary *dic in [responseObject objectForKey:@"result"]) {
                                
                                MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                                pointAnnotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"y"] floatValue], [[dic objectForKey:@"x"] floatValue]);
                                pointAnnotation.title = [dic objectForKey:@"title"];
                                pointAnnotation.subtitle = [dic objectForKey:@"img"];
                                
                                [self.pointArr addObject:pointAnnotation];
                            }
                            
                            [_mapView addAnnotations:self.pointArr];
                        }
                        
                    }else if ([[responseObject objectForKey:@"result"] count] == 0){
                    
                        [_mapView removeAnnotations:self.pointArr];
                        [self.pointArr removeAllObjects];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                }];
            }

        }
        
    }
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
        annotationView.image = [UIImage imageNamed:@"形状-44"];
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        annotationView.selected = YES;
        annotationView.viewDelegate = self;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        
        return annotationView;
    }
    return nil;
}

#pragma mark - Click

-(void)toggleLeft{

    [self.slideMenuController toggleLeft];
}

-(void)openRedPacketBtnClick:(id)send{

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]) {
        OpenRedPacketViewController *vc = [[OpenRedPacketViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
    
        [self showMessage:@"请登录"];
    }
}

-(void)putInRedPacketBtnClick:(id)send{
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]) {
        sendRedPacketViewController *sendVC = [[sendRedPacketViewController alloc]init];
        [self.navigationController pushViewController:sendVC animated:YES];
    }else{
        
        [self showMessage:@"请登录"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr - SlideMenuControllerDelegate
-(void)leftWillOpen {
    NSLog(@"SlideMenuControllerDelegate: leftWillOpen");
}

-(void)leftDidOpen {
    NSLog(@"SlideMenuControllerDelegate: leftDidOpen");
}

-(void)leftWillClose {
    NSLog(@"SlideMenuControllerDelegate: leftWillClose");
}

-(void)leftDidClose {
    NSLog(@"SlideMenuControllerDelegate: leftDidClose");
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_img"]) {
        
        [self.leftButton sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] valueForKey:@"User_img"] forState:UIControlStateNormal];
    }else{
    
        [self.leftButton setImage:[UIImage imageNamed:@"点击登录"] forState:UIControlStateNormal];
    }
}

-(void)rightWillOpen {
    NSLog(@"SlideMenuControllerDelegate: rightWillOpen");
}

-(void)rightDidOpen {
    NSLog(@"SlideMenuControllerDelegate: rightDidOpen");
}

-(void)rightWillClose {
    NSLog(@"SlideMenuControllerDelegate: rightWillClose");
}

-(void)rightDidClose {
    NSLog(@"SlideMenuControllerDelegate: rightDidClose");
}

@end
