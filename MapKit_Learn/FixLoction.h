//
//  FixLoction.h
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/5.
//  Copyright © 2016年 QSP. All rights reserved.
//  定位工具类

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define FixLoctionSuccessful    @"FixLoctionSuccessful"

@interface FixLocation : NSObject

/**
 *  当前地理坐标
 */
@property (assign, nonatomic, readonly) CLLocationCoordinate2D coordinate;
/**
 *  当前地理位置的地标数据。
 */
@property (strong, nonatomic, readonly) CLPlacemark *placemark;
/**
 *  是否定位成功
 */
@property (assign, nonatomic, readonly, getter = isSuccess) BOOL success;

+ (instancetype)shareFixLoction;

/**
 *  开始定位
 *
 *  @param stop 定位成功后是否停止定位
 */
+ (void)startLocationIsSuccessfulStop:(BOOL)stop;

/**
 *  开始定位
 *
 *  @param stop 定位成功后是否停止定位
 */
- (void)startLocationIsSuccessfulStop:(BOOL)stop;

@end
