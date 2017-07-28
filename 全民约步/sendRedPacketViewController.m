//
//  sendRedPacketViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/5.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "sendRedPacketViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ChooseLocationViewController.h"
#import <AFNetworking.h>
#import "UIViewController+WeChatAndAliPayMethod.h"
@interface sendRedPacketViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,AMapLocationManagerDelegate>{

    BOOL isBack;
}
@property(nonatomic,strong)UITextField *numTextField;
@property(nonatomic,strong)UITextField *moneyTextField;
@property(nonatomic,strong)UITextField *titleTextField;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *sendBtn;
@property(nonatomic,strong)AMapLocationManager *locationManager;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)CLLocation *sendLocation;
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation sendRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    self.sendLocation = [[CLLocation alloc]init];
   self.title = @"发红包";
    [self setScrollView];
    [self setTextField];
    [self setPhotoView];
    [self setMapView];
    [self configLocationManager];
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollView addSubview:self.sendBtn];
    self.sendBtn.frame = CGRectMake(20, 540, SCREENWIGTH-40, 40);
    [self.sendBtn setTitle:@"塞钱" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendBtn setBackgroundColor:getColor(@"44464e")];
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 5;
    [self.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)setScrollView{

    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(SCREENWIGTH, 600);
    self.scrollView.frame = CGRectMake(0, 0, SCREENWIGTH, SCREENHEIGHT - 64);
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:6];
    
    [self.locationManager setReGeocodeTimeout:3];
}

-(void)setTextField{
    UIView *numView = [[UIView alloc]init];
    [self.scrollView addSubview:numView];
    numView.frame = CGRectMake(0, 10, SCREENWIGTH, 50);
    numView.backgroundColor = [UIColor whiteColor];
    UILabel *numLabel = [[UILabel alloc]init];
    [numView addSubview:numLabel];
    numLabel.frame = CGRectMake(20, 10, 80, 20);
    numLabel.text = @"红包个数";
    self.numTextField = [[UITextField alloc]init];
    [numView addSubview:self.numTextField];
    self.numTextField.frame = CGRectMake(100, 2, SCREENWIGTH - 180, 40);
    self.numTextField.textAlignment = NSTextAlignmentRight;
//    self.numTextField.keyboardType = UIKeyboardTypeNumberPad;
    UILabel *hideLabel = [[UILabel alloc]init];
    [numView addSubview:hideLabel];
    hideLabel.frame = CGRectMake(SCREENWIGTH - 50, 10, 50, 20);
    hideLabel.text = @"个";
    
    UIView *moneyView = [[UIView alloc]init];
    [self.scrollView addSubview:moneyView];
    moneyView.frame = CGRectMake(0, 70, SCREENWIGTH, 50);
    moneyView.backgroundColor = [UIColor whiteColor];
    UILabel *moneyLabel = [[UILabel alloc]init];
    [moneyView addSubview:moneyLabel];
    moneyLabel.frame = CGRectMake(20, 10, 80, 20);
    moneyLabel.text = @"总金额";
    self.moneyTextField = [[UITextField alloc]init];
    self.moneyTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [moneyView addSubview:self.moneyTextField];
    self.moneyTextField.frame = CGRectMake(100, 2, SCREENWIGTH - 180, 40);
    self.moneyTextField.textAlignment = NSTextAlignmentRight;
    UILabel *hide1Label = [[UILabel alloc]init];
    [moneyView addSubview:hide1Label];
    hide1Label.frame = CGRectMake(SCREENWIGTH - 50, 10, 50, 20);
    hide1Label.text = @"元";
    
    UIView *titleView = [[UIView alloc]init];
    [self.scrollView addSubview:titleView];
    titleView.frame = CGRectMake(0, 130, SCREENWIGTH, 50);
    titleView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(20, 10, 80, 20);
    titleLabel.text = @"红包主题";
    self.titleTextField = [[UITextField alloc]init];
    [titleView addSubview:self.titleTextField];
    self.titleTextField.frame = CGRectMake(100, 2, SCREENWIGTH - 180, 40);
    self.titleTextField.textAlignment = NSTextAlignmentCenter;
   
}

-(void)setPhotoView{
    UIView *photoView = [[UIView alloc]init];
    [self.scrollView addSubview:photoView];
    photoView.frame = CGRectMake(0, 190, SCREENWIGTH, 150);
    photoView.backgroundColor = [UIColor whiteColor];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoView addSubview:photoBtn];
    photoBtn.frame = CGRectMake(20, 50, 80, 20);
    [photoBtn setTitle:@"添加背景" forState:UIControlStateNormal];
    [photoBtn setTitleColor:getColor(@"4ca6ef") forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.imageView = [[UIImageView alloc]init];
    [photoView addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = CGRectMake(SCREENWIGTH - 250, 10, 200, 130);
    
}

-(void)setMapView{
    UIView *mapView = [[UIView alloc]init];
    [self.scrollView addSubview:mapView];
    mapView.frame = CGRectMake(0, 350, SCREENWIGTH, SCREENHEIGHT - 570);
    mapView.backgroundColor = [UIColor whiteColor];
    
    UILabel *addressLabel = [[UILabel alloc]init];
    [mapView addSubview:addressLabel];
    addressLabel.frame = CGRectMake(20, 20, 80, 20);
    addressLabel.text = @"选择地址";
    
    UIButton *chooseAdrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseAdrButton.frame = CGRectMake(15, 80, 130, 30);
    
    [chooseAdrButton setImage:[UIImage imageNamed:@"定位-1"] forState:UIControlStateNormal];
    [chooseAdrButton setTitle:@"选择当前位置" forState:UIControlStateNormal];
    [chooseAdrButton setTitleColor:getColor(@"4ca6ef") forState:UIControlStateNormal];
    [mapView addSubview:chooseAdrButton];
    [chooseAdrButton addTarget:self action:@selector(chooseAdrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(15, 120, 130, 30);
    
    [shareButton setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
    [shareButton setTitle:@"分享到朋友圈" forState:UIControlStateNormal];
    [shareButton setTitleColor:getColor(@"4ca6ef") forState:UIControlStateNormal];
    [mapView addSubview:shareButton];
    
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapView addSubview:mapBtn];
    mapBtn.frame = CGRectMake(150, 10, SCREENWIGTH - 170, 110);
    [mapBtn setBackgroundImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    mapBtn.layer.masksToBounds = YES;
    mapBtn.layer.cornerRadius = 5;
    [mapBtn addTarget:self action:@selector(mapBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    self.addressLabel = [[UILabel alloc]init];
    [mapView addSubview:self.addressLabel];
    self.addressLabel.frame = CGRectMake(150, 120, SCREENWIGTH - 170, 45);
    self.addressLabel.numberOfLines = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark - click

-(void)sendBtnClick:(id)send{
    if ([self.numTextField.text isEqual:@""]) {
        [self showMessage:@"请输入红包个数"];
        return;
    }
    
    if ([self.moneyTextField.text isEqual:@""]) {
        [self showMessage:@"请输入红包总金额"];
        return;
    }
    
    if ([self.titleTextField.text isEqual:@""]) {
        [self showMessage:@"请输入红包主题"];
        return;
    }
    
    if (!self.imageView.image) {
        [self showMessage:@"请添加背景"];
        return;
    }
    
    if (!self.sendLocation.coordinate.latitude) {
        [self showMessage:@"请选择红包地址"];
        return;
    }
    self.sendBtn.enabled = NO;
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付方式" message:@"请选择支付方式" preferredStyle: UIAlertControllerStyleActionSheet];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDestructive handler:nil];
//    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"零钱支付" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:cancelAction];
//    [alertController addAction:deleteAction];
//    [alertController addAction:archiveAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayResultNoti:) name:WX_PAY_RESULT object:nil];
    
    [self payTheMoneyUseWeChatPayWithPrepay_id:@"12313456" nonce_str:@"156145644"];
    
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//    // 拼接请求参数
//    NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"num":self.numTextField.text,@"money":self.moneyTextField.text,@"title":self.titleTextField.text,@"x":[NSString stringWithFormat:@"%f",self.sendLocation.coordinate.longitude],@"y":[NSString stringWithFormat:@"%f",self.sendLocation.coordinate.latitude],@"address":self.addressLabel.text};
//    [manager POST:@"http://yuebu.tcgqxx.com/api/hongbao/hongbao_add" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        NSData *imageData =UIImageJPEGRepresentation(self.imageView.image,0.1);
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat =@"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//        
//        //上传的参数(上传图片，以文件流的格式)
//        [formData appendPartWithFileData:imageData
//                                    name:@"img"
//                                fileName:fileName
//                                mimeType:@"image/jpeg"];
//        
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
////        [self showMessage:[responseObject objectForKey:@"msg"]];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (isBack == NO) {
//               [self.navigationController popViewControllerAnimated:YES];
//                isBack = YES;
//            }
//           
//        });
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
    
}


-(void)weChatPayResultNoti:(NSNotification *)noti{
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:IS_SUCCESSED]) {
        [self showMessage:@"支付成功"];
        
    }else{
        [self showMessage:@"支付失败"];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WX_PAY_RESULT object:nil];
}


-(void)mapBtnClick:(id)send{

    ChooseLocationViewController *vc = [[ChooseLocationViewController alloc]init];
    vc.callBackBlock = ^(NSDictionary *model){   // 1
        
        self.sendLocation = (CLLocation *)[model objectForKey:@"point"];
        self.addressLabel.text = [model objectForKey:@"address"];

        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)chooseAdrBtnClick:(id)send{

    [self locateAction];
}

- (void)locateAction
{
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        
        //逆地理信息
        if (regeocode)
        {
            self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",regeocode.province,regeocode.city,regeocode.district,regeocode.street,regeocode.number,regeocode.POIName];
            
            self.sendLocation = location;
        }
    }];
}

-(void)photoBtnClick:(id)send{
   
    [self getImageFromIpc];
}

- (void)getImageFromIpc
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置图片
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
