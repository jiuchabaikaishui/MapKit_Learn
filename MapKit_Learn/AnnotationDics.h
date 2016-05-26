//
//  AnnotationDics.h
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/5.
//  Copyright © 2016年 QSP. All rights reserved.
//  数据源工具类

#import <Foundation/Foundation.h>

@interface AnnotationDics : NSObject;
@property (strong, nonatomic) NSMutableArray *dics;

+ (instancetype)shareAnnotationDics;

@end
