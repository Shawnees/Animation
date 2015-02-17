//
//  AnimatedView.m
//  Animation
//
//  Created by Dylan Oudin on 04/02/2015.
//  Copyright (c) 2015 Dylan Oudin. All rights reserved.
//

#import "AnimatedView.h"
#import "DonutView.h"

static float ANIMATION_DELAY = 1.f;

@interface AnimatedView () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) float animationDelay;
@property (nonatomic, assign) AnimationState animationState;

@property (nonatomic, weak) IBOutlet UIView* containerView;
@property (nonatomic, weak) IBOutlet DonutView* borderView;
@property (nonatomic, weak) IBOutlet UIView* borderOfBorderView;
@property (nonatomic, weak) IBOutlet UIView* insideView;
@property (nonatomic, retain) UIColor* borderColor;
@property (nonatomic, assign) bool isPressing;
@property (nonatomic, assign) bool onStandby;
@property (nonatomic, assign) bool longPressSucceed;
@property (nonatomic, assign) bool onRevert;

@end

@implementation AnimatedView

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.onRevert = NO;
    self.animationDelay = ANIMATION_DELAY;
    self.animationState = AnimationStateLongNone;
    self.isPressing = NO;
    self.longPressSucceed = NO;
    
    self.longPressGesture = YES;
    
    self.borderColor = self.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:Nil];
    
    self.containerView.frame = self.bounds;
    [self addSubview:self.containerView];
    NSArray* hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[child]|"
                                                                    options:0
                                                                    metrics:Nil
                                                                      views:@{@"child" : self.containerView}];
    NSArray* vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[child]|"
                                                                    options:0
                                                                    metrics:Nil
                                                                      views:@{@"child" : self.containerView}];
    
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.alpha = 0;
    [self addConstraints:hConstraints];
    [self addConstraints:vConstraints];
    
    self.borderView.borderPercent = 0.3f;
    self.borderView.color = self.borderColor;
    self.borderView.layer.cornerRadius = self.bounds.size.width / 2;
    [self.borderView initLayerWithRect:self.bounds];
    
    self.borderOfBorderView.layer.borderColor = self.borderColor.CGColor;
    self.borderOfBorderView.layer.borderWidth = self.frame.size.width * 0.15;
    self.borderOfBorderView.layer.cornerRadius = self.bounds.size.width / 2 ;
    
    self.insideView.backgroundColor = self.tintColor;
    self.insideView.layer.cornerRadius = self.bounds.size.width / 2;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ((!self.tapGesture && [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) | (!self.longPressGesture && [gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])) {
        return NO;
    }
    return YES;
}

- (void) resetAnim
{
    self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    self.containerView.alpha = 0;
    self.borderView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, 1.f);
    self.borderOfBorderView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, 1.f);
    self.insideView.alpha = 1;
    self.onRevert = NO;
}

- (void) launchAnim
{
    [self resetAnim];
    if (self.tapGesture) {
        self.animationState = AnimationStateTapStart;
        [self appearLongPress];
    } else {
        self.animationState = AnimationStateLongPressStart;
        [self appearLongPress];
    }
}

- (void) appearLongPress
{
    [UIView animateWithDuration: 0.2f
                          delay: self.animationDelay
                        options: (UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                         self.containerView.alpha = 1.f;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             if (self.animationState == AnimationStateLongPressStart) {
                                 self.animationState = AnimationStateLongPressAppeared;
                                 [self longPressAnim];
                             } else if (self.animationState == AnimationStateTapStart) {
                                 self.animationState = AnimationStateTapAppeared;
                                 [self tapDisapear];
                             }
                         } else if (self.onRevert) {
                             self.animationState = AnimationStateLongPressAppeared;
                             [self revertAppearLongPress];
                         }
                     }];
}

- (void) revertAppearLongPress
{
    [UIView animateWithDuration: 0.1f
                          delay: 0
                        options: (UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001f, 0.001f);
                         self.containerView.alpha = 0.f;
                     }
                     completion:^(BOOL finished) {
                         if (self.animationState == AnimationStateLongPressAppeared && finished) {
                             self.animationState = AnimationStateLongPressStart;
                             [self launchAnim];
                         }
                     }];
}

- (void) longPressAnim
{
    float scale = 0.3f;
    float timer = 0.6f;
    NSDate* timingDate = [NSDate date];
    
    [UIView animateWithDuration: timer
                          delay: 0
                        options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         self.borderOfBorderView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                     }
                     completion:^(BOOL finished) {
                         if (self.animationState == AnimationStateLongPressAppeared && finished) {
                             self.animationState = AnimationStateLongPressDidAnim;
                             [self longPressDisapear];
                         }
                         else if (self.onRevert)
                         {
                             self.animationState = AnimationStateLongPressDidAnim;
                             float percentDone = [self getPercentDone:timingDate forTimer:timer];
                             float scaleDone = scale * percentDone;
                             self.borderOfBorderView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + scaleDone, 1 + scaleDone);
                             [self revertLongPressAnimWithPercentDone:percentDone];
                         }
                     }
     ];
}

- (void) revertLongPressAnimWithPercentDone:(float)percentDone
{
    float timer = 0.3f;
    [UIView animateWithDuration: timer - (timer * percentDone)
                          delay: 0
                        options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{ self.borderOfBorderView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, 1.f);
                     }
                     completion:^(BOOL finished) {
                         if (self.animationState == AnimationStateLongPressDidAnim && finished) {
                             self.animationState = AnimationStateLongPressAppeared;
                             [self revertAppearLongPress];
                         }
                     }
     ];
}

- (void) longPressDisapear
{
    float scale = 0.5;
    float timer = 0.2f;
    if (self.tapGesture) {
        timer += 0.1f;
    }
    NSDate* timingDate = [NSDate date];
    self.insideView.alpha = 0;
    [UIView animateWithDuration: timer
                          delay: 0
                        options: (UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + scale, 1 + scale);
                         self.containerView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (!self.isPressing && finished) {
                             self.animationState = AnimationStateLongPressDisapear;
                             [self launchAnim];
                         }
                         else if (self.onRevert){
                             self.animationState = AnimationStateLongPressDisapear;
                             float percentDone = [self getPercentDone:timingDate forTimer:timer];
                             float scaleDone = scale * percentDone;
                             //                                 float revertPercent = ((1 + scaleDone)/scale)/((1 + scale) / scale); revert percent
                             self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + scaleDone, 1 + scaleDone);
                             self.containerView.alpha = 1.f;
                             [self revertLongPressDisapearWithPercentDone:percentDone];
                         }
                     }
     ];
    
}

- (void) revertLongPressDisapearWithPercentDone:(float)percentDone
{
    float timer = 0.1f;
    [UIView animateWithDuration: timer - (timer * percentDone)
                          delay: 0
                        options: (UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, 1.f);
                         self.containerView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         if (self.animationState == AnimationStateLongPressDisapear && finished) {
                             self.animationState = AnimationStateLongPressDidAnim;
                             self.insideView.alpha = 1;
                             [self revertLongPressAnimWithPercentDone:0];
                         }
                     }
     ];
}

- (void) tapDisapear
{
    float scale = 0.5;
    float timer = 0.3f;
    [UIView animateWithDuration: timer
                          delay: 0
                        options: (UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + scale, 1 + scale);
                         self.containerView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (self.animationState == AnimationStateTapAppeared && finished) {
                             self.animationState = AnimationStateLongPressDisapear;
                             [self launchAnim];
                         }
                     }
     ];
}

- (IBAction)longPress:(id)sender
{
    UILongPressGestureRecognizer* gesture = (UILongPressGestureRecognizer*) sender;
    if (gesture.state == UIGestureRecognizerStateEnded){
        self.longPressSucceed = YES;
        self.onStandby = NO;
        //        [self disappear];
        // set succed longpress
    }
}

- (IBAction)tap:(id)sender
{
    UITapGestureRecognizer* gesture = (UITapGestureRecognizer*) sender;
    if (self.tapGesture) {
        // succeed tap
    }
}

#pragma mark setGesture

- (void) setLongPressGesture:(BOOL)longPressGesture
{
    _longPressGesture = longPressGesture;
    _tapGesture = !longPressGesture;
}

- (void) setTapGesture:(BOOL)tapGesture
{
    _tapGesture = tapGesture;
    _longPressGesture = !tapGesture;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touche began");
    self.layer.speed = 1;
    if (self.longPressGesture) {
        self.animationDelay = 0.f;
        self.isPressing = YES;
        [self removeAllAnim];
        [self launchAnim];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.longPressGesture && !self.longPressSucceed) {
        self.animationDelay = ANIMATION_DELAY;
        self.isPressing = NO;
        self.onRevert = YES;
        NSLog(@"cancel all anim");
        
        [self removeAllAnim];
        //        [self launchLongPress];
    } else {
        // succeed callback
    }
}

- (void) removeAllAnim
{
    [self.layer removeAllAnimations];
    [self.containerView.layer removeAllAnimations];
    [self.borderOfBorderView.layer removeAllAnimations];
}

- (float) getPercentDone:(NSDate*) timingDate forTimer:(float)timer
{
    float timePass = [[NSDate date] timeIntervalSinceDate:timingDate];
    return timePass / timer;
}
@end
