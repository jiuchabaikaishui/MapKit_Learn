//
//  MyAnnotation.h
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/3.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation>
@property (strong, nonatomic, nullable) NSDictionary *infoDic;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly, nullable) NSString *title;
@property (nonatomic, copy, readonly, nullable) NSString *subtitle;

+ (nullable instancetype)myAnnotationWithDic:(nullable NSDictionary *)dic;
- (nullable instancetype)initWithDic:(nullable NSDictionary *)dic;

@end
