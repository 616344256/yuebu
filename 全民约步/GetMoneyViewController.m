//
//  GetMoneyViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/6.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "GetMoneyViewController.h"
#import "MainViewController.h"
#import <AFNetworking.h>
@interface GetMoneyViewController ()
@property(nonatomic,strong)UILabel *weChatLabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UITextField *moneyTextField;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UIButton *getBtn;
@property(nonatomic,strong)UIButton *sendBtn;
@end

@implementation GetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    
    UIView *weChatView = [[UIView alloc]init];
    [self.view addSubview:weChatView];
    weChatView.frame = CGRectMake(0, 20, SCREENWIGTH, 60);
    weChatView.backgroundColor = [UIColor whiteColor];
    UILabel *hideLabel = [[UILabel alloc]init];
    [weChatView addSubview:hideLabel];
    hideLabel.frame = CGRectMake(20, 20, 120, 20);
    hideLabel.text = @"提到微信账号";

    self.weChatLabel = [[UILabel alloc]init];
    [weChatView addSubview:self.weChatLabel];
    self.weChatLabel.frame = CGRectMake(150, 20, 100, 20);
    self.weChatLabel.text = @"123456789";
    self.weChatLabel.textColor = getColor(@"878787");
    
    
    UIView *moneyView = [[UIView alloc]init];
    [self.view addSubview:moneyView];
    moneyView.frame = CGRectMake(0, 100, SCREENWIGTH, 60);
    moneyView.backgroundColor = [UIColor whiteColor];
    UILabel *numLabel = [[UILabel alloc]init];
    [moneyView addSubview:numLabel];
    numLabel.frame = CGRectMake(20, 20, 80, 20);
    numLabel.text = @"提现金额";
    self.moneyTextField = [[UITextField alloc]init];
    [moneyView addSubview:self.moneyTextField];
    self.moneyTextField.frame = CGRectMake(150, 12, 100, 40);
    self.moneyTextField.textColor = getColor(@"878787");
  
    UILabel *hide1Label = [[UILabel alloc]init];
    [self.view addSubview:hide1Label];
    hide1Label.text = @"余额";
    hide1Label.frame = CGRectMake(20, 180, 40, 20);
    hide1Label.textColor = getColor(@"878787");
    
    self.moneyLabel = [[UILabel alloc]init];
    [self.view addSubview:self.moneyLabel];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",[[NSUserDefaults standardUserDefaults] valueForKey:@"User_money"]];
    self.moneyLabel.frame = CGRectMake(70, 180, 80, 20);
    self.moneyLabel.textColor = getColor(@"f35451");
    
    self.getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.getBtn];
    self.getBtn.frame = CGRectMake(160, 180, 80, 20);
    [self.getBtn setTitle:@"全部提现" forState:UIControlStateNormal];
    [self.getBtn setTitleColor:getColor(@"4aa5ef") forState:UIControlStateNormal];
    self.getBtn.layer.masksToBounds = YES;
    self.getBtn.layer.cornerRadius = 5;
    [self.getBtn addTarget:self action:@selector(getBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.sendBtn];
    self.sendBtn.frame = CGRectMake(20, 250, SCREENWIGTH-40, 40);
    [self.sendBtn setTitle:@"提现" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendBtn setBackgroundColor:getColor(@"44464e")];
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 5;
    [self.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 0, 20, 20);
    
    [self.backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];

    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = Button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendBtnClick:(id)send{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    // 拼接请求参数
    NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"money":self.moneyTextField.text};
    [manager POST:@"http://yuebu.tcgqxx.com/api/money/carry_money" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)getBtnClick:(id)send{

    self.moneyTextField.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"User_money"]];
}

-(void)backBtnClick:(id)send{

    if (_delegate != nil && [_delegate respondsToSelector:@selector(changeViewController)]) {
        [_delegate changeViewController];
    }
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
