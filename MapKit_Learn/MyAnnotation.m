//
//  MyAnnotation.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/3.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

#pragma mark - 属性方法
- (void)setInfoDic:(NSDictionary *)infoDic
{
    if (infoDic) {
        _infoDic = infoDic;
        _title = infoDic[@"title"];
        _subtitle = infoDic[@"subtitle"];
    }
}

+ (instancetype)myAnnotationWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        if (dic) {
            self.infoDic = dic;
            _title = dic[@"title"];
            _subtitle = dic[@"subtitle"];
        }
    }
    
    return self;
}

@end
