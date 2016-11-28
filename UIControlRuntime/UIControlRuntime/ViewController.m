//
//  ViewController.m
//  UIControlRuntime
//
//  Created by HYG_IOS on 2016/11/28.
//  Copyright © 2016年 magic. All rights reserved.
//

#import "ViewController.h"
#import "UIControl+ZGExtension.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.button.eventTimeInterval = 1.0f;
}

- (IBAction)buttonClicked:(UIButton *)sender
{
    ZGLog(@"");
}

@end
