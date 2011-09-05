//
//  ClipInfoViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 13/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ClipInfoViewController.h"

@implementation ClipInfoViewController
 
#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	[[self view] setBounds:CGRectMake(0, 0, 480, 320)];
	[[self view] setCenter:CGPointMake(160, 240)];
	[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)];  
}
  

@end
