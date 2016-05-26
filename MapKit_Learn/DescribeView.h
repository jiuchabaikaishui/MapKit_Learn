//
//  DescribeView.h
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DescribeAnnotation.h"

@class DescribeView;
@protocol DescribeViewDelegate <NSObject>

- (void)desctribeViewDelegateAfterClicked:(DescribeView *)view;

@end

@interface DescribeView : UIView
@property (strong, nonatomic) DescribeAnnotation *annotation;
@property (weak,nonatomic) id<DescribeViewDelegate> delegate;

+ (instancetype)describeView;

@end
