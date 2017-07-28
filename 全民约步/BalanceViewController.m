//
//  BalanceViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "BalanceViewController.h"
#import "BalanceTableViewCell.h"
#import <AFNetworking.h>
@interface BalanceViewController ()<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic,strong)UITableView *firTableView;//评论tableview
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额明细";
    self.dataArr = [[NSMutableArray alloc]init];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    // 拼接请求参数
    NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]};
    [manager POST:@"http://yuebu.tcgqxx.com/api/money/money_info" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.dataArr = [responseObject objectForKey:@"result"];
        [self.firTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
     [self setTableView];
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

-(void)setTableView{
    
    self.firTableView = [[UITableView alloc] initWithFrame:
                         CGRectMake(0, 0, SCREENWIGTH, SCREENHEIGHT -64)];
    
    self.firTableView.delegate = self;
    self.firTableView.dataSource = self;
    //    self.firTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.firTableView.tableFooterView = [[UIView alloc]init];
    self.firTableView.rowHeight = 60;
    [self.view addSubview:self.firTableView];
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BalanceTableViewCell *cell = [BalanceTableViewCell cellForTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)backBtnClick:(id)send{
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(changeViewController)]) {
        [_delegate changeViewController];
    }
}

@end
