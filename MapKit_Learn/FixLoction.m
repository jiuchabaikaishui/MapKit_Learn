//
//  FixLoction.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/5.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "FixLoction.h"
#import <UIKit/UIKit.h>

@interface FixLocation ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic, getter=isSuccessfulStop) BOOL successfulStop;

@end

@implementation FixLocation
static FixLocation *shareInstance;

#pragma mark - 属性方法
- (CLLocationManager *)locationManager
{
    //是否允许定位
    /**
     *  [CLLocationManager locationServicesEnabled] 确定用户是否已启用位置服务。
     *  [CLLocationManager authorizationStatus] 返回调用应用程序的当前授权状态。
     kCLAuthorizationStatusDenied:用户已经明确地拒绝了该应用程序的授权，或者
     在设置中禁用位置服务。
     kCLAuthorizationStatusNotDetermined:用户尚未对该应用程序作出选择
     */
    if ((![CLLocationManager locationServicesEnabled]) && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到\"设置—隐私—定位服务\"开启本软件的定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            //设置管理者代理
            _locationManager.delegate = self;
            //desiredAccuracy:所需的位置精度。位置服务将尽力实现
            [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //distanceFilter:指定米的最小更新距离。distanceFilter的值越小，应用程序的耗电量就越大。
            [_locationManager setDistanceFilter:1000.0];
            if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
                //requestAlwaysAuthorization: 总是允许访问地理信息，需要在plist文件中设置NSLocationAlwaysUsageDescription
                //[_locationManager requestAlwaysAuthorization];
                //requestWhenInUseAuthorization: 在使用应用期间允许访问地理信息，需要在plist文件中设置NSLocationWhenInUseUsageDescription
                [_locationManager requestWhenInUseAuthorization];
            }
        }
    }
    
    return _locationManager;
}

#pragma mark - 系统方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [super allocWithZone:zone];
    });
    
    return shareInstance;
}

#pragma mark - 自定义方法
+ (instancetype)shareFixLoction
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

/**
 *  开始定位
 *
 *  @param stop 定位成功后是否停止定位
 */
+ (void)startLocationIsSuccessfulStop:(BOOL)stop
{
    [[self shareFixLoction] startLocationIsSuccessfulStop:stop];
}

/**
 *  开始定位
 *
 *  @param stop 定位成功后是否停止定位
 */
- (void)startLocationIsSuccessfulStop:(BOOL)stop
{
    self.successfulStop = stop;
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - <CLLocationManagerDelegate>代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *location = [locations lastObject];
    _coordinate = location.coordinate;
    
    //逆地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            CLPlacemark *pMark = [placemarks firstObject];
            //NSLog(@"\n详细地址：%@\n城市：%@\n%@",pMark.name,pMark.locality,pMark);
            
            //定位成功发送通知
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [userInfo setObject:pMark forKey:@"placemark"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FixLoctionSuccessful object:nil userInfo:userInfo];
            
            _placemark = pMark;
            _success = YES;
        }
    }];
    
    if (self.isSuccessfulStop) {
        //停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
        [self.locationManager stopUpdatingLocation];
    }
}

@end
