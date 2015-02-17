//
//  AnimatedView.h
//  Animation
//
//  Created by Dylan Oudin on 04/02/2015.
//  Copyright (c) 2015 Dylan Oudin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AnimationState) {
    AnimationStateLongNone = 0,
    AnimationStateLongPressStart = 1,
    AnimationStateLongPressAppeared = 2,
    AnimationStateLongPressDidAnim = 3,
    AnimationStateLongPressDisapear = 4,
    AnimationStateTapStart = 5,
    AnimationStateTapAppeared = 6,
    AnimationStateTapDisapear = 7
};

@interface AnimatedView : UIView

@property (nonatomic, assign) BOOL longPressGesture;
@property (nonatomic, assign) BOOL tapGesture;

- (void) resetAnim;
- (void) launchAnim;
@end
