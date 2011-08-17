//
//  PlayerViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayerViewController.h"

#import "ArtistInfoView.h"
#import "ClipInfoViewController.h"
#import "SHKActionSheet.h"
#import "SHK.h"
#import "MKEntryPanel.h"
#import "PlayList.h"
#import "PreviewViewController.h"
#import "Clip.h"


@implementation PlayerViewController

@synthesize currentClip = _currentClip;
@synthesize delegate = _delegate;
@synthesize playlist;

#pragma mark - View lifecycle

- (id)initWithContentURL:(NSURL*)url {
    self = [super initWithContentURL:url];
    if (self) {
        NSLog(@"%s:%d", __func__, self);
    }
    return self;
}
- (void)dealloc {NSLog(@"%s:%d", __func__, self);
    
	[_currentClip release];
	[_topControl release];
	[_bottomControl release];
	
    [super dealloc];
}

- (void)viewDidLoad{NSLog(@"%s", __func__);
    [super viewDidLoad];
	 
	 _topControl = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
	[_topControl setImage:[UIImage imageNamed:@"playerBand.png"]];
	[_topControl setAlpha:.8];
	[_topControl setUserInteractionEnabled:YES];
	 [self.view addSubview:_topControl];
	 
	 _bottomControl = [[UIImageView alloc] initWithFrame:CGRectMake(0, 280, 480, 40)];
	 [_bottomControl  setImage:[UIImage imageNamed:@"playerBand.png"]];
	[_bottomControl setUserInteractionEnabled:YES];
	 [self.view addSubview:_bottomControl];
	
	if (playlist) {
		_clipsBund = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 165, 480, 115)];
		[_clipsBund setBackgroundColor:[UIColor lightGrayColor]];
		[_clipsBund setContentSize:CGSizeMake(playlist.clips.count * 140 + 17, _clipsBund.frame.size.height)];
		[_clipsBund setBackgroundColor:[UIColor blackColor]];
		[_clipsBund setAlpha:.6];
		[self.view addSubview:_clipsBund];
		
		int ind = 0;
		for (Clip* clip in playlist.clips) 
			{
			ClipThumb* th = [[ClipThumb alloc] initWithFrame:CGRectMake(ind++ * 140, 0, 140, 140) clip:clip];
			[_clipsBund addSubview:th];
			[th setDelegate:_delegate];
			[th release];
			}
		
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
	}	
	
	 _stopPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
	 [_stopPlayButton setFrame:CGRectMake(10, 2, 36, 36)];
	 [_stopPlayButton setImage:[UIImage imageNamed:@"playerBtnPlay.png"]		forState:UIControlStateSelected];
	 [_stopPlayButton setImage:[UIImage imageNamed:@"playerBtnStop.png"]		forState:UIControlStateNormal];
	[_stopPlayButton addTarget:self action:@selector(stopPlay:) forControlEvents:UIControlEventTouchUpInside];
	 [_bottomControl addSubview:_stopPlayButton];
	
	self.moviePlayer.controlStyle = MPMovieControlStyleNone;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	UIButton* share = [UIButton buttonWithType:UIButtonTypeCustom];
	[share setFrame:CGRectMake(75, 4, 33, 37)];
	[share setImage:[UIImage imageNamed:@"btnShare.png"] forState:UIControlStateNormal];
 	[share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
	[_topControl addSubview:share];
 
	UIButton* done = [UIButton buttonWithType:UIButtonTypeCustom];
	[done setFrame:CGRectMake(1, 7, 70, 31)];
	[done setTitle:@"Готово" forState:UIControlStateNormal];
	[done setBackgroundImage:[UIImage imageNamed:@"btnBack.png"] forState:UIControlStateNormal];
	[done addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
	[_topControl addSubview:done];
	
	UIButton* addToPlaylistButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[addToPlaylistButton setFrame:CGRectMake(270, 7, 27, 32)];
	[addToPlaylistButton setImage:[UIImage imageNamed:@"cellBtnAdd.png"] forState:UIControlStateNormal];
	[addToPlaylistButton addTarget:self action:@selector(addToPlaylist:) forControlEvents:UIControlEventTouchUpInside];
	[_topControl addSubview:addToPlaylistButton];
	
	UIButton* info = [UIButton buttonWithType:UIButtonTypeCustom];
	[info setFrame:CGRectMake(210, 6, 32, 32)];
	[info setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
	[info addTarget:self action:@selector(info) forControlEvents:UIControlEventTouchUpInside];
	[_topControl addSubview:info];
	 
	_topControl.center = CGPointMake(_topControl.center.x, -50); 
	_bottomControl.center = CGPointMake(_bottomControl.center.x, 370); 
	_clipsBund.frame = CGRectOffset(_clipsBund.frame, 0, _clipsBund.frame.size.height + _bottomControl.frame.size.height);
	 
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil]; 
	
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
 
	[[NSNotificationCenter defaultCenter] removeObserver:self]; 
} 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{ 
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
 	
	if (_topControl.center.y == -50) {
		[UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^(void) {
			_topControl.center = CGPointMake(_topControl.center.x, 22); 
			_bottomControl.center = CGPointMake(_bottomControl.center.x, 298);
			_clipsBund.frame = CGRectOffset(_clipsBund.frame, 0, -_clipsBund.frame.size.height - _bottomControl.frame.size.height);
		} completion:^(BOOL finished) {}];
	}else{
		
		[UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^(void) {
			_clipsBund.frame = CGRectOffset(_clipsBund.frame, 0, _clipsBund.frame.size.height + _bottomControl.frame.size.height);
			_topControl.center = CGPointMake(_topControl.center.x, -50); 
			_bottomControl.center = CGPointMake(_bottomControl.center.x, 370);
		} completion:^(BOOL finished) {}];
	}
}

- (void)info{
//	ClipInfoViewController* info = [[ClipInfoViewController alloc] init];
//	[[[(UITabBarController*)self.parentViewController viewControllers] objectAtIndex:[[__delegate tabBarController] selectedIndex]] pushViewController:info animated:YES];
//	[info release];
//	[self dismissMoviePlayerViewControllerAnimated];
	NSArray* arr =[[NSBundle mainBundle] loadNibNamed:@"ArtistInfoView" owner:self options:nil];
 
	ArtistInfoView* infoView = [arr objectAtIndex:0];
	[infoView setHidden:YES];
	[self.view addSubview:infoView];
	[infoView configByClip:_delegate.currentClip];
	
	[UIView animateWithDuration:.4 animations:^(void) {
			[infoView setHidden:NO];
	}];
	[_stopPlayButton setSelected:!_stopPlayButton.selected];
	[self.moviePlayer pause];
	

}
- (void)share:(id)sender{
 
	
	[_stopPlayButton setSelected:!_stopPlayButton.selected];
	[self.moviePlayer pause];
	
	[[SHK currentHelper] setRootViewController:self];

	[SHK setUserExclusions:[NSDictionary dictionaryWithObject:@"1" forKey:@"SHKReadItLater"]];
	SHKItem *item = [SHKItem URL:self.moviePlayer.contentURL title:@""];
	 
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	 
	[actionSheet showInView:self.view];
	
}
- (void)stopPlay:(UIButton*)sender{
	sender.selected = !sender.selected;
	if(self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) [self.moviePlayer pause];
	else if (self.moviePlayer.playbackState == MPMoviePlaybackStatePaused || self.moviePlayer.playbackState == MPMoviePlaybackStateStopped)[self.moviePlayer play];
}
- (void)loadStateDidChange:(NSNotification*)notification{
	switch (self.moviePlayer.loadState) {
		case MPMovieLoadStatePlayable:			
		case MPMovieLoadStatePlaythroughOK:
			_stopPlayButton.selected = NO;
			break;
			case MPMovieLoadStateStalled:
			_stopPlayButton.selected = YES;
			break;
	} 
}
- (void)done{	  
	[self.moviePlayer stop];
	[_delegate done];
}
- (void)next:(UIButton*)sender{ 
	
	self.view.frame = CGRectMake(0, 0, 236, 236);
	[self.moviePlayer stop];  
	
}
- (void)prev:(UIButton*)sender{ 
	
	self.view.frame = CGRectMake(0, 0, 236, 367); 
	[_delegate prev:sender];
}

- (void)addToPlaylist:(Clip*)clip{

	[self.moviePlayer pause];
	
	[_stopPlayButton setSelected:YES];
	
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
//	[self.moviePlayer play];
//	
//	[_stopPlayButton setSelected:NO];
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
