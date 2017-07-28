//
//  LocationTableViewCell.m
//  HelloCordova
//
//  Created by 姜祺 on 17/2/24.
//
//

#import "LocationTableViewCell.h"
#import <AMapSearchKit/AMapSearchKit.h>
@interface LocationTableViewCell()
@property(nonatomic,strong)UIImageView *hideImageView;
@property(nonatomic,strong)UILabel *locationLabel;
@property(nonatomic,strong)UILabel *cityLabel;
@end

@implementation LocationTableViewCell

-(id)initWithCellIdentifier:(NSString *)cellID{
    if (self = [super initWithCellIdentifier:cellID]) {
        if([self respondsToSelector:@selector(setSeparatorInset:)]){
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if([self respondsToSelector:@selector(setLayoutMargins:)]){
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        self.hideImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.hideImageView];
        self.locationLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.locationLabel];
        self.cityLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.cityLabel];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.hideImageView.frame = CGRectMake(20, 20, 35, 35);
    self.hideImageView.image = [UIImage imageNamed:@"location"];
    self.locationLabel.frame = CGRectMake(60, 20, SCREENWIGTH - 80, 20);
    self.cityLabel.frame = CGRectMake(60, 45, SCREENWIGTH - 80, 20);
}

-(void)setModel:(NSDictionary *)model{

    _model = model;
    AMapPOI *poi = (AMapPOI *)_model;
    self.locationLabel.text = poi.name;
    self.cityLabel.text = [NSString stringWithFormat:@"%@%@%@%@",poi.province,poi.city,poi.district,poi.address];
}

@end
