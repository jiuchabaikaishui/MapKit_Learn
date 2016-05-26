//
//  DescribeAnnotationView.h
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "DescribeAnnotation.h"

@class DescribeAnnotationView;
@protocol DescribeAnnotationViewDelegate <NSObject>

@optional
- (void)describeAnnotationViewDelegateAfterSelected:(DescribeAnnotationView *)view;

@end

@interface DescribeAnnotationView : MKAnnotationView
@property (weak,nonatomic) id<DescribeAnnotationViewDelegate> delegate;

+ (instancetype)describeAnnotationViewWithMapView:(MKMapView *)mapView andAnnotation:(DescribeAnnotation *)annotation;

@end
