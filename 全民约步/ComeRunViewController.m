//
//  ComeRunViewController.m
//  全民约步
//
//  Created by 姜祺 on 17/6/6.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "ComeRunViewController.h"
#import "IComeTableViewCell.h"
#import "IJoinTableViewCell.h"
#import "ISetUpTableViewCell.h"
#import "WalkDetailsViewController.h"
#import "NewYueBuViewController.h"
#import <AFNetworking.h>
#import <AMapNaviKit/AMapNaviKit.h>
@interface ComeRunViewController ()<UIScrollViewDelegate,UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic,strong)UIButton *reviewBtn;//我约按钮
@property (nonatomic,strong)UIButton *synopsisBtn;//我来参加按钮
@property (nonatomic,strong)UIButton *recommendBtn;//我参加的按钮
@property(nonatomic,strong)UIButton *backBtn;
@property (strong,nonatomic)UIScrollView *scrollView;//滑动
@property(strong,nonatomic)UIView *underLineView;
@property (nonatomic,strong)UITableView *firTableView;//评论tableview
@property (nonatomic,strong)UITableView *secTableView;//评论tableview
@property (nonatomic,strong)UITableView *thrTableView;//评论tableview
@property (nonatomic,strong)NSMutableArray *firArr;
@property (nonatomic,strong)NSMutableArray *secArr;
@property (nonatomic,strong)NSMutableArray *thrArr;
@end

@implementation ComeRunViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 20, 20);
    [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *Button1 = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = Button1;
    
    self.title = @"谁来约步";
    self.view.backgroundColor = [UIColor whiteColor];
    self.firArr = [[NSMutableArray alloc]init];
    self.secArr = [[NSMutableArray alloc]init];
    self.thrArr = [[NSMutableArray alloc]init];
 
    [self setBtn];
    [self setScrollView];
    [self setTableView];
}

-(void)getData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    NSDictionary *params = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"type":@"1"};
    [manager POST:@"http://yuebu.tcgqxx.com/api/yuebu/yuebu_list" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.firArr = [responseObject objectForKey:@"result"];
        [self.firTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    
    manager1.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager1.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    NSDictionary *params1 = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"],@"type":@"0"};
    [manager1 POST:@"http://yuebu.tcgqxx.com/api/yuebu/yuebu_list" parameters:params1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.secArr = [responseObject objectForKey:@"result"];
        [self.secTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
    
    manager2.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager2.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    NSDictionary *params2 = @{@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"User_token"]};
    [manager2 POST:@"http://yuebu.tcgqxx.com/api/yuebu/yuebu_join_list" parameters:params2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.thrArr = [responseObject objectForKey:@"result"];
        [self.thrTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
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
    self.reviewBtn.frame = CGRectMake(0, 0, SCREENWIGTH / 3 , 50);
    [self.reviewBtn setTitle:@"我约" forState:UIControlStateNormal];
    self.reviewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.reviewBtn setTitleColor:getColor(@"f35451") forState:UIControlStateNormal];

    [self.view addSubview:self.reviewBtn];
    [self.reviewBtn addTarget:self action:@selector(reviewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviewBtn setBackgroundColor:[UIColor whiteColor]];
    
    self.synopsisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.synopsisBtn.frame = CGRectMake(SCREENWIGTH / 3 - 1 , 0, SCREENWIGTH / 3 , 50);
    [self.synopsisBtn setTitle:@"我来参加" forState:UIControlStateNormal];
    self.synopsisBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.synopsisBtn setTitleColor:getColor(@"f35451") forState:UIControlStateNormal];

    [self.view addSubview:self.synopsisBtn];
    [self.synopsisBtn addTarget:self action:@selector(synopsisBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.synopsisBtn setBackgroundColor:[UIColor whiteColor]];
    
    self.recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recommendBtn.frame = CGRectMake(SCREENWIGTH *2 / 3 - 2 , 0, SCREENWIGTH /3 + 2, 50);
    [self.recommendBtn setTitle:@"我参加的" forState:UIControlStateNormal];
    self.recommendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.recommendBtn setTitleColor:getColor(@"f35451") forState:UIControlStateNormal];

    [self.view addSubview:self.recommendBtn];
    [self.recommendBtn addTarget:self action:@selector(recommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.recommendBtn setBackgroundColor:[UIColor whiteColor]];
    
    self.underLineView = [[UIView alloc]init];
    [self.view addSubview:self.underLineView];
    self.underLineView.frame = CGRectMake(0, 51, SCREENWIGTH/3, 2);
    self.underLineView.backgroundColor = getColor(@"f35451");
    
    UIView *lineView = [[UIView alloc]init];
    [self.view addSubview:lineView];
    lineView.frame = CGRectMake(0, 54, SCREENWIGTH, 1);
    lineView.backgroundColor = getColor(@"cccccc");

}

-(void)setScrollView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 55, SCREENWIGTH, SCREENHEIGHT -64-54)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    // 是否支持滑动最顶端
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    // 设置内容大小
    self.scrollView.contentSize = CGSizeMake(SCREENWIGTH * 3, 0);
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
                      CGRectMake(0, 0, SCREENWIGTH, SCREENHEIGHT -64-54)];
    
    self.firTableView.delegate = self;
    self.firTableView.dataSource = self;
//    self.firTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.firTableView.tableFooterView = [[UIView alloc]init];
    self.firTableView.rowHeight = 60;
    [self.scrollView addSubview:self.firTableView];
    
    self.secTableView = [[UITableView alloc] initWithFrame:
                         CGRectMake(SCREENWIGTH, 0, SCREENWIGTH, SCREENHEIGHT -64-54)];
    
    self.secTableView.delegate = self;
    self.secTableView.dataSource = self;
//    self.secTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.secTableView.tableFooterView = [[UIView alloc]init];
    self.secTableView.rowHeight = 60;
    [self.scrollView addSubview:self.secTableView];
    
    self.thrTableView = [[UITableView alloc] initWithFrame:
                         CGRectMake(SCREENWIGTH *2, 0, SCREENWIGTH, SCREENHEIGHT -64-54)];
    
    self.thrTableView.delegate = self;
    self.thrTableView.dataSource = self;
//    self.thrTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.thrTableView.tableFooterView = [[UIView alloc]init];
    self.thrTableView.rowHeight = 60;
    [self.scrollView addSubview:self.thrTableView];

}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.firTableView == tableView) {
        WalkDetailsViewController *vc = [[WalkDetailsViewController alloc]init];
        vc.jumpState = kMake;
        AMapNaviPoint *startPoint = [[AMapNaviPoint alloc]init];
        startPoint.longitude = [[self.firArr[indexPath.row] objectForKey:@"start_x"] floatValue];
        startPoint.latitude = [[self.firArr[indexPath.row] objectForKey:@"start_y"] floatValue];
        AMapNaviPoint *endPoint = [[AMapNaviPoint alloc]init];
        endPoint.longitude = [[self.firArr[indexPath.row] objectForKey:@"end_x"] floatValue];
        endPoint.latitude = [[self.firArr[indexPath.row] objectForKey:@"end_y"] floatValue];
        vc.startPoint = startPoint;
        vc.endPoint = endPoint;
        vc.model = @{@"startAddress":[self.firArr[indexPath.row] objectForKey:@"start_address"],@"endAddress":[self.firArr[indexPath.row] objectForKey:@"end_address"],@"title":[self.firArr[indexPath.row] objectForKey:@"title"],@"time":[self.firArr[indexPath.row] objectForKey:@"time"],@"id":[NSString stringWithFormat:@"%@",[self.firArr[indexPath.row] objectForKey:@"id"]]};
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.secTableView == tableView){
        WalkDetailsViewController *vc = [[WalkDetailsViewController alloc]init];
        vc.jumpState = kWantAdd;
        AMapNaviPoint *startPoint = [[AMapNaviPoint alloc]init];
        startPoint.longitude = [[self.secArr[indexPath.row] objectForKey:@"start_x"] floatValue];
        startPoint.latitude = [[self.secArr[indexPath.row] objectForKey:@"start_y"] floatValue];
        AMapNaviPoint *endPoint = [[AMapNaviPoint alloc]init];
        endPoint.longitude = [[self.secArr[indexPath.row] objectForKey:@"end_x"] floatValue];
        endPoint.latitude = [[self.secArr[indexPath.row] objectForKey:@"end_y"] floatValue];
        vc.startPoint = startPoint;
        vc.endPoint = endPoint;
        vc.model = @{@"startAddress":[self.secArr[indexPath.row] objectForKey:@"start_address"],@"endAddress":[self.secArr[indexPath.row] objectForKey:@"end_address"],@"title":[self.secArr[indexPath.row] objectForKey:@"title"],@"time":[self.secArr[indexPath.row] objectForKey:@"time"],@"id":[self.secArr[indexPath.row] objectForKey:@"id"]};
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.thrTableView == tableView){
        WalkDetailsViewController *vc = [[WalkDetailsViewController alloc]init];
        vc.jumpState = kAdd;
        AMapNaviPoint *startPoint = [[AMapNaviPoint alloc]init];
        startPoint.longitude = [[self.thrArr[indexPath.row] objectForKey:@"start_x"] floatValue];
        startPoint.latitude = [[self.thrArr[indexPath.row] objectForKey:@"start_y"] floatValue];
        AMapNaviPoint *endPoint = [[AMapNaviPoint alloc]init];
        endPoint.longitude = [[self.thrArr[indexPath.row] objectForKey:@"end_x"] floatValue];
        endPoint.latitude = [[self.thrArr[indexPath.row] objectForKey:@"end_y"] floatValue];
        vc.startPoint = startPoint;
        vc.endPoint = endPoint;
        vc.model = @{@"startAddress":[self.thrArr[indexPath.row] objectForKey:@"start_address"],@"endAddress":[self.thrArr[indexPath.row] objectForKey:@"end_address"],@"title":[self.thrArr[indexPath.row] objectForKey:@"title"],@"time":[self.thrArr[indexPath.row] objectForKey:@"time"],@"id":[self.thrArr[indexPath.row] objectForKey:@"id"]};
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.firTableView) {
        return self.firArr.count;
        
    }else if (tableView == self.secTableView){
   
        return self.secArr.count;
    }else if (tableView == self.thrTableView){
        
        return self.thrArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.firTableView) {
        IComeTableViewCell *cell = [IComeTableViewCell cellForTableView:tableView];
        cell.model = self.firArr[indexPath.row];
        return cell;
    }else if (tableView == self.secTableView){
     
        IJoinTableViewCell *cell = [IJoinTableViewCell cellForTableView:tableView];
        cell.model = self.secArr[indexPath.row];
        return cell;
    }else if (tableView == self.thrTableView){
        
        ISetUpTableViewCell *cell = [ISetUpTableViewCell cellForTableView:tableView];
        cell.model = self.thrArr[indexPath.row];
        return cell;
    }
    return nil;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
        CGFloat coefficient = _scrollView.contentOffset.x / SCREENWIGTH;
        if (coefficient < 1) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.underLineView.frame = CGRectMake(0, 51, SCREENWIGTH/3, 2);
                
            } completion:^(BOOL finished) {
            }];
        }else if (coefficient < 2){
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
               self.underLineView.frame = CGRectMake(SCREENWIGTH/3, 51, SCREENWIGTH/3, 2);
            } completion:^(BOOL finished) {
            }];
        }else if (coefficient < 3){
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.underLineView.frame = CGRectMake(SCREENWIGTH*2/3, 51, SCREENWIGTH/3, 2);
            } completion:^(BOOL finished) {
            }];
        }
    }
}

#pragma mark - click

-(void)addBtnClick:(id)send{

    NewYueBuViewController *vc = [[NewYueBuViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)reviewBtnClick:(id)send{
    
    self.scrollView.contentOffset = CGPointMake(SCREENWIGTH * 0.0, 0);
}

-(void)synopsisBtnClick:(id)send{

    self.scrollView.contentOffset = CGPointMake(SCREENWIGTH * 1.0, 0);
}

-(void)recommendBtnClick:(id)send{
    
    self.scrollView.contentOffset = CGPointMake(SCREENWIGTH * 2.0, 0);
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
