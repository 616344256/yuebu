//
//  RedPacketDetailsViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "RedPacketDetailsViewController.h"
#import "RedPacketDetailsTableViewCell.h"
#import <AFNetworking.h>
@interface RedPacketDetailsViewController ()<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic,strong)UITableView *firTableView;//评论tableview
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation RedPacketDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"领取详情";
    [self setTableView];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"id":self.kid};
    [manager POST:@"http://yuebu.tcgqxx.com/api/hongbao/get_hongbao" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.dataArr = [responseObject objectForKey:@"result"];
        [self.firTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPacketDetailsTableViewCell *cell = [RedPacketDetailsTableViewCell cellForTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

@end
