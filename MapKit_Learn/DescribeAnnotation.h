//
//  DescribeAnnotation.h
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "MyAnnotation.h"

@interface DescribeAnnotation : MyAnnotation
@property (copy, nonatomic, readonly, nullable) NSString *image;

+ (nullable instancetype)describeAnnotationWithDic:(nullable NSDictionary *)dic;
- (nullable instancetype)initWithDic:(nullable NSDictionary *)dic;

@end
