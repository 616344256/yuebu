//
//  RedPacketsView.m
//  EveryDay
//
//  Created by 姜祺 on 15/12/8.
//  Copyright © 2015年 江涛. All rights reserved.
//

#import "RedPacketsView.h"
#import "UIImageView+WebCache.h"
#import "Config.h"

@interface RedPacketsView ()
{
    int secondsCountDown; //倒计时总时长
    NSTimer *countDownTimer;
}
@property(nonatomic, strong)UIView *bgView;
@property(nonatomic, strong)UIView *redPacketsView;
@property(nonatomic, strong)UIButton *deleBtn;
@property(nonatomic, strong)UIButton *openBtn;
@property(nonatomic, strong)UIButton *hideBtn;
@property(nonatomic, strong)UIImageView *headerImage;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *textMessageLabel;
@property(nonatomic, strong)UIImageView *bgImage;
@end

@implementation RedPacketsView

-(instancetype)init{
    if (self = [super init]) {
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIGTH, SCREENHEIGHT-64)];
        [self addSubview:_bgView];
        
        _redPacketsView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIGTH / 2, SCREENHEIGHT / 2 - 214, 0, 0)];
        [self addSubview:_redPacketsView];
        
        _bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rpbg"]];
        _bgImage.userInteractionEnabled = YES;
        [_redPacketsView addSubview:_bgImage];
        
        _deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_redPacketsView addSubview:_deleBtn];
        
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgImage addSubview:_openBtn];
        
        _hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_redPacketsView addSubview:_hideBtn];
        
        _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(140/320.0*SCREENWIGTH - 100, 30/320.0*SCREENWIGTH, 200, 110)];
        [_redPacketsView addSubview:_headerImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(140/320.0*SCREENWIGTH - 75, 20/320.0*SCREENWIGTH + 130, 150, 20)];
        [_redPacketsView addSubview:_nameLabel];
        
        _textMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(140/320.0*SCREENWIGTH - 100, 20/320.0*SCREENWIGTH + 140, 200, 50)];
        [_redPacketsView addSubview:_textMessageLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.4;
    
    _bgImage.frame = CGRectMake(0, 0, 280/320.0*SCREENWIGTH, 390/320.0*SCREENWIGTH);
//    _redPacketsView.backgroundColor = getColor(@"d55645");
    _redPacketsView.layer.cornerRadius = 5;
    _redPacketsView.alpha = 1;
    
    _deleBtn.frame = CGRectMake(280/320.0*SCREENWIGTH - 30, 20/320.0*SCREENWIGTH - 10, 20, 20);
    
    [_deleBtn setTitle:@"x" forState:UIControlStateNormal];
    [_deleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_deleBtn addTarget:self action:@selector(deleRedPackets) forControlEvents:UIControlEventTouchUpInside];
    
    _openBtn.frame = CGRectMake(140/320.0*SCREENWIGTH - 45, 220/320.0*SCREENWIGTH, 90, 90);
    [_openBtn setTitle:@"拆红包" forState:UIControlStateNormal];
    [_openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _openBtn.layer.cornerRadius = 45;
    [_openBtn addTarget:self action:@selector(openRedPackets) forControlEvents:UIControlEventTouchUpInside];
    [_openBtn setBackgroundColor:[UIColor grayColor]];
    _hideBtn.frame = CGRectMake(140/320.0*SCREENWIGTH - 75, 330/320.0*SCREENWIGTH , 150, 20);
    [_hideBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _hideBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _hideBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_hideBtn addTarget:self action:@selector(openRedPackets) forControlEvents:UIControlEventTouchUpInside];
    _openBtn.userInteractionEnabled = NO;
    _hideBtn.userInteractionEnabled = NO;
    
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _textMessageLabel.textColor = [UIColor whiteColor];
    _textMessageLabel.textAlignment = NSTextAlignmentCenter;
    _textMessageLabel.numberOfLines = 3;
    _textMessageLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _redPacketsView.frame = CGRectMake(SCREENWIGTH / 2 - 140/320.0*SCREENWIGTH, SCREENHEIGHT / 2 - 195/320.0*SCREENWIGTH , 280/320.0*SCREENWIGTH, 390/320.0*SCREENWIGTH);
    } completion:^(BOOL finished) {
        _redPacketsView.frame = CGRectMake(SCREENWIGTH / 2 - 140/320.0*SCREENWIGTH, SCREENHEIGHT / 2 - 195/320.0*SCREENWIGTH , 280/320.0*SCREENWIGTH, 390/320.0*SCREENWIGTH);
    }];
    
}

-(void)setData:(NSDictionary *)data{
    _data = data;

    [_headerImage sd_setImageWithURL:[data objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"bg"]];
    
    _nameLabel.text = [data objectForKey:@"title"];
    
    //设置倒计时总时长
    secondsCountDown = 5;//60秒倒计时
    //开始倒计时
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    
    //设置倒计时显示的时间
    _textMessageLabel.text=[NSString stringWithFormat:@"%d秒后可以开启",secondsCountDown];
}

-(void)timeFireMethod{
    //倒计时-1
    secondsCountDown--;
    //修改倒计时标签现实内容
    _textMessageLabel.text=[NSString stringWithFormat:@"%d秒后可以开启",secondsCountDown];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        _textMessageLabel.hidden = YES;
        _openBtn.userInteractionEnabled = YES;
        _hideBtn.userInteractionEnabled = YES;
        [_openBtn setBackgroundColor:getColor(@"f7e591")];
    }
}

-(void)deleRedPackets{
    [self removeFromSuperview];
}

-(void)openRedPackets{
        _openBtn.userInteractionEnabled = NO;
        _hideBtn.userInteractionEnabled = NO;
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        theAnimation.duration = 1;
        theAnimation.repeatCount = 2;
        theAnimation.removedOnCompletion = YES;
        theAnimation.fromValue = [NSNumber numberWithFloat:0];
        theAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
        [_openBtn.layer addAnimation:theAnimation forKey:@"animateTransform"];
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.pass([self.data objectForKey:@"hongbao_id"]);
        });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
