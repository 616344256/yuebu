//
//  RedPacketDetailsTableViewCell.m
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "RedPacketDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface RedPacketDetailsTableViewCell ()
@property(strong,nonatomic)UIImageView *headImgView;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *hideLabel;
@property(strong,nonatomic)UILabel *timeLabel;
@end
@implementation RedPacketDetailsTableViewCell

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
        [self.contentView addSubview:self.hideLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLabel];
        
        UILabel *hideLabel = [[UILabel alloc]init];
        [self.contentView addSubview:hideLabel];
        hideLabel.frame = CGRectMake(SCREENWIGTH - 120, 15, 40, 20);
        hideLabel.text = @"领取";
        hideLabel.font = DEF_FontSize_16;
        hideLabel.textAlignment = NSTextAlignmentRight;
        
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
    
    self.timeLabel.frame = CGRectMake(SCREENWIGTH - 180, 35, 160, 20);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = DEF_FontSize_14;
    
    self.hideLabel.frame = CGRectMake(SCREENWIGTH - 80, 15, 60, 20);

    self.hideLabel.font = DEF_FontSize_16;
    self.hideLabel.textAlignment = NSTextAlignmentLeft;
    self.hideLabel.textColor = getColor(@"f25350");
    
}

-(void)setModel:(NSDictionary *)model{
    
    _model = model;
     self.nameLabel.text = [_model objectForKey:@"nick_name"];
    [self.headImgView sd_setImageWithURL:[_model objectForKey:@"headimgurl"] placeholderImage:[UIImage imageNamed:@"head"]];
    self.hideLabel.text = [NSString stringWithFormat:@"%@元",[_model objectForKey:@"money"]];
    self.timeLabel.text = [_model objectForKey:@"open_time"];
}

@end
