//
//  DonutView.m
//  Animation
//
//  Created by Dylan Oudin on 04/02/2015.
//  Copyright (c) 2015 Dylan Oudin. All rights reserved.
//

#import "DonutView.h"

@interface DonutView ()

@end

@implementation DonutView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.color = self.backgroundColor;
//        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initLayerWithRect:(CGRect)rect
{
    int radius = rect.size.width;
    float moveTo = rect.size.width * self.borderPercent;
   float radius2 = rect.size.width * (1 - self.borderPercent);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, radius, radius) cornerRadius:radius];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(moveTo / 2, moveTo / 2 , radius2, radius2) cornerRadius:radius2];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = self.color.CGColor;
    [self.layer addSublayer:fillLayer];
  
}

@end
