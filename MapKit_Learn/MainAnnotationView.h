//
//  MainAnnotationView.h
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MainAnnotation.h"

@interface MainAnnotationView : MKAnnotationView

+ (instancetype)mainAnnotationViewWithMapView:(MKMapView *)mapView andAnnotation:(MainAnnotation *)annotation;

@end
