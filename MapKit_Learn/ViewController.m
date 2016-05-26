//
//  ViewController.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/3.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "AnnotationDics.h"
#import "FixLoction.h"

@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

#pragma mark - 属性方法

#pragma mark - 控制器周期
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUi];
}

#pragma mark - 触摸点击事件
- (IBAction)comeCurrentLoction:(UIButton *)sender {
    //设置地图的中心点
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    //mapView上点击的点
    CGPoint point = [sender locationInView:self.mapView];
    //将点坐标转化为经纬度
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    //创建大头针模型
    MyAnnotation *annotation = [MyAnnotation myAnnotationWithDic:[AnnotationDics shareAnnotationDics].dics[arc4random()%4]];
    annotation.coordinate = coordinate;
    
    //添加大头针
    [self.mapView addAnnotation:annotation];
}
- (void)locationSuccessfulAction:(NSNotification *)sender
{
    CLPlacemark *placemark = sender.userInfo[@"placemark"];
    [self.mapView setCenterCoordinate:placemark.location.coordinate];
}

#pragma mark - 自定义方法
- (void)settingUi
{
    //使用MapKit的时候，需要允许定位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccessfulAction:) name:FixLoctionSuccessful object:nil];
    
    //设置代理
    self.mapView.delegate = self;
    
    //设置用户的跟踪模式-即用户的位置（默认不跟踪）
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    //设置地图的类型
    [self.mapView setMapType:MKMapTypeStandard];
    
    //如果定位成功
    if ([FixLocation shareFixLoction].placemark) {
        //设置地图的中心点
        [self.mapView setCenterCoordinate:[FixLocation shareFixLoction].coordinate];
    }
    
    /**
     *  下面两个方法需要一个位置，可以在定位成功之后再设置
     //设置地图的中心点
     [self.mapView setCenterCoordinate:currentLocation.coordinate animated:YES];
     
     //设置地图的显示范围
     [self.mapView setRegion:MKCoordinateRegionMake(currentLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1)) animated:YES];
     */
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.mapView addGestureRecognizer:tap];
}
- (void)showAlerControllerWithMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - <MKMapViewDelegate>代理方法
/**
 *  用户跟新位置时调用此方法（不断的监控用户的位置）
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //MKUserLocation:表示蓝色的那颗大头针的数据
    userLocation.title = @"北京";
    userLocation.subtitle = @"这里有故宫，天安门！";
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[MyAnnotation class]]) {
        return nil;
    }
    
    static NSString *identifier = @"MKAnnotationViewID";
    // 从缓存池中取出可以循环利用的大头针view
    MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        //能否显示大头针描述
        view.canShowCallout = YES;
        //设置大头针描述的偏移量
        [view setCalloutOffset:CGPointMake(-8, -8)];
        //设置大头针描述的左右控件
        [view setLeftCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
        [view setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeContactAdd]];
        //设置从天而降的动画
        view.animatesDrop = YES;
    }
    
    view.annotation = annotation;
    
    return view;
}

@end
