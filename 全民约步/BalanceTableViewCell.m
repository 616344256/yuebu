//
//  BalanceTableViewCell.m
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "BalanceTableViewCell.h"

@interface BalanceTableViewCell()
@property(strong,nonatomic)UILabel *moneyLabel;
@property(strong,nonatomic)UILabel *stateLabel;
@property(strong,nonatomic)UILabel *timeLabel;
@end

@implementation BalanceTableViewCell

-(id)initWithCellIdentifier:(NSString *)cellID{
    
    if (self = [super initWithCellIdentifier:cellID]) {
        if([self respondsToSelector:@selector(setSeparatorInset:)]){
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if([self respondsToSelector:@selector(setLayoutMargins:)]){
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        
        self.moneyLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.moneyLabel];
        
        self.stateLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.stateLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    [super layoutSubviews];
    
    self.moneyLabel.frame = CGRectMake(10, 20, 60, 20);
 
    self.stateLabel.frame = CGRectMake(90, 20, SCREENWIGTH - 60, 20);

    self.timeLabel.frame = CGRectMake(SCREENWIGTH - 180, 20, 160, 20);
    self.timeLabel.font = DEF_FontSize_14;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = getColor(@"666666");
    
}

-(void)setModel:(NSDictionary *)model{
    
    _model = model;
    self.timeLabel.text = [_model objectForKey:@"create_time"];
    self.stateLabel.text = [_model objectForKey:@"desc"];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",[_model objectForKey:@"money"]];
}

@end
