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
	 
	 _topControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
	 [_topControl setBackgroundColor:[UIColor redColor]];
	 [self.view addSubview:_topControl];
	 
	 _bottomControl = [[UIView alloc] initWithFrame:CGRectMake(0, 276, 480, 44)];
	 [_bottomControl setBackgroundColor:[UIColor redColor]];
	 [self.view addSubview:_bottomControl];
	 UIButton* stopPlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	 [stopPlay setFrame:CGRectMake(10, 2, 32, 30)];
	 [stopPlay.titleLabel setText:@"Stop"];
	 [stopPlay addTarget:self action:@selector(stopPlay) forControlEvents:UIControlEventTouchUpInside];
	 [_bottomControl addSubview:stopPlay];
	
	self.moviePlayer.controlStyle = MPMovieControlStyleNone;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	UIButton* share = [UIButton buttonWithType:UIButtonTypeCustom];
	[share setFrame:CGRectMake(65, -1, 48, 48)];
	[share setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
 	[share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
	[_topControl addSubview:share];
 
	UIButton* done = [UIButton buttonWithType:UIButtonTypeCustom];
	[done setFrame:CGRectMake(1, 9, 63, 30)];
	[done setImage:[UIImage imageNamed:@"new_done.png"] forState:UIControlStateNormal];
	[done addTarget:self.parentViewController action:@selector(dismissMoviePlayerViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
	[_topControl addSubview:done];
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
	
	if (_topControl.center.y == -50) {
		[UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^(void) {
			_topControl.center = CGPointMake(_topControl.center.x, 22); 
			_bottomControl.center = CGPointMake(_bottomControl.center.x, 298);
		} completion:^(BOOL finished) {}];
	}else{
		
		[UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^(void) {
			_topControl.center = CGPointMake(_topControl.center.x, -50); 
			_bottomControl.center = CGPointMake(_bottomControl.center.x, 370);
		} completion:^(BOOL finished) {}];
	}
}

- (void)share:(id)sender{
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", @"VKontakte", nil];
	[actionSheet showInView:self.view];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet release];
}
- (void)stopPlay{
	(self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) ? [self.moviePlayer pause] : [self.moviePlayer play];
}

@end
