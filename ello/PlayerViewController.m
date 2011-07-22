//
//  PlayerViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayerViewController.h"


@implementation PlayerViewController
  

#pragma mark - View lifecycle
 
 - (void)viewDidLoad{
    [super viewDidLoad];
	
	self.moviePlayer.controlStyle = MPMovieControlStyleNone;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	UIButton* share = [UIButton buttonWithType:UIButtonTypeCustom];
	[share setFrame:CGRectMake(65, 0, 48, 48)];
	[share setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
 	[share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:share];
 
	UIButton* done = [UIButton buttonWithType:UIButtonTypeCustom];
	[done setFrame:CGRectMake(1, 9, 63, 30)];
	[done setImage:[UIImage imageNamed:@"new_done.png"] forState:UIControlStateNormal];
	[done addTarget:self.parentViewController action:@selector(dismissMoviePlayerViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:done];
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
	[self.navigationController setNavigationBarHidden:NO animated:YES]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{ 
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"touch");
}

- (void)share:(id)sender{
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", @"VKontakte", nil];
	[actionSheet showInView:self.view];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet release];
}

@end
