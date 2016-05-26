//
//  CustomPinViewController.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "CustomPinViewController.h"
#import "FixLoction.h"
#import <MapKit/MapKit.h>
#import "AnnotationDics.h"
#import "MainAnnotation.h"
#import "MainAnnotationView.h"
#import "DescribeAnnotation.h"
#import "DescribeAnnotationView.h"
#import "DescribeView.h"

@interface CustomPinViewController ()<MKMapViewDelegate, DescribeAnnotationViewDelegate, DescribeViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation CustomPinViewController

#pragma mark - 控制器周期
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUi];
}

#pragma mark - 触摸点击手势
- (void)locationSuccessfulAction:(NSNotification *)sender
{
    //设置地图的中心点
    CLPlacemark *placemark = sender.userInfo[@"placemark"];
    [self.mapView setCenterCoordinate:placemark.location.coordinate];
}
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    MainAnnotation *annotation = [MainAnnotation mainAnnotationWithDic:[AnnotationDics shareAnnotationDics].dics[arc4random()%[AnnotationDics shareAnnotationDics].dics.count]];
    annotation.coordinate = [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
    [self.mapView addAnnotation:annotation];
    
    [self addDescribeAnnotation:annotation];
}

#pragma mark - 自定义方法
- (void)settingUi
{
    //监听定位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccessfulAction:) name:FixLoctionSuccessful object:nil];
    
    //设置代理
    self.mapView.delegate = self;
    //设置地图的类型
    [self.mapView setMapType:MKMapTypeStandard];
    //设置用户的跟踪模式-即用户的位置（默认不跟踪）
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    //设置地图的中心点
    if ([FixLocation shareFixLoction].placemark) {
        [self.mapView setCenterCoordinate:[FixLocation shareFixLoction].coordinate];
    }
    
    //为地图添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.mapView addGestureRecognizer:tap];
}
/**
 *  添加一个描述类型的大头针
 *
 *  @param annotation MainAnnotation类型的大头针模型
 */
- (void)addDescribeAnnotation:(MainAnnotation *)annotation
{
    //先移除所有的DescribeAnnotationView
    [self removeAllDescribeAnnotationView];
    
    DescribeAnnotation *describeAnnotation = [DescribeAnnotation describeAnnotationWithDic:annotation.infoDic];
    describeAnnotation.coordinate = annotation.coordinate;
    [self.mapView addAnnotation:describeAnnotation];
}
/**
 *  移除所有DescribeAnnotationView
 */
- (void)removeAllDescribeAnnotationView
{
    for (id annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[DescribeAnnotation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
}
/**
 *  执行核心动画
 *
 *  @param layer      所需动画的CALayer
 *  @param annotation 为了确定动画位置所需的MKAnnotation对象
 */
- (void)implementCoreAnnimationWithView:(CALayer *)layer andAnnotation:(id<MKAnnotation>)annotation
{
    //创建动画对象
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    //设置动画属性
    //        animation.keyPath = @"transform.scale";
    //        animation.values = @[@(1),@(1.5),@(0.5),@(1.3),@(0.7),@(1.1),@(0.9),@(1)];
    
    animation.keyPath = @"position.y";
    CGFloat beginValue = [self.mapView convertCoordinate:annotation.coordinate toPointToView:self.mapView].y;
    animation.values = @[@(beginValue),@(beginValue - 30),@(beginValue + 30),@(beginValue + 20),@(beginValue - 20),@(beginValue + 10),@(beginValue - 10),@(beginValue)];
    
    animation.duration = 0.5;
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //为CALayer添加动画
    [layer addAnimation:animation forKey:nil];
}

#pragma mark - <MKMapViewDelegate>代理方法
/**
 *  用户跟新位置时调用此方法（不断的监控用户的位置）
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //MKUserLocation:表示蓝色的那颗大头针的数据，在此设置数据
    [userLocation setTitle:@"北京"];
    [userLocation setSubtitle:@"北京欢迎您！"];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MainAnnotation class]])
    {
        MainAnnotationView *mainAnnotationView = [MainAnnotationView mainAnnotationViewWithMapView:mapView andAnnotation:annotation];
        
        return mainAnnotationView;
    }
    else if ([annotation isKindOfClass:[DescribeAnnotation class]])
    {
        DescribeAnnotationView *describeAnnotationView = [DescribeAnnotationView describeAnnotationViewWithMapView:mapView andAnnotation:annotation];
        describeAnnotationView.delegate = self;
        
        [self implementCoreAnnimationWithView:describeAnnotationView.layer andAnnotation:annotation];
        
        return describeAnnotationView;
    }
    else
    {
        return nil;
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[MainAnnotationView class]]) {
        MainAnnotation *mainAnnotation = (MainAnnotation *)view.annotation;
        [self addDescribeAnnotation:mainAnnotation];
    }
    else if ([view isKindOfClass:[DescribeAnnotationView class]])
    {
        return;
    }
    else
    {
        [self removeAllDescribeAnnotationView];
        return;
    }
}

#pragma mark - <DescribeAnnotationViewDelegate>代理方法
- (void)describeAnnotationViewDelegateAfterSelected:(DescribeAnnotationView *)view
{
    NSLog(@"\n%s",__FUNCTION__);
}

#pragma mark - <DescribeViewDelegate>代理方法
- (void)desctribeViewDelegateAfterClicked:(DescribeView *)view
{
    NSLog(@"\n%s",__FUNCTION__);
}

@end
