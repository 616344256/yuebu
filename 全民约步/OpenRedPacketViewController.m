//
//  OpenRedPacketViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "OpenRedPacketViewController.h"
#import "OpenRedPacketTableViewCell.h"
#import <AFNetworking.h>
#import "RedPacketsView.h"
@interface OpenRedPacketViewController ()<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic,strong)UITableView *firTableView;//评论tableview
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation OpenRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开红包";
    self.dataArr = [[NSMutableArray alloc]init];
    
    [self refush];
    [self setTableView];
}

-(void)refush{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    // 拼接请求参数
    NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"type":@"1"};
    [manager POST:@"http://yuebu.tcgqxx.com/api/hongbao/shou_hongbao" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.dataArr = [[responseObject objectForKey:@"result"] objectForKey:@"data"];
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
    
    RedPacketsView *view = [[RedPacketsView alloc]init];
    view.frame = CGRectMake(0, 0, SCREENWIGTH, SCREENHEIGHT);
    view.data = @{@"img":[self.dataArr[indexPath.row] objectForKey:@"img"],@"title":[self.dataArr[indexPath.row] objectForKey:@"title"] };
    __typeof(view) weakview = view;
    view.pass = ^(NSString *kid){
        NSLog(@"抢红包");
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        
        NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"hongbao_id":[self.dataArr[indexPath.row] objectForKey:@"id"]};
        
        [manager POST:@"http://yuebu.tcgqxx.com/api/hongbao/open_hongbao" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [self showMessage:[responseObject objectForKey:@"msg"]];
            [weakview removeFromSuperview];
            [self refush];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    };
    
    [self.view addSubview:view];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OpenRedPacketTableViewCell *cell = [OpenRedPacketTableViewCell cellForTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    
    return cell;
}

@end
