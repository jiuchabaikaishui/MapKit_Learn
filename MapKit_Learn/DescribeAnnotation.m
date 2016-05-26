//
//  DescribeAnnotation.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "DescribeAnnotation.h"

@implementation DescribeAnnotation

#pragma mark - 属性方法
- (void)setInfoDic:(NSDictionary *)infoDic
{
    if (infoDic) {
        [super setInfoDic:infoDic];
        _image = infoDic[@"image"];
    }
}

+ (instancetype)describeAnnotationWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super initWithDic:dic]) {
        _image = dic[@"icon"];
    }
    
    return self;
}

@end
