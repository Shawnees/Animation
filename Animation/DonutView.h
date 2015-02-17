//
//  DonutView.h
//  Animation
//
//  Created by Dylan Oudin on 04/02/2015.
//  Copyright (c) 2015 Dylan Oudin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonutView : UIView

@property (nonatomic, assign)  float borderPercent;
@property (nonatomic, retain)  UIColor* color;

- (void)initLayerWithRect:(CGRect)rect;
@end
