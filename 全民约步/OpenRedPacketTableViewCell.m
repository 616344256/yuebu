//
//  OpenRedPacketTableViewCell.m
//  全民约步
//
//  Created by 姜祺 on 17/6/7.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "OpenRedPacketTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface OpenRedPacketTableViewCell ()
@property(strong,nonatomic)UIImageView *headImgView;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *hideLabel;
@end

@implementation OpenRedPacketTableViewCell

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
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    [super layoutSubviews];
    
    self.headImgView.frame = CGRectMake(10, 10, 40, 40);
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 20;
    
    self.nameLabel.frame = CGRectMake(60, 25, 250, 20);
    
    self.hideLabel.frame = CGRectMake(SCREENWIGTH - 80, 25, 60, 20);
    self.hideLabel.font = DEF_FontSize_14;
    self.hideLabel.textAlignment = NSTextAlignmentLeft;
    self.hideLabel.textColor = getColor(@"f25350");
    
}

-(void)setModel:(NSDictionary *)model{
    
    _model = model;
    
    self.hideLabel.text = [NSString stringWithFormat:@"%@元",[_model objectForKey:@"money"]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[_model objectForKey:@"title"]];
    
    [self.headImgView sd_setImageWithURL:[_model objectForKey:@"headimgurl"] placeholderImage:[UIImage imageNamed:@"head"]];
}

@end
