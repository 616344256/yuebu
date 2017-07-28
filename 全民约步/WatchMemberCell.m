//
//  WatchMembercell.m
//  全民约步
//
//  Created by 姜祺 on 17/6/15.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "WatchMemberCell.h"
#import "UIImageView+WebCache.h"
@interface WatchMemberCell()
@property(strong,nonatomic)UIImageView *headImgView;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *hideLabel;
@end

@implementation WatchMemberCell

-(id)initWithCellIdentifier:(NSString *)cellID{
    
    if (self = [super initWithCellIdentifier:cellID]) {
        if([self respondsToSelector:@selector(setSeparatorInset:)]){
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if([self respondsToSelector:@selector(setLayoutMargins:)]){
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        
        self.headImgView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.headImgView];
        
        self.nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLabel];
        
        self.hideLabel = [[UILabel alloc]init];
//        [self.contentView addSubview:self.hideLabel];
        
//        UILabel *hideLabel = [[UILabel alloc]init];
//        [self.contentView addSubview:hideLabel];
//        hideLabel.frame = CGRectMake(SCREENWIGTH - 120, 10, 40, 40);
//        hideLabel.text = @"今日步数";
//        hideLabel.font = DEF_FontSize_14;
//        hideLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    [super layoutSubviews];
    
    self.headImgView.frame = CGRectMake(10, 10, 40, 40);
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 20;
 
    self.nameLabel.frame = CGRectMake(60, 20, 250, 20);
    
    self.hideLabel.frame = CGRectMake(SCREENWIGTH - 80, 10, 60, 40);
    
    self.hideLabel.font = DEF_FontSize_14;
    self.hideLabel.textAlignment = NSTextAlignmentLeft;
    self.hideLabel.textColor = getColor(@"f25350");
    
}

-(void)setModel:(NSDictionary *)model{
    
    _model = model;
    self.nameLabel.text = [_model objectForKey:@"nick_name"];
    [self.headImgView sd_setImageWithURL:[_model objectForKey:@"headimgurl"] placeholderImage:[UIImage imageNamed:@"head"]];
//    self.hideLabel.text = [NSString stringWithFormat:@"%@",[_model objectForKey:@"walking_num"]];
    
}

@end
