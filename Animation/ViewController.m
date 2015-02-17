//
//  ViewController.m
//  Animation
//
//  Created by Dylan Oudin on 04/02/2015.
//  Copyright (c) 2015 Dylan Oudin. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedView.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet AnimatedView* contain;
@property (nonatomic, weak) IBOutlet AnimatedView* tap;
@property (nonatomic, weak) IBOutlet AnimatedView* longPress;

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tap.tapGesture = YES;
    self.longPress.longPressGesture = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.contain standby];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeGesture:(id)sender
{
    self.contain.tapGesture = !self.contain.tapGesture;
}

- (IBAction)appear:(id)sender
{
    [self.contain launchAnim];
    [self.tap launchAnim];
    [self.longPress launchAnim];
}

- (IBAction)disappear:(id)sender
{
//    [self.contain disappear];
}

- (IBAction)reset:(id)sender
{
    [self.contain resetAnim];
}

@end
