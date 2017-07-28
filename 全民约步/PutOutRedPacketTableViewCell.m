//
//  PutOutRedPacketTableViewCell.m
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "PutOutRedPacketTableViewCell.h"

@interface PutOutRedPacketTableViewCell()
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *moneyLabel;
@property(strong,nonatomic)UILabel *timeLabel;
@end

@implementation PutOutRedPacketTableViewCell

-(id)initWithCellIdentifier:(NSString *)cellID{
    
    if (self = [super initWithCellIdentifier:cellID]) {
        if([self respondsToSelector:@selector(setSeparatorInset:)]){
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if([self respondsToSelector:@selector(setLayoutMargins:)]){
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        self.nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLabel];
        
        self.moneyLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.moneyLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(10, 10, 250, 20);

    self.timeLabel.frame = CGRectMake(10, 35, SCREENWIGTH, 20);
    self.timeLabel.font = DEF_FontSize_14;
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textColor = getColor(@"888888");
    
    self.moneyLabel.frame = CGRectMake(SCREENWIGTH - 100, 10, 80, 40);
    self.moneyLabel.font = DEF_FontSize_14;
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    
    
}

-(void)setModel:(NSDictionary *)model{
    
    _model = model;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",[_model objectForKey:@"money"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[_model objectForKey:@"create_time"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[_model objectForKey:@"title"]];
}
@end
