//
//  PlayerViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayerViewController.h"

#import "PlayLists.h"
#import "MKEntryPanel.h"
#import "PlayList.h"
#import "PreviewViewController.h"
#import "Clip.h"


@implementation PlayerViewController

@synthesize currentClip = _currentClip;
@synthesize delegate = _delegate;
@synthesize playlist;

#pragma mark - View lifecycle
 
- (void)dealloc {
    
	[_currentClip release];
	[_topControl release];
	[_bottomControl release];
	
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	 
	 _topControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
	 [_topControl setBackgroundColor:[UIColor redColor]];
	 [self.view addSubview:_topControl];
	 
	 _bottomControl = [[UIView alloc] initWithFrame:CGRectMake(0, 276, 480, 44)];
	 [_bottomControl setBackgroundColor:[UIColor redColor]];
	 [self.view addSubview:_bottomControl];
	
	 UIButton* stopPlay = [UIButton buttonWithType:UIButtonTypeCustom];
	 [stopPlay setFrame:CGRectMake(10, 2, 32, 30)];
	 [stopPlay setImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
	 [stopPlay setImage:[UIImage imageNamed:@"player_play.png"] forState:UIControlStateSelected];
	[stopPlay addTarget:self action:@selector(stopPlay:) forControlEvents:UIControlEventTouchUpInside];
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
	[done addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
	[_topControl addSubview:done];
	
	UIButton* addToPlaylistButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[addToPlaylistButton setFrame:CGRectMake(270, 9, 32, 32)];
	[addToPlaylistButton setImage:[UIImage imageNamed:@"addToPl.png"] forState:UIControlStateNormal];
	[addToPlaylistButton addTarget:self action:@selector(addToPlaylist:) forControlEvents:UIControlEventTouchUpInside];
	[_topControl addSubview:addToPlaylistButton];
	
	UIButton* info = [UIButton buttonWithType:UIButtonTypeCustom];
	[info setFrame:CGRectMake(210, 9, 32, 32)];
	[info setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
	[info addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
	[_topControl addSubview:info];
	
	UIButton* prev = [UIButton buttonWithType:UIButtonTypeCustom];
	[prev setFrame:CGRectMake(50, 9, 63, 30)];
	[prev setImage:[UIImage imageNamed:@"prev.png"] forState:UIControlStateNormal];
	[prev addTarget:self action:@selector(prev:) forControlEvents:UIControlEventTouchUpInside];
	[_bottomControl addSubview:prev];
	
	UIButton* next = [UIButton buttonWithType:UIButtonTypeCustom];
	[next setFrame:CGRectMake(100, 9, 63, 30)];
	[next setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
	[next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
	[_bottomControl addSubview:next];
	
	_topControl.center = CGPointMake(_topControl.center.x, -50); 
	_bottomControl.center = CGPointMake(_bottomControl.center.x, 370); 
	
 
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
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
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", @"VKontakte", nil];
	[actionSheet showInView:self.view];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet release];
}
- (void)stopPlay:(UIButton*)sender{
	sender.selected = !sender.selected;
	(self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) ? [self.moviePlayer pause] : [self.moviePlayer play];
}
- (void)loadStateDidChange:(NSNotification*)notification{
	switch (self.moviePlayer.loadState) {
		case MPMovieLoadStatePlayable:			
		case MPMovieLoadStatePlaythroughOK:
			
			break;
//			case mpmovielo:
			case MPMovieLoadStateStalled:
			
			break;
	}
	NSLog(@"loadState is %d", self.moviePlayer.loadState);
}
- (void)done{
 	[self.moviePlayer stop];
	[_delegate done];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}
- (void)next:(UIButton*)sender{
	self.view.frame = CGRectMake(0, 0, 236, 236);
	[self.moviePlayer stop]; 
	[_delegate next:sender];
}
- (void)prev:(UIButton*)sender{
	self.view.frame = CGRectMake(0, 0, 236, 367);
	[self.moviePlayer stop];
	[_delegate prev:sender];
}

- (void)addToPlaylist:(Clip*)clip{

	[self.moviePlayer pause];
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Добавить это видео в..." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Новый плейлист", nil];
	[actionSheet setTag:777];
	for (PlayList* pl in [[__delegate playlists] playlists]) {
		[actionSheet addButtonWithTitle:pl.name];
	}
	[actionSheet addButtonWithTitle:@"Отмена"];
	
	[actionSheet showInView:self.view];
	[actionSheet release];
	
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	[self.moviePlayer play];
	if (actionSheet.tag == 777) {
		if (buttonIndex == [actionSheet numberOfButtons] - 1) return;
		if (buttonIndex == 0) {
			
			PlayList* playList = [PlayList new];
			[MKEntryPanel showPanelWithTitle:NSLocalizedString(@"Название листа", @"") 
									  inView:self.view 
							   onTextEntered:^(NSString* enteredString)
			 {
			 
			 playList.name = enteredString;
			 [[__delegate playlists] addPlaylist:playList];
			 
			 }];
			[[playList clips] addObject:_currentClip];
			[playList release]; 
		}else{
			PlayList* myPlaylist = [[[__delegate playlists] playlists] objectAtIndex:buttonIndex - 1];
			[[myPlaylist clips] addObject:_currentClip]; 
		}
		return;
	}
	if (buttonIndex != actionSheet.cancelButtonIndex)
		{
 
		}	
}

@end
