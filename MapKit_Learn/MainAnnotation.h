//
//  MainAnnotation.h
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface MainAnnotation : MyAnnotation<MKAnnotation>
@property (nonatomic, copy, readonly, nullable) NSString *icon;

+ (nullable instancetype)mainAnnotationWithDic:(nullable NSDictionary *)dic;
- (nullable instancetype)initWithDic:(nullable NSDictionary *)dic;

@end
