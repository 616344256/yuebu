//
//  WatchMemberViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/15.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "WatchMemberViewController.h"
#import "WatchMemberCell.h"
#import <AFNetworking.h>
@interface WatchMemberViewController ()<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic,strong)UITableView *firTableView;//评论tableview
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation WatchMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"约步成员";
    self.dataArr = [[NSMutableArray alloc]init];
    [self setTableView];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"id":self.kid};
    [manager POST:@"http://yuebu.tcgqxx.com/api/yuebu/yuebu_join_list" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    WatchMemberCell *cell = [WatchMemberCell cellForTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

@end
