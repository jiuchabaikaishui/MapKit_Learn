//
//  DescribeView.m
//  MapKit_Learn
//
//  Created by     -MINI on 16/5/6.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "DescribeView.h"

@interface DescribeView ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation DescribeView

#pragma mark - 属性方法
- (void)setAnnotation:(DescribeAnnotation *)annotation
{
    if (annotation) {
        _annotation = annotation;
        self.imageView.image = [UIImage imageNamed:annotation.image];
        self.titleLabel.text = annotation.title;
        self.subTitleLabel.text = annotation.subtitle;
    }
}

+ (instancetype)describeView
{
    DescribeView *view = [[[NSBundle mainBundle] loadNibNamed:@"DescribeView" owner:nil options:nil] firstObject];
    
    return view;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        CGRect rect = self.frame;
        CGFloat W = [UIScreen mainScreen].bounds.size.width/2.5;
        CGFloat WH_scale = 0.5;
        rect.size.width = W;
        rect.size.height = W*WH_scale;
        self.frame = CGRectMake(-W/2, 0, W, W*WH_scale);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 触摸点击手势
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(desctribeViewDelegateAfterClicked:)]) {
        [self.delegate desctribeViewDelegateAfterClicked:self];
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
