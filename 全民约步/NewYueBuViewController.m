//
//  NewYueBuViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/14.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "NewYueBuViewController.h"
#import "LocationTableViewCell.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "WalkDetailsViewController.h"
@interface NewYueBuViewController ()<AMapSearchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate,AMapLocationManagerDelegate>
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)UITextField *startTextField;
@property(nonatomic,strong)UITextField *titleTextField;
@property(nonatomic,strong)UITextField *endTextField;
@property(nonatomic,strong)UIButton *locationBtn;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *locationArr;
@property(nonatomic,strong)AMapPOIKeywordsSearchRequest *request;
@property(assign,atomic)BOOL isStart;
@property(nonatomic,strong)AMapNaviPoint *startPoint;
@property(nonatomic,strong)AMapNaviPoint *endPoint;
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)AMapLocationManager *locationManager;
@property(strong,nonatomic)UIDatePicker *startDatepicker;
@property(strong,nonatomic)UIView *startDateView;
@property(strong,nonatomic)UIButton *startDateTextField;

@end

@implementation NewYueBuViewController

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.mapView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setMapView];
    [self configLocationManager];
    [self setHeadView];
    [self setTableView];
    [self startDate];
}

-(void)startDate{
    self.startDateView = [[UIView alloc]init];
    [self.view addSubview:self.startDateView];
    self.startDateView.frame = CGRectMake(0,SCREENHEIGHT - 310, SCREENWIGTH , 246);
    self.startDateView.backgroundColor = [UIColor whiteColor];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startDateView addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(10, 10, 40, 20);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.startDateView.hidden = YES;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startDateView addSubview:sureBtn];
    sureBtn.frame = CGRectMake(SCREENWIGTH - 50, 10, 40, 20);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    NSLocale *ch_zh_locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] ;
    //创建datePicker实例变量并初始化
    self.startDatepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,30, SCREENWIGTH , 216)];//无法改变其高和宽，但是可以获取
    self.startDatepicker.backgroundColor = [UIColor whiteColor];
    self.startDatepicker.locale = ch_zh_locale; //设置中文显示
    [NSDate date];  //此方法获取的时间是格林尼治时间中国的时间是东八区 + 8小时即可
    NSLog(@"current time    %@",[NSDate date]);
    NSTimeInterval eigth_Z_CH = 8*60*60;
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:eigth_Z_CH]; //中国的当前时间
    NSLog(@"......%@",currentDate);
    
    /*
     UIDatePickerModeTime  只显示具体的时间，不显示年月，星期
     UIDatePickerModeDate   只显示 年月日
     UIDatePickerModeDateAndTime  年月日 时间 星期 都显示
     UIDatePickerModeCountDownTimer 显示多少小时 多少分钟
     */
    
    [self.startDatepicker setDatePickerMode:UIDatePickerModeDateAndTime];//设置显示模式
    
    [self.startDatepicker setMinimumDate:[NSDate date]]; //设置控件的最小时间，超出最小时间还小则会弹回，此时时间为中国时间
    [self.startDatepicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:10*24*60*60]];//设置最大时间，超出也会弹回
    [self.startDatepicker addTarget:self action:@selector(timeChanged:)forControlEvents:UIControlEventValueChanged];//关联方法
    [self.startDateView addSubview:self.startDatepicker];
    
}

- (void)timeChanged:(id)sender
{
    UIDatePicker *currentPicker = (UIDatePicker *) sender;
    NSDate *pickerDate = [currentPicker date];//格林尼治时间
    NSLog(@"datepicker current time %@",[pickerDate dateByAddingTimeInterval:8*60*60]);//  + 8 输出的格式是24制
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:6];
    
    [self.locationManager setReGeocodeTimeout:3];
    [self locateAction];
}

-(void)setMapView
{
    
    _mapView = [[MAMapView alloc] init];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.frame = self.view.bounds;
    [self.view addSubview:_mapView];
    
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    //自定义定位经度圈样式
    _mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
    //地图跟踪模式
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    //YES 为打开定位，NO为关闭定位
    //后台定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    //    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
}

///当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标，示例代码如下：
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
//        if ([self.startTextField.text isEqualToString:@"我的位置"]) {
//            self.startPoint.latitude = userLocation.coordinate.latitude;
//            self.startPoint.longitude = userLocation.coordinate.longitude;
//        }
        
        NSLog(@"+++latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

-(void)setHeadView{
    
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    label.frame = CGRectMake(20, 40, 50, 20);
    label.font = DEF_FontSize_18;
    label.text = @"标题:";
    
    UILabel *label1 = [[UILabel alloc]init];
    [self.view addSubview:label1];
    label1.frame = CGRectMake(20, 90, 50, 20);
    label1.font = DEF_FontSize_18;
    label1.text = @"起点:";
    
    UILabel *label2 = [[UILabel alloc]init];
    [self.view addSubview:label2];
    label2.frame = CGRectMake(20, 140, 50, 20);
    label2.font = DEF_FontSize_18;
    label2.text = @"终点:";
    
    UILabel *label3 = [[UILabel alloc]init];
    [self.view addSubview:label3];
    label3.frame = CGRectMake(20, 180, 130, 45);
    label3.numberOfLines = 2;
    label3.font = DEF_FontSize_18;
    label3.text = @"活动开始时间:\n(报名截止时间)";
    
    self.titleTextField = [[UITextField alloc]init];
    [self.view addSubview:self.titleTextField];
    self.titleTextField.placeholder = @"请输入标题";
    self.titleTextField.delegate = self;
    self.titleTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.titleTextField.frame = CGRectMake(70, 30, SCREENWIGTH - 120, 40);
    
    self.startTextField = [[UITextField alloc]init];
    [self.view addSubview:self.startTextField];
    self.startTextField.placeholder = @"请输入起点";
    self.startTextField.text = @"我的位置";
    self.startTextField.delegate = self;
    self.startTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.startTextField.frame = CGRectMake(70, 80, SCREENWIGTH - 120, 40);
    
    [self.startTextField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    self.endTextField = [[UITextField alloc]init];
    [self.view addSubview:self.endTextField];
    self.endTextField.placeholder = @"请输入终点";
    self.endTextField.delegate = self;
    self.endTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.endTextField.frame = CGRectMake(70, 130, SCREENWIGTH - 120, 40);
    [self.endTextField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    self.startDateTextField = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.startDateTextField];
    [self.startDateTextField setTitle:@"请选择开始时间" forState:UIControlStateNormal];
    [self.startDateTextField setTitleColor:getColor(@"dddddd") forState:UIControlStateNormal];
    self.startDateTextField.layer.masksToBounds = YES;
    self.startDateTextField.layer.cornerRadius = 5;
    self.startDateTextField.titleLabel.font = DEF_FontSize_16;
    self.startDateTextField.layer.borderColor = getColor(@"dddddd").CGColor;
    self.startDateTextField.layer.borderWidth = 1;
    [self.startDateTextField setBackgroundColor:[UIColor whiteColor]];
    self.startDateTextField.frame = CGRectMake(150, 180, SCREENWIGTH - 200, 40);
    [self.startDateTextField addTarget:self action:@selector(comeOutClick:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)setTableView{
    self.locationArr = [[NSMutableArray alloc]init];
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 240, SCREENWIGTH, SCREENHEIGHT - 304);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.hidden = YES;
    //    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isStart) {
        AMapPOI *temp = self.locationArr[indexPath.row];
        self.startTextField.text = temp.name;
        self.startPoint.latitude = temp.location.latitude;
        self.startPoint.longitude = temp.location.longitude;
    }else{
        AMapPOI *temp = self.locationArr[indexPath.row];
        self.endTextField.text = temp.name;
        self.endPoint.latitude = temp.location.latitude;
        self.endPoint.longitude = temp.location.longitude;
    }
    self.tableView.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locationArr.count;
    //    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationTableViewCell *cell = [LocationTableViewCell cellForTableView:tableView];
    cell.model = self.locationArr[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"11");
    [self.startTextField resignFirstResponder];
    [self.endTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    return YES;
}

#pragma mark - 监听

- (void)valueChanged:(UITextField *)textField{
    if ([self.endTextField.text isEqual:@""] && [self.endTextField isFirstResponder]) {
        self.tableView.hidden = YES;
    }else{
        if (self.startDateView.hidden) {
            self.tableView.hidden = NO;
        }else{
            self.tableView.hidden = YES;
        }
    }
    
    if (textField == self.startTextField) {
        _isStart = YES;
        if ([self.startTextField.text isEqualToString:@"我的位置"]) {
            self.startTextField.text = @"";
        }
        
    }else if (textField == self.endTextField){
        _isStart = NO;
    }
    
    NSLog(@"%@",textField.text);
    self.request.keywords            = textField.text;
    // request.city                = @"北京";
    // request.types               = @"高等院校";
    
    [self.search AMapPOIKeywordsSearch:self.request];
}

-(void)goBtnClick:(id)send{
    
    if ([self.titleTextField.text isEqual:@""]) {
        [self showMessage:@"请填写标题"];
        return;
    }
    
    if ([self.startTextField.text isEqual:@""]) {
        [self showMessage:@"请填写起点"];
        return;
    }
    
    if ([self.endTextField.text isEqual:@""]) {
        [self showMessage:@"请填写终点"];
        return;
    }
    
    if ([self.startDateTextField.titleLabel.text isEqual:@"请选择开始时间"]) {
        [self showMessage:@"请填写时间"];
        return;
    }
    
    
    WalkDetailsViewController *vc = [[WalkDetailsViewController alloc]init];
    vc.jumpState = kWantMake;
    vc.startPoint = self.startPoint;
    vc.endPoint = self.endPoint;
    vc.model = @{@"startAddress":self.startTextField.text,@"endAddress":self.endTextField.text,@"title":self.titleTextField.text,@"time":self.startDateTextField.titleLabel.text,@"timecuo":[NSString stringWithFormat:@"%.0f",[[[self.startDatepicker date] dateByAddingTimeInterval:24*60*60] timeIntervalSince1970]]};
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)comeOutClick:(id)send{

    self.startDateView.hidden = NO;
    self.tableView.hidden = YES;
    [self.startTextField resignFirstResponder];
    [self.endTextField resignFirstResponder];
    [self.titleTextField resignFirstResponder];
}

-(void)cancelBtnClick:(id)send{

    self.startDateView.hidden = YES;
}

-(void)sureBtnClick:(id)send{
    
    NSDate *pickerDate = [self.startDatepicker date];//格林尼治时间
    NSLog(@"datepicker current time %@",[pickerDate dateByAddingTimeInterval:24*60*60]);//  + 8 输出的格式是24制
    self.startDateView.hidden = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[pickerDate dateByAddingTimeInterval:24*60*60]];
    [self.startDateTextField setTitle:dateString forState:UIControlStateNormal];
    [self.startDateTextField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }else{
        
        if (_isStart) {
            self.startPoint.latitude = response.pois[0].location.latitude;
            self.startPoint.longitude = response.pois[0].location.longitude;
        }else{
            self.endPoint.latitude = response.pois[0].location.latitude;
            self.endPoint.longitude = response.pois[0].location.longitude;
        }
        self.locationArr = (NSMutableArray *)response.pois;
        NSLog(@"%@",self.locationArr);
        //解析response获取POI信息，具体解析见 Demo
        [self.tableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)locateAction
{
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        
        //逆地理信息
        if (regeocode)
        {
            self.startPoint = [[AMapNaviPoint alloc]init];
            self.endPoint   = [[AMapNaviPoint alloc]init];
            
            self.startPoint.latitude = location.coordinate.latitude;
            self.startPoint.longitude = location.coordinate.longitude;
            self.startTextField.text = [NSString stringWithFormat:@"%@%@%@%@%@",regeocode.city,regeocode.district,regeocode.street,regeocode.number,regeocode.POIName];
            [[NSUserDefaults standardUserDefaults] setObject:regeocode.city forKey:@"User_city"];
            self.search = [[AMapSearchAPI alloc] init];
            self.search.delegate = self;
            self.request = [[AMapPOIKeywordsSearchRequest alloc] init];
            self.request.requireExtension    = YES;
            self.request.sortrule = 0;
            /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
            self.request.city = [[NSUserDefaults standardUserDefaults] valueForKey:@"User_city"];
            self.request.cityLimit           = YES;
            self.request.requireSubPOIs      = YES;
            UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            goBtn.frame = CGRectMake(0, 0, 40, 20);
            [goBtn setTitle:@"创建" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:goBtn];
            [goBtn addTarget:self action:@selector(goBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
           
        }
    }];
}

@end
