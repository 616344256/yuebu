//
//  RegistViewController.m
//  渥易家
//
//  Created by 姜祺 on 17/7/26.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "RegistViewController.h"
#import <AFNetworking.h>
@interface RegistViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic , strong) NSTimer * countDownTimer;  //倒计时
@property (nonatomic) NSInteger secondsCountDown;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)setPhoneTextField:(UITextField *)phoneTextField{
    
    _phoneTextField = phoneTextField;
    _phoneTextField.delegate = self;
    
    _phoneTextField.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.14];
    _phoneTextField.layer.masksToBounds = YES;
    _phoneTextField.layer.cornerRadius = 10;
    
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 25, 15)];
    imageViewPwd.image=[UIImage imageNamed:@"电话"];
    _phoneTextField.leftView=imageViewPwd;
    _phoneTextField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_phoneTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    //    _phoneTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"User_name"];
}

-(void)setPasswordTextField:(UITextField *)passwordTextField{
    
    _passwordTextField = passwordTextField;
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.tintColor = [UIColor whiteColor];
    _passwordTextField.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.14];
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 25, 15)];
    imageViewPwd.image=[UIImage imageNamed:@"填写"];
    _passwordTextField.leftView=imageViewPwd;
    _passwordTextField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.cornerRadius = 10;
    [_passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    //    _userNmaeTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"User_passWord"];
}

-(void)setCodeTextField:(UITextField *)codeTextField{

    _codeTextField = codeTextField;
    _codeTextField.delegate = self;
    _codeTextField.secureTextEntry = YES;
    _codeTextField.hidden = YES;
    _codeTextField.tintColor = [UIColor whiteColor];
    _codeTextField.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.14];
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 25, 15)];
    imageViewPwd.image=[UIImage imageNamed:@"填写"];
    _codeTextField.leftView=imageViewPwd;
    _codeTextField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _codeTextField.layer.masksToBounds = YES;
    _codeTextField.layer.cornerRadius = 10;
    [_codeTextField setValue:getColor(@"9a9a9a") forKeyPath:@"_placeholderLabel.textColor"];
    //    _userNmaeTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"User_passWord"];
}

-(void)setSendBtn:(UIButton *)sendBtn{
    
    _sendBtn = sendBtn;
    self.sendBtn.titleLabel.font = DEF_FontSize_14;
    self.sendBtn.layer.borderWidth = 1;
    self.sendBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 5;
    [self.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setCodeBtn:(UIButton *)codeBtn{
    
    _codeBtn = codeBtn;
    self.codeBtn.titleLabel.font = DEF_FontSize_14;
    self.codeBtn.layer.borderWidth = 1;
    self.codeBtn.layer.borderColor = getColor(@"80aa1f").CGColor;
    self.codeBtn.layer.masksToBounds = YES;
    self.codeBtn.layer.cornerRadius = 5;
    [self.codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.codeBtn.hidden = YES;
}
- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendBtnClick:(id)send{

    if (self.phoneTextField.text.length == 11) {
         if (self.passwordTextField.text.length >= 6) {
             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
             
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             
             manager.requestSerializer=[AFHTTPRequestSerializer serializer];
             
//             NSDictionary *params = @{@"mobilephone":_phoneTextField.text,@"password":_passwordTextField.text,@"checkcode":_codeTextField.text};
             
             [manager GET:[NSString stringWithFormat:@"http://yuebu.tcgqxx.com/api/Register/register?zhanghao=%@&password=%@",_phoneTextField.text,_passwordTextField.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 [self showMessage:[responseObject objectForKey:@"msg"]];
                 if ([[responseObject objectForKey:@"msg"] isEqualToString:@"注册成功"]) {
                      [self dismissViewControllerAnimated:YES completion:nil];
//                     [self stopTime];
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@",error);
                 NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
             }];
         }else{
             [self showMessage:@"请输入密码"];
         }
        
    }else{
        [self showMessage:@"请输入手机号"];
    }
}

-(void)codeBtnClick:(id)send{

    if (_phoneTextField.text.length == 11) {

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        [manager GET:[NSString stringWithFormat:@"http://suoadmin.slkfz.cn/api/api/sendmsg?mobilephone=%@",self.phoneTextField.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self startTime];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else{
        
        [self showMessage:@"请填写正确的手机号"];
    }
}

/**
 *  开始计时
 */

- (void)startTime
{
    [self stopTime];
    
    _secondsCountDown = 60;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    _codeBtn.enabled = NO;
}

/**
 *  重置
 */

- (void)stopTime
{
    if (_countDownTimer) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        _codeBtn.enabled = YES;
    }
}

/**
 *  timer方法
 */

- (void)timeFireMethod
{
    _secondsCountDown --;
    
    //    [self.codeBtn.titleLabel setText:[NSString stringWithFormat:@"%ld秒重发",(long)_secondsCountDown]];
    [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒重发",(long)_secondsCountDown] forState:UIControlStateNormal];
    if (_secondsCountDown == 0) {
        [self stopTime];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
@end
