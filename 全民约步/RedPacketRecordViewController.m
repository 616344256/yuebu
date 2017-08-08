//
//  RedPacketRecordViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "RedPacketRecordViewController.h"
#import "GetRedPacketTableViewCell.h"
#import "PutOutRedPacketTableViewCell.h"
#import "RedPacketDetailsViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
@interface RedPacketRecordViewController (){

    NSString *getMoney;
    NSString *putMoney;
}
@property (nonatomic,strong)UIButton *reviewBtn;//我约按钮
@property (nonatomic,strong)UIButton *synopsisBtn;//我来参加按钮
@property(nonatomic,strong)UIButton *backBtn;
@property (strong,nonatomic)UIScrollView *scrollView;//滑动
@property(strong,nonatomic)UIView *underLineView;
@property (nonatomic,strong)UITableView *firTableView;//评论tableview
@property (nonatomic,strong)UITableView *secTableView;//评论tableview
@property(nonatomic,strong)UIImageView *headImgView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,strong)NSMutableArray *shouArr;
@property(nonatomic,strong)NSMutableArray *faArr;
@end

@implementation RedPacketRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包记录";
    [self setHeadView];
    self.shouArr = [[NSMutableArray alloc]init];
    self.faArr = [[NSMutableArray alloc]init];
    [self AFNetWorking];
    [self setBtn];
    [self setScrollView];
    [self setTableView];
   
}

-(void)AFNetWorking{
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    
    manager1.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager1.requestSerializer=[AFHTTPRequestSerializer serializer];
    // 拼接请求参数
    NSDictionary *params1 = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"type":@"2"};
    [manager1 POST:@"http://yuebu.tcgqxx.com/api/hongbao/shou_hongbao" parameters:params1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"result"] count] != 0) {
            getMoney = [[responseObject objectForKey:@"result"] objectForKey:@"total"];
            self.moneyLabel.text = [NSString stringWithFormat:@"%@元",getMoney];
            self.shouArr = [[responseObject objectForKey:@"result"] objectForKey:@"data"];
            [self.firTableView reloadData];
            self.numLabel.text = [NSString stringWithFormat:@"%lu个",(unsigned long)self.shouArr.count];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    // 拼接请求参数
    NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]};
    [manager POST:@"http://yuebu.tcgqxx.com/api/hongbao/fasong_hongbao" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"result"] count] != 0) {
            putMoney = [[responseObject objectForKey:@"result"] objectForKey:@"total"];
            self.faArr = [[responseObject objectForKey:@"result"] objectForKey:@"data"];
            [self.secTableView reloadData];
        }else{
            putMoney = @"0";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
    
    manager2.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager2.requestSerializer=[AFHTTPRequestSerializer serializer];
    // 拼接请求参数
    NSDictionary *params2 = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]};
    
    [manager2 POST:@"http://yuebu.tcgqxx.com/api/user/userinfo" parameters:params2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[[responseObject objectForKey:@"result"] objectForKey:@"headimgurl"]] placeholderImage:[UIImage imageNamed:@"head"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"result"] objectForKey:@"money"] forKey:@"User_money"];
        self.nameLabel.text = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"result"] objectForKey:@"nick_name"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)setHeadView{

    self.headImgView = [[UIImageView alloc]init];
    [self.view addSubview:self.headImgView];
    self.headImgView.frame = CGRectMake(SCREENWIGTH / 2 - 50, 70, 100, 100);
    
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 50;
    
    self.nameLabel = [[UILabel alloc]init];
    [self.view addSubview:self.nameLabel];
    self.nameLabel.frame = CGRectMake(0, 190, SCREENWIGTH, 20);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor blackColor];
   
    self.nameLabel.font = DEF_FontSize_18;

    
    self.moneyLabel = [[UILabel alloc]init];
    [self.view addSubview:self.moneyLabel];
    self.moneyLabel.frame = CGRectMake(0, 220, SCREENWIGTH, 40);
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.textColor = getColor(@"f35451");

    self.moneyLabel.font = [UIFont systemFontOfSize:40];

    
    self.numLabel = [[UILabel alloc]init];
    [self.view addSubview:self.numLabel];
    self.numLabel.frame = CGRectMake(0, 270, SCREENWIGTH, 20);
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.textColor = getColor(@"666666");
    self.numLabel.font = DEF_FontSize_16;
}

-(void)setBtn{
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 0, 20, 20);
    
    [self.backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *Button = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = Button;
    
    
    self.reviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reviewBtn.frame = CGRectMake(0, 0, SCREENWIGTH / 2 , 50);
    [self.reviewBtn setTitle:@"我收到的红包" forState:UIControlStateNormal];
    self.reviewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.reviewBtn setTitleColor:getColor(@"f35451") forState:UIControlStateNormal];
    
    [self.view addSubview:self.reviewBtn];
    [self.reviewBtn addTarget:self action:@selector(reviewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviewBtn setBackgroundColor:[UIColor whiteColor]];
    
    self.synopsisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.synopsisBtn.frame = CGRectMake(SCREENWIGTH / 2 - 1 , 0, SCREENWIGTH / 2 , 50);
    [self.synopsisBtn setTitle:@"已发出的红包" forState:UIControlStateNormal];
    self.synopsisBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.synopsisBtn setTitleColor:getColor(@"f35451") forState:UIControlStateNormal];
    
    [self.view addSubview:self.synopsisBtn];
    [self.synopsisBtn addTarget:self action:@selector(synopsisBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.synopsisBtn setBackgroundColor:[UIColor whiteColor]];
    
    
    self.underLineView = [[UIView alloc]init];
    [self.view addSubview:self.underLineView];
    self.underLineView.frame = CGRectMake(0, 51, SCREENWIGTH/2, 2);
    self.underLineView.backgroundColor = getColor(@"f35451");
    
}

-(void)setScrollView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, SCREENWIGTH, SCREENHEIGHT -64-300)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    // 是否支持滑动最顶端
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    // 设置内容大小
    self.scrollView.contentSize = CGSizeMake(SCREENWIGTH * 2, 0);
    // 是否反弹
    self.scrollView.bounces = NO;
    // 是否分页
    self.scrollView.pagingEnabled = YES;
    // 是否滚动
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    // 设置indicator风格
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 设置内容的边缘和Indicators边缘
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    // 提示用户,Indicators flash
    //    [scrollView flashScrollIndicators];
    // 是否同时运动,lock
    self.scrollView.directionalLockEnabled = YES;
    [self.view addSubview:self.scrollView];
}

-(void)setTableView{
    
    self.firTableView = [[UITableView alloc] initWithFrame:
                         CGRectMake(0, 0, SCREENWIGTH, SCREENHEIGHT -64-300)];
    
    self.firTableView.delegate = self;
    self.firTableView.dataSource = self;
    //    self.firTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.firTableView.tableFooterView = [[UIView alloc]init];
    self.firTableView.rowHeight = 60;
    [self.scrollView addSubview:self.firTableView];
    
    self.secTableView = [[UITableView alloc] initWithFrame:
                         CGRectMake(SCREENWIGTH, 0, SCREENWIGTH, SCREENHEIGHT -64-300)];
    
    self.secTableView.delegate = self;
    self.secTableView.dataSource = self;
    //    self.secTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.secTableView.tableFooterView = [[UIView alloc]init];
    self.secTableView.rowHeight = 60;
    [self.scrollView addSubview:self.secTableView];
    
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.secTableView == tableView) {
        RedPacketDetailsViewController *vc = [[RedPacketDetailsViewController alloc]init];
        vc.kid = [self.faArr[indexPath.row] objectForKey:@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.firTableView) {
        return self.shouArr.count;
        
    }else if (tableView == self.secTableView){
        
        return self.faArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.firTableView) {
        GetRedPacketTableViewCell *cell = [GetRedPacketTableViewCell cellForTableView:tableView];
        cell.model = self.shouArr[indexPath.row];
        return cell;
    }else if (tableView == self.secTableView){
        
        PutOutRedPacketTableViewCell *cell = [PutOutRedPacketTableViewCell cellForTableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.model = self.faArr[indexPath.row];
        return cell;
    }
    return nil;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
        CGFloat coefficient = _scrollView.contentOffset.x / SCREENWIGTH;
        if (coefficient < 1) {
            self.numLabel.text = [NSString stringWithFormat:@"%lu个",(unsigned long)self.shouArr.count];
            self.moneyLabel.text = [NSString stringWithFormat:@"%@元",getMoney];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.underLineView.frame = CGRectMake(0, 51, SCREENWIGTH/2, 2);
                
            } completion:^(BOOL finished) {
            }];
        }else if (coefficient < 2){
            self.numLabel.text = [NSString stringWithFormat:@"%lu个",(unsigned long)self.faArr.count];
            self.moneyLabel.text = [NSString stringWithFormat:@"%@元",putMoney];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.underLineView.frame = CGRectMake(SCREENWIGTH/2, 51, SCREENWIGTH/2, 2);
            } completion:^(BOOL finished) {
            }];
        }
    }
}

#pragma mark - click

-(void)reviewBtnClick:(id)send{
    
    self.scrollView.contentOffset = CGPointMake(SCREENWIGTH * 0.0, 0);
}

-(void)synopsisBtnClick:(id)send{
    
    self.scrollView.contentOffset = CGPointMake(SCREENWIGTH * 1.0, 0);
}

-(void)backBtnClick:(id)send{
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(changeViewController)]) {
        [_delegate changeViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
