//
//  LeftViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/2.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftTableViewCell.h"
#import "GetMoneyViewController.h"
#import "ComeRunViewController.h"
#import "RedPacketRecordViewController.h"
#import "BalanceViewController.h"
#import "GetMoneyRecordViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <AFNetworking.h>
#import "UIButton+WebCache.h"
#import "TrajectoryViewController.h"
#import "LoginViewController.h"
@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *headImgView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UIButton *moneyBtn;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation LeftViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    NSLog(@"11");
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]) {
        AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
        
        manager2.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager2.requestSerializer=[AFHTTPRequestSerializer serializer];
        // 拼接请求参数
        
        NSDictionary *params2 = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]};
        
        [manager2 POST:@"http://yuebu.tcgqxx.com/api/user/userinfo" parameters:params2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.moneyLabel.text = [NSString stringWithFormat:@"%@元",[[responseObject objectForKey:@"result"] objectForKey:@"money"]];
            [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"result"] objectForKey:@"money"] forKey:@"User_money"];
            
            self.nameLabel.text = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"result"] objectForKey:@"nick_name"]];
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_name"]) {
                self.nameLabel.hidden = NO;
            }
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_money"]) {
                self.moneyLabel.hidden = NO;
            }
            
            [self.headImgView sd_setBackgroundImageWithURL:[[NSUserDefaults standardUserDefaults] valueForKey:@"User_img"] forState:UIControlStateNormal];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray arrayWithObjects:@{@"img":@"谁来约步",@"name":@"谁来约步"},@{@"img":@"排行榜",@"name":@"运动轨迹"},@{@"img":@"红包记录",@"name":@"红包记录"},@{@"img":@"提现记录",@"name":@"提现记录"},@{@"img":@"余额明细",@"name":@"余额明细"},@{@"img":@"退出登录",@"name":@"退出登录"}, nil];
    [self setHeadView];
    [self setTableView];
}

-(void)setHeadView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImageView = [[UIImageView alloc]init];
    [self.view addSubview:headImageView];
    headImageView.frame = CGRectMake(0, 0, 350, 250);
    headImageView.image = [UIImage imageNamed:@"bg"];
    headImageView.userInteractionEnabled = YES;
    self.headImgView = [UIButton buttonWithType:UIButtonTypeCustom];
    [headImageView addSubview:self.headImgView];
    self.headImgView.frame = CGRectMake(125, 30, 100, 100);
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_img"]) {
        
        [self.headImgView sd_setBackgroundImageWithURL:[[NSUserDefaults standardUserDefaults] valueForKey:@"User_img"] forState:UIControlStateNormal];
//        self.headImgView.enabled = NO;
    
    }else{
        [self.headImgView setBackgroundImage:[UIImage imageNamed:@"点击登录"] forState:UIControlStateNormal];
//        self.headImgView.enabled = YES;
    }
    
    [self.headImgView addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 50;
    
    self.nameLabel = [[UILabel alloc]init];
    [headImageView addSubview:self.nameLabel];
    self.nameLabel.frame = CGRectMake(0, 150, 350, 20);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor whiteColor];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_name"]) {
        self.nameLabel.hidden = NO;
        self.nameLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"User_name"]];
    }else{
        self.nameLabel.hidden = YES;
    }

    self.nameLabel.font = DEF_FontSize_18;
    
    self.moneyLabel = [[UILabel alloc]init];
    [headImageView addSubview:self.moneyLabel];
    self.moneyLabel.frame = CGRectMake(0, 200, 350, 20);
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.textColor = [UIColor whiteColor];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_money"]) {
        self.moneyLabel.hidden = NO;
        self.moneyLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"User_money"]];
    }else{
        self.moneyLabel.hidden = YES;
    }
    self.moneyLabel.font = DEF_FontSize_18;
    
    self.moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headImageView addSubview:self.moneyBtn];
    self.moneyBtn.frame = CGRectMake(230, 195, 80, 30);
    [self.moneyBtn setTitle:@"提现" forState:UIControlStateNormal];
    [self.moneyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.moneyBtn setBackgroundColor:[UIColor whiteColor]];
    self.moneyBtn.layer.masksToBounds = YES;
    self.moneyBtn.layer.cornerRadius = 5;
    [self.moneyBtn addTarget:self action:@selector(moneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setTableView{

    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 250, 350, SCREENHEIGHT-314);
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]) {
        switch (indexPath.row) {
            case 0:
            {
                ComeRunViewController *vc = [[ComeRunViewController alloc]init];
                vc.delegate = self;
                [self.slideMenuController changeMainViewController:[[UINavigationController alloc] initWithRootViewController: vc] close:YES];
            }
                break;
            case 1:
            {

                TrajectoryViewController *vc = [[TrajectoryViewController alloc]init];
                vc.delegate = self;
                [self.slideMenuController changeMainViewController:[[UINavigationController alloc] initWithRootViewController: vc] close:YES];
            }
                break;
            case 2:
            {
                RedPacketRecordViewController *vc = [[RedPacketRecordViewController alloc]init];
                vc.delegate = self;
                [self.slideMenuController changeMainViewController:[[UINavigationController alloc] initWithRootViewController: vc] close:YES];
            }
                break;
            case 3:
            {
                GetMoneyRecordViewController *vc = [[GetMoneyRecordViewController alloc]init];
                vc.delegate = self;
                [self.slideMenuController changeMainViewController:[[UINavigationController alloc] initWithRootViewController: vc] close:YES];
            }
                break;
            case 4:
            {
                BalanceViewController *vc = [[BalanceViewController alloc]init];
                vc.delegate = self;
                [self.slideMenuController changeMainViewController:[[UINavigationController alloc] initWithRootViewController: vc] close:YES];
            }
                break;
            case 5:
            {
                [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_token"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_type"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_name"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_money"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_img"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_openid"];
                [self showMessage:@"退出登录"];
                [self.headImgView setBackgroundImage:[UIImage imageNamed:@"点击登录"] forState:UIControlStateNormal];
                self.nameLabel.hidden = YES;
                self.moneyLabel.hidden = YES;
                //            self.headImgView.enabled = YES;
            }
                break;
                
            default:
                break;
        }
    }else{
        if (indexPath.row == 5) {
            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_token"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_type"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_name"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_money"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_img"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User_openid"];
            [self showMessage:@"退出登录"];
            [self.headImgView setBackgroundImage:[UIImage imageNamed:@"点击登录"] forState:UIControlStateNormal];
            self.nameLabel.hidden = YES;
            self.moneyLabel.hidden = YES;
            //            self.headImgView.enabled = YES;
        }else{
            [self showMessage:@"请登录"];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftTableViewCell *cell = [LeftTableViewCell cellForTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeViewController{

    [self.slideMenuController changeMainViewController:self.mainViewControler close:YES];
}

#pragma mark - click

-(void)moneyBtnClick:(id)send{
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"User_type"] isEqualToString:@"1"]) {
        GetMoneyViewController *vc = [[GetMoneyViewController alloc]init];
        vc.delegate = self;
        [self.slideMenuController changeMainViewController:[[UINavigationController alloc] initWithRootViewController: vc] close:YES];
    }else{
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请绑定微信提现"
                                                                                 message:@"绑定成功后，只能使用微信登录"
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        
        //添加取消到UIAlertController中
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        
        //添加确定到UIAlertController中
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                //登录
                [ShareSDK getUserInfo:SSDKPlatformTypeWechat
                       onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
                 {
                     if (state == SSDKResponseStateSuccess)
                     {
                         
                         NSLog(@"uid=%@",[user.credential.rawData objectForKey:@"access_token"]);
                         NSLog(@"%@",[user.credential.rawData objectForKey:@"unionid"]);
                         NSLog(@"token=%@",[user.credential.rawData objectForKey:@"openid"]);
                         
                         AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                         
                         manager.responseSerializer = [AFJSONResponseSerializer serializer];
                         
                         manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                         // 拼接请求参数
                         NSDictionary *params = @{@"access_token":[user.credential.rawData objectForKey:@"access_token"],@"unionid":[user.credential.rawData objectForKey:@"unionid"],@"openid":[user.credential.rawData objectForKey:@"openid"],
                                                  @"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]};
                         
                         [manager POST:@"http://yuebu.tcgqxx.com/api/user/boundweixin" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             NSLog(@"%@",responseObject);
            
                             [self.headImgView sd_setBackgroundImageWithURL:[[responseObject objectForKey:@"data"] objectForKey:@"headimgurl"] forState:UIControlStateNormal];
                             self.nameLabel.text = [[responseObject objectForKey:@"data"] objectForKey:@"nickname"];
            
                             [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"nickname"] forKey:@"User_name"];
                             
                             [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"token"] forKey:@"User_token"];
                             
                             [[NSUserDefaults standardUserDefaults] setObject:[user.credential.rawData objectForKey:@"openid"] forKey:@"User_openid"];
                             
//                             [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"money"] forKey:@"User_money"];
                             
                             [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"headimgurl"] forKey:@"User_img"];
                             
                             
                             AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
                             
                             manager2.responseSerializer = [AFJSONResponseSerializer serializer];
                             
                             manager2.requestSerializer=[AFHTTPRequestSerializer serializer];
                             // 拼接请求参数
                             
                             NSDictionary *params2 = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]};
                             
                             [manager2 POST:@"http://yuebu.tcgqxx.com/api/user/userinfo" parameters:params2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 self.moneyLabel.text = [NSString stringWithFormat:@"%@元",[[responseObject objectForKey:@"result"] objectForKey:@"money"]];
                                 [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"result"] objectForKey:@"money"] forKey:@"User_money"];
                                 
                                 self.nameLabel.text = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"result"] objectForKey:@"nick_name"]];
                                 
                                 if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_name"]) {
                                     self.nameLabel.hidden = NO;
                                 }
                                 
                                 if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_money"]) {
                                     self.moneyLabel.hidden = NO;
                                 }
                                 
                                 [self.headImgView sd_setBackgroundImageWithURL:[[NSUserDefaults standardUserDefaults] valueForKey:@"User_img"] forState:UIControlStateNormal];
                                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 
                             }];
                             
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             NSLog(@"%@",error);
                         }];
                     }
                     
                     else
                     {
                         NSLog(@"%@",error);
                     }
                     
                 }];
            }else{
            
                [self showMessage:@"设备中并未安装微信"];
            }
        }];
        [alertController addAction:OKAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)loginClick:(id)send{

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]);
    }else{
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            //登录
            [ShareSDK getUserInfo:SSDKPlatformTypeWechat
                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
             {
                 if (state == SSDKResponseStateSuccess)
                 {
                     
                     NSLog(@"uid=%@",[user.credential.rawData objectForKey:@"access_token"]);
                     NSLog(@"%@",[user.credential.rawData objectForKey:@"unionid"]);
                     NSLog(@"token=%@",[user.credential.rawData objectForKey:@"openid"]);
                     
                     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                     
                     manager.responseSerializer = [AFJSONResponseSerializer serializer];
                     
                     manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                     // 拼接请求参数
                     NSDictionary *params = @{@"type":@"1",@"access_token":[user.credential.rawData objectForKey:@"access_token"],@"unionid":[user.credential.rawData objectForKey:@"unionid"],@"openid":[user.credential.rawData objectForKey:@"openid"]};
                     
                     [manager POST:@"http://yuebu.tcgqxx.com/api/login/login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"%@",responseObject);
                         [self.headImgView sd_setBackgroundImageWithURL:[[responseObject objectForKey:@"data"] objectForKey:@"headimgurl"] forState:UIControlStateNormal];
                         self.nameLabel.text = [[responseObject objectForKey:@"data"] objectForKey:@"nick_name"];
                         self.moneyLabel.text = [NSString stringWithFormat:@"%@元",[[responseObject objectForKey:@"data"] objectForKey:@"money"]];
                         self.nameLabel.hidden = NO;
                         self.moneyLabel.hidden = NO;
                         //                     self.headImgView.enabled = NO;
                         [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"nick_name"] forKey:@"User_name"];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"User_type"];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"token"] forKey:@"User_token"];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:[user.credential.rawData objectForKey:@"openid"] forKey:@"User_openid"];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"money"] forKey:@"User_money"];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"headimgurl"] forKey:@"User_img"];
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"%@",error);
                     }];
                 }
                 
                 else
                 {
                     NSLog(@"%@",error);
                 }
                 
             }];
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
            
            vc.delegate = self;
            [self.slideMenuController changeMainViewController:[[UINavigationController alloc] initWithRootViewController: vc] close:YES];
            
        }
        
        
        
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
