//
//  Config.m
//  TianjinBoHai
//
//  Created by 李莹 on 15/1/16.
//  Copyright (c) 2015年 Binky Lee. All rights reserved.
//

#import "Config.h"

/**
 *  文字\按钮  橘色
 */
NSString *orangeColor = @"f2aa43";

/**
 *  文字 黑色
 */
NSString *blackColor = @"555555";

/**
 *  文字 粉红色
 */
NSString *pinkColor = @"f45656";

/**
 *  文字 灰色
 */
NSString *grayColor = @"f6f6f6";

/**
 *  文字 灰色
 */
NSString * lightGrayColor = @"f1f1f1";

@implementation Config
UIColor* getColor(NSString * hexColor)
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

@end
