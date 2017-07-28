//
//  LeftTableViewCell.m
//  全民约步
//
//  Created by 姜祺 on 17/6/5.
//  Copyright © 2017年 chengwo. All rights reserved.
//

#import "LeftTableViewCell.h"

@interface LeftTableViewCell ()
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *label;
@end

@implementation LeftTableViewCell

-(id)initWithCellIdentifier:(NSString *)cellID{

    if (self = [super initWithCellIdentifier:cellID]) {
        if([self respondsToSelector:@selector(setSeparatorInset:)]){
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if([self respondsToSelector:@selector(setLayoutMargins:)]){
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        self.imgView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgView];
        
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:self.label];
    }
    
    return self;
}

-(void)layoutSubviews{

    [super layoutSubviews];
    self.imgView.frame = CGRectMake(30, 15, 30, 30);
//    self.imgView.layer.masksToBounds = YES;
//    self.imgView.layer.cornerRadius = 20;
    
    self.label.frame = CGRectMake(80, 20, 100, 20);
    
}

-(void)setModel:(NSDictionary *)model{
    _model = model;
    self.imgView.image = [UIImage imageNamed:[_model objectForKey:@"img"]];
    self.label.text = [_model objectForKey:@"name"];
}

@end
