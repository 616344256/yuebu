
//
//  ISetUpTableViewCell.m
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "ISetUpTableViewCell.h"

@interface ISetUpTableViewCell()
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *hideLabel;
@property(strong,nonatomic)UILabel *timeLabel;
@end

@implementation ISetUpTableViewCell
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
        
        self.hideLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.hideLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.nameLabel.frame = CGRectMake(10, 35, SCREENWIGTH-30, 20);
    //    self.nameLabel.numberOfLines = 2;
    self.nameLabel.font = DEF_FontSize_14;
    
    self.hideLabel.frame = CGRectMake(10, 5, 250, 20);
    self.hideLabel.textColor = getColor(@"f35451");
    //    self.hideLabel.font = DEF_FontSize_14;
    //    self.hideLabel.textAlignment = NSTextAlignmentCenter;
    //    self.hideLabel.textColor = getColor(@"44464e");
    //    self.hideLabel.layer.masksToBounds = YES;
    //    self.hideLabel.layer.cornerRadius = 10;
    //    self.hideLabel.layer.borderWidth = 1;
    //    self.hideLabel.layer.borderColor = getColor(@"44464e").CGColor;
    self.timeLabel.frame = CGRectMake(SCREENWIGTH - 270, 5, 250, 20);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = getColor(@"44464e");
    self.timeLabel.font = DEF_FontSize_14;
}

-(void)setModel:(NSDictionary *)model{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@-%@",[_model objectForKey:@"start_address"],[_model objectForKey:@"end_address"]];
    self.hideLabel.text = [NSString stringWithFormat:@"%@",[_model objectForKey:@"title"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[_model objectForKey:@"time"]];
}

@end
