//
//  MainAnnotationView.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "MainAnnotationView.h"

@implementation MainAnnotationView

//- (void)setAnnotation:(id<MKAnnotation>)annotation
//{
//    [super setAnnotation:annotation];
//    
//    MainAnnotation *mainAnnotation = annotation;
//    self.image = [UIImage imageNamed:mainAnnotation.icon];
//    NSLog(@"图片名称：%@",mainAnnotation.icon);
//}
+ (instancetype)mainAnnotationViewWithMapView:(MKMapView *)mapView andAnnotation:(MainAnnotation *)annotation
{
    static NSString *identifier = @"MainAnnotationViewID";
    MainAnnotationView *annotationView = (MainAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MainAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//        annotationView.canShowCallout = YES;
    }
    
    annotationView.annotation = annotation;
    annotationView.image = [UIImage imageNamed:annotation.icon];
    
    return annotationView;
}
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        [button addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button];
    }
    
    return self;
}

#pragma mark - 触摸点击手势
- (void)addButtonAction:(UIButton *)sender
{
    NSLog(@"\n----------------------------------------------------------");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
