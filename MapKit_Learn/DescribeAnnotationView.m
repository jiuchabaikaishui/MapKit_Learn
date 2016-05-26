//
//  DescribeAnnotationView.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "DescribeAnnotationView.h"
#import "DescribeView.h"

@interface DescribeAnnotationView ()<DescribeViewDelegate>

@property (weak, nonatomic) DescribeView *describeView;

@end

@implementation DescribeAnnotationView

#pragma mark - 属性方法
- (void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    DescribeAnnotation *describeAnnotation = (DescribeAnnotation *)annotation;
    self.describeView.annotation = describeAnnotation;
}
+ (instancetype)describeAnnotationViewWithMapView:(MKMapView *)mapView andAnnotation:(DescribeAnnotation *)annotation
{
    static NSString *identifier = @"DescribeAnnotationViewID";
    DescribeAnnotationView *annotationView = (DescribeAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[DescribeAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    annotationView.annotation = annotation;
//    annotationView.image = [UIImage imageNamed:annotation.image];
//    annotationView.image = [self receivedImageWithColor:[UIColor blackColor] andSize:CGSizeMake(10, 10)];
    
    return annotationView;
}
+ (UIImage *)receivedImageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, (CGRect){{0,0},size});
    CGContextSetFillColorWithColor(context, color.CGColor);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        DescribeView *view = [DescribeView describeView];
        view.delegate = self;
        [self addSubview:view];
        self.describeView = view;
        
        CGRect rect = self.frame;
        rect.size.height = 2*view.frame.size.height + 40;
        self.frame = rect;
    }
    
    return self;
}

#pragma mark - 触摸点击手势

#pragma mark - <DescribeViewDelegate>代理方法
- (void)desctribeViewDelegateAfterClicked:(DescribeView *)view
{
    if ([self.delegate respondsToSelector:@selector(desctribeViewDelegateAfterClicked:)]) {
        [self.delegate describeAnnotationViewDelegateAfterSelected:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
