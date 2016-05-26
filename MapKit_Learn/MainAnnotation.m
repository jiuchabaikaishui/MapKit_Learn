//
//  MainAnnotation.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "MainAnnotation.h"

@implementation MainAnnotation

#pragma mark - 属性方法
- (void)setInfoDic:(NSDictionary *)infoDic
{
    if (infoDic) {
        super.infoDic = infoDic;
        _icon = infoDic[@"icon"];
    }
}

+ (instancetype)mainAnnotationWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super initWithDic:dic]) {
        _icon = dic[@"icon"];
    }
    
    return self;
}

@end
