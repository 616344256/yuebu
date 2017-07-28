//
//  GetMoneyRecordTableViewCell.m
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "GetMoneyRecordTableViewCell.h"

@interface GetMoneyRecordTableViewCell ()
@property(strong,nonatomic)UILabel *moneyLabel;
@property(strong,nonatomic)UILabel *stateLabel;
@property(strong,nonatomic)UILabel *timeLabel;
@end

@implementation GetMoneyRecordTableViewCell

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
    
    self.moneyLabel.frame = CGRectMake(10, 20, 80, 20);

    self.stateLabel.frame = CGRectMake(SCREENWIGTH/2 - 40, 20, 80, 20);
    self.stateLabel.text = @"申请中";
    
    self.timeLabel.frame = CGRectMake(SCREENWIGTH - 180, 10, 160, 40);
    
    self.timeLabel.font = DEF_FontSize_14;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    //    self.timeLabel.textColor = getColor(@"f25350");
}

-(void)setModel:(NSDictionary *)model{
    
    _model = model;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",[_model objectForKey:@"money"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[_model objectForKey:@"create_time"]];
    self.stateLabel.text = [NSString stringWithFormat:@"%@",[_model objectForKey:@"type"]];

}

@end
