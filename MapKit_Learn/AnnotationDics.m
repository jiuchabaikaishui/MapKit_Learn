//
//  AnnotationDics.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/5.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "AnnotationDics.h"

@interface AnnotationDics ()

@end

@implementation AnnotationDics
static AnnotationDics *shareInstance;

- (NSMutableArray *)dics
{
    if (!_dics) {
        _dics = [NSMutableArray arrayWithArray:@[@{@"title":@"餐厅",@"subtitle":@"吃饭的地方",@"icon":@"category_1"},
                                                 @{@"title":@"KTV",@"subtitle":@"唱歌的地方",@"icon":@"category_2"},
                                                 @{@"title":@"宾馆",@"subtitle":@"住宿的地方",@"icon":@"category_3"},
                                                 @{@"title":@"机场",@"subtitle":@"旅行的地方",@"icon":@"category_4"},
                                                 @{@"title":@"影院",@"subtitle":@"看电影的地方",@"icon":@"category_5"}]];
    }
    
    return _dics;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [super allocWithZone:zone];
    });
    
    return shareInstance;
}

+ (instancetype)shareAnnotationDics
{
   static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

@end
