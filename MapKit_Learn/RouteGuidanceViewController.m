//
//  RouteGuidanceViewController.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/10.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "RouteGuidanceViewController.h"
#import <MapKit/MapKit.h>
#import "FixLoction.h"
#import "MyAnnotation.h"
#import "AnnotationDics.h"

#define Screen_Height          [UIScreen mainScreen].bounds.size.height

@interface RouteGuidanceViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLPlacemark *startPlaceMark;
@property (strong, nonatomic) CLPlacemark *endPlaceMark;
@property (strong, nonatomic) CLLocation *currentLocation;
/**
 *  是否定位
 */
@property (assign, nonatomic, getter=isLocation) BOOL location;

@end

@implementation RouteGuidanceViewController

#pragma mark - 属性方法

#pragma mark - 控制器周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUi];
}

#pragma mark - 触摸点击事件
- (IBAction)settingFromPlaceAction:(UIButton *)sender {
    [self settingPlacemarkIsStart:YES];
}
- (IBAction)settingToPlaceAction:(UIButton *)sender {
    [self settingPlacemarkIsStart:NO];
}
- (IBAction)startNavigationAction:(UIButton *)sender {
    if (self.startPlaceMark) {
        self.location = NO;
        [self routeGuidanceWithStarPlacemark:self.startPlaceMark andChangeRegion:YES];
    }
    else
    {
        if (self.currentLocation) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (error) {
                    [self showAlertControllerTitle:nil withMessge:@"未能识别您的当前位置！" andCancelTitle:nil];
                }
                else
                {
                    self.location = YES;
                    self.startPlaceMark = nil;
                    
                    CLPlacemark *placemark = [placemarks firstObject];
                    [self routeGuidanceWithStarPlacemark:placemark andChangeRegion:YES];
                }
            }];
        }
        else
        {
            [self showAlertControllerTitle:nil withMessge:@"定位不成功" andCancelTitle:nil];
        }
    }
}
- (void)locationSuccessfulAction:(NSNotification *)sender
{
    NSDictionary *useDic = sender.userInfo;
    MKPlacemark *placeMark = useDic[@"placemark"];
    //设置地图的中心点
    [self.mapView setCenterCoordinate:placeMark.location.coordinate animated:YES];
}
- (void)textFieldTextDidChangeAction:(NSNotification *)sender
{
    UITextField *textField = (UITextField *)sender.object;
    UIAlertController *alertCtr = (UIAlertController *)self.presentedViewController;
    UIAlertAction *okAction = [alertCtr.actions lastObject];
    if ([self isBlinkStr:textField.text]) {
        okAction.enabled = NO;
    }
    else
    {
        okAction.enabled = YES;
    }
}

#pragma mark - 自定义方法
/**
 *  设置界面
 */
- (void)settingUi
{
    //地图的使用需要允许定位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccessfulAction:) name:FixLoctionSuccessful object:nil];
    
    //设置地图的代理
    self.mapView.delegate = self;
    //设置地图的类型
    [self.mapView setMapType:MKMapTypeStandard];
    //设置用户的跟踪模式
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    //如果定位成功设置中心点
    if ([FixLocation shareFixLoction].placemark) {
        [self.mapView setCenterCoordinate:[FixLocation shareFixLoction].coordinate animated:YES];
    }
}
/**
 *  执行导航任务
 *
 *  @param sourcePlacemark 地标数据
 *  @param isChange        是否改变地图的区域
 */
- (void)routeGuidanceWithStarPlacemark:(CLPlacemark *)sourcePlacemark andChangeRegion:(BOOL)isChange
{
    if (!self.endPlaceMark) {
        [self showAlertControllerTitle:nil withMessge:@"请输入终点地址！" andCancelTitle:nil];
        return;
    }
    
    //创建请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    //设置起点和终点
    [request setSource:[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:sourcePlacemark]]];
    [request setDestination:[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:self.endPlaceMark]]];
    
    //创建方向对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    //计算路线
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self showAlertControllerTitle:nil withMessge:@"对不起，没有为您找到合适的路线！" andCancelTitle:nil];
        }
        else
        {
            //添加两颗大头针
            [self addAnnotation:sourcePlacemark.location.coordinate withTitle:@"出发地" andSubTitle:sourcePlacemark.name];
            [self addAnnotation:self.endPlaceMark.location.coordinate withTitle:@"目的地" andSubTitle:self.endPlaceMark.name];
            
            //先遍历所有的路线移除
            for (id<MKOverlay> overlay in self.mapView.overlays) {
                [self.mapView removeOverlay:overlay];
            }
            
            //遍历所有路线
            for (MKRoute *route in response.routes) {
                //添加遮罩
                [self.mapView addOverlay:route.polyline];
            }
            
            //设置地图的显示范围
            if (isChange) {
                CLLocationCoordinate2D startCoordinate = sourcePlacemark.location.coordinate;
                CLLocationCoordinate2D endCoordinate = self.endPlaceMark.location.coordinate;
                CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((startCoordinate.latitude + endCoordinate.latitude)/2, (startCoordinate.longitude + endCoordinate.longitude)/2);
                
                CGFloat proportion = (Screen_Height - 64 - 49 - 44)/Screen_Height;
                CLLocationDegrees latitudeDelta = fabs(startCoordinate.latitude - endCoordinate.latitude)/proportion;
                CLLocationDegrees longitudeDelta = fabs(startCoordinate.longitude - endCoordinate.longitude)/proportion;
                MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
                [self.mapView setRegion:MKCoordinateRegionMake(centerCoordinate, coordinateSpan) animated:YES];
            }
        }
    }];
}
/**
 *  添加大头针
 *
 *  @param coordinate 大头针的经纬坐标
 *  @param title      大头针的标题
 *  @param subTitle   大头针的子标题
 */
- (void)addAnnotation:(CLLocationCoordinate2D)coordinate withTitle:(NSString *)title andSubTitle:(NSString *)subTitle
{
    NSDictionary *dic = @{@"title":title,@"subtitle":subTitle};
    MyAnnotation *startAnnotation = [MyAnnotation myAnnotationWithDic:dic];
    startAnnotation.coordinate = coordinate;
    [self.mapView addAnnotation:startAnnotation];
}
/**
 *  字符串判空
 */
- (BOOL)isBlinkStr:(NSString *)str
{
    /**
     *  stringByTrimmingCharactersInSet函数过滤字符串中的特殊符号
     */
    if (str == nil || str == NULL) {
        return YES;
    }
    else if ([str isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)//去掉两端的空白字符
    {
        return YES;
    }
    
    return NO;
}
/**
 *  设置起点或终点
 *
 *  @param isStart 是否为起点
 */
- (void)settingPlacemarkIsStart:(BOOL)isStart
{
    NSString *title = @"请设置终点";
    if (isStart) {
        title = @"请设置起点";
    }
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCtr addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = isStart ? @"请输入起点！" : @"请输入终点";
        textField.returnKeyType = UIReturnKeyDone;
        textField.enablesReturnKeyAutomatically = YES;
        if (isStart && [FixLocation shareFixLoction].placemark) {
            textField.text = [FixLocation shareFixLoction].placemark.locality;
        }
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeAction:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    NSString *cancelTitle = @"取消";
    if (isStart) {
        cancelTitle = @"定位起点";
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (isStart) {
            self.startPlaceMark = nil;
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    [alertCtr addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        UITextField *textField = [alertCtr.textFields lastObject];
        [geocoder geocodeAddressString:textField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error) {
                [self showAlertControllerTitle:@"提示" withMessge:@"您输入的地址不存在！" andCancelTitle:@"确定"];
            }
            else
            {
                if (isStart) {
                    self.startPlaceMark = [placemarks firstObject];
                }
                else
                {
                    self.endPlaceMark = [placemarks firstObject];
                }
            }
        }];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    [alertCtr addAction:okAction];
    UITextField *textField = [alertCtr.textFields lastObject];
    if ([self isBlinkStr:textField.text]) {
        okAction.enabled = NO;
    }
    [self presentViewController:alertCtr animated:YES completion:nil];
}
/**
 *  显示UIAlertController
 *
 *  @param title       标题
 *  @param message     描述信息
 *  @param cancleTitle 取消按钮标题
 */
- (void)showAlertControllerTitle:(NSString *)title withMessge:(NSString *)message  andCancelTitle:(NSString *)cancleTitle
{
    title = [self isBlinkStr:title] ? @"提示" : title;
    cancleTitle = [self isBlinkStr:cancleTitle] ? @"取消" : cancleTitle;
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:nil];
    [alertCtr addAction:action];
    [self presentViewController:alertCtr animated:YES completion:nil];
}

#pragma mark - <MKMapViewDelegate>代理方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //保存当前位置
    self.currentLocation = userLocation.location;
    
    if ((!self.startPlaceMark) && self.isLocation) {
        //你地理编码
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error) {
                [self showAlertControllerTitle:nil withMessge:@"定位不成功" andCancelTitle:nil];
            }
            else
            {
                CLPlacemark *placemark = [placemarks firstObject];
                
                //从新导航
                [self routeGuidanceWithStarPlacemark:placemark andChangeRegion:NO];
            }
        }];
    }
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor greenColor];
    
    return renderer;
}

@end
