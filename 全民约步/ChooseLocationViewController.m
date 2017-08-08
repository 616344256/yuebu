//
//  ChooseLocationViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/5.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "ChooseLocationViewController.h"

@interface ChooseLocationViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>
@property(nonatomic,strong)AMapLocationManager *locationManager;
@property(nonatomic,strong)MAPointAnnotation *pointAnnotation;
@property(nonatomic,strong)AMapSearchAPI *mapSeach;
@property(nonatomic,strong)AMapReGeocodeSearchRequest *regeo;
@end

@implementation ChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setMapView];
    [self configLocationManager];
    [self locateAction];
    ///把地图添加至view
    [self.view addSubview:_mapView];
    _lblMessage = [[UILabel alloc]init];
    _lblMessage.frame = CGRectMake(0, self.view.bounds.size.height - 84-64, self.view.bounds.size.width, 50);
    _lblMessage.numberOfLines = 2;
    [self.view addSubview:_lblMessage];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_closeButton];
    _closeButton.frame = CGRectMake(0, self.view.bounds.size.height - 35-64, 60, 20);
    [_closeButton setTitle:@"取消" forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(returnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _zoom = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_zoom];
    _zoom.frame = CGRectMake(self.view.bounds.size.width - 60, self.view.bounds.size.height - 35-64, 60, 20);
    [_zoom setTitle:@"确定" forState:UIControlStateNormal];
    [_zoom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_zoom addTarget:self action:@selector(zoomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setMapView
{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-84)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    _mapView.showTraffic = YES;
    _mapView.showsCompass = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    _mapView.zoomLevel = 17;
    //自定义定位经度圈样式
    _mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
    //地图跟踪模式
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    //后台定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    _mapView.allowsBackgroundLocationUpdates = NO;//iOS9以上系统必须配置
    [self.view addSubview:_mapView];
    self.mapSeach = [[AMapSearchAPI alloc]init];
    self.mapSeach.delegate = self;
    
    self.regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        MAPinAnnotationView *annotationView = nil;
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        }
        annotationView.pinColor = MAPinAnnotationColorGreen;
        
        //annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = NO;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        return annotationView;
    }
    return nil;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:6];
    
    [self.locationManager setReGeocodeTimeout:3];
}

- (void)locateAction
{
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //定位信息
        NSLog(@"location:%@", location);
        self.pointAnnotation = [[MAPointAnnotation alloc] init];
        self.pointAnnotation.coordinate = location.coordinate;
        [_mapView addAnnotation:self.pointAnnotation];
        //逆地理信息
        if (regeocode)
        {
            _lblMessage.text =  regeocode.formattedAddress;
        }
    }];
}

- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois{

    if (pois.count !=0) {
        NSLog(@"%@",pois);
        MATouchPoi *poi = pois[0];
        NSLog(@"%f,%f",poi.coordinate.latitude,poi.coordinate.longitude);
        self.pointAnnotation.coordinate = poi.coordinate;
        
        self.regeo.location = [AMapGeoPoint locationWithLatitude:poi.coordinate.latitude longitude:poi.coordinate.longitude];
        self.regeo.requireExtension = YES;
        //发起逆地理编码
        [self.mapSeach AMapReGoecodeSearch:self.regeo];
    }
}

#pragma mark - AMapSearchDelegate

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        NSLog(@"%@",response.regeocode.formattedAddress);
        _lblMessage.text =  response.regeocode.formattedAddress;
    }
}

- (void)returnButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zoomButtonClicked:(id)sender
{
    if (_lblMessage.text) {
        self.callBackBlock(@{@"address":_lblMessage.text ,@"point":self.pointAnnotation});
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"1");
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
