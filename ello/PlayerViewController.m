//
//  PlayerViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayerViewController.h"

#import "ClipThumb.h"
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
	 
	 _topControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
	 [_topControl setBackgroundColor:[UIColor darkGrayColor]];
	 [self.view addSubview:_topControl];
	 
	 _bottomControl = [[UIView alloc] initWithFrame:CGRectMake(0, 280, 480, 40)];
	 [_bottomControl setBackgroundColor:[UIColor darkGrayColor]];
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

	}	
	
	 _stopPlay = [UIButton buttonWithType:UIButtonTypeCustom];
	 [_stopPlay setFrame:CGRectMake(10, 2, 32, 30)];
	 [_stopPlay setImage:[UIImage imageNamed:@"player_pause.png"]		forState:UIControlStateNormal];
	 [_stopPlay setImage:[UIImage imageNamed:@"player_play.png"]		forState:UIControlStateSelected];
	[_stopPlay addTarget:self action:@selector(stopPlay:) forControlEvents:UIControlEventTouchUpInside];
	 [_bottomControl addSubview:_stopPlay];
	
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
	_clipsBund.frame = CGRectOffset(_clipsBund.frame, 0, _clipsBund.frame.size.height + _bottomControl.frame.size.height);
	
 
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
	
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
//	[self.moviePlayer stop];
//	for (UIView* v in self.view.subviews)[v removeFromSuperview];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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
			
			_stopPlay.selected = NO;
			break;
 
			case MPMovieLoadStateStalled:
			
			_stopPlay.selected = YES;
			break;
	}
//	NSLog(@"___loadState is %d", self.moviePlayer.loadState);
}
- (void)done{	 
// 	[self.moviePlayer stop];
	[_delegate done];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}
- (void)next:(UIButton*)sender{ 
	
	self.view.frame = CGRectMake(0, 0, 236, 236);
	[self.moviePlayer stop];  
}
- (void)prev:(UIButton*)sender{ 
	
	self.view.frame = CGRectMake(0, 0, 236, 367);
//	[self.moviePlayer stop];
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



/*
 
 2011-08-07 20:27:17.877 ello[35164:f503] *** Assertion failure in -[MPMoviePlayerControllerNew _moviePlayerDidBecomeActiveNotification:], /SourceCache/MobileMusicPlayer_Sim/MobileMusicPlayer-1137.39/SDK/MPMoviePlayerController.m:1236
 2011-08-07 20:27:17.881 ello[35164:f503] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'movie player <MPMoviePlayerControllerNew: 0x5c37120> has wrong activation state (1)'
 *** Call stack at first throw:
 (
 0   CoreFoundation                      0x016675a9 __exceptionPreprocess + 185
 1   libobjc.A.dylib                     0x017bb313 objc_exception_throw + 44
 2   CoreFoundation                      0x0161fef8 +[NSException raise:format:arguments:] + 136
 3   Foundation                          0x0018a3bb -[NSAssertionHandler handleFailureInMethod:object:file:lineNumber:description:] + 116
 4   MediaPlayer                         0x00952850 -[MPMoviePlayerControllerNew _moviePlayerDidBecomeActiveNotification:] + 204
 5   Foundation                          0x000f9669 _nsnote_callback + 145
 6   CoreFoundation                      0x0163f9f9 __CFXNotificationPost_old + 745
 7   CoreFoundation                      0x015be93a _CFXNotificationPostNotification + 186
 8   Foundation                          0x000ef20e -[NSNotificationCenter postNotificationName:object:userInfo:] + 134
 9   MediaPlayer                         0x00951e08 -[MPMoviePlayerControllerNew _postNotificationName:object:] + 56
 10  MediaPlayer                         0x009593f7 -[MPMoviePlayerControllerNew _ensureActive] + 158
 11  MediaPlayer                         0x009542e8 -[MPMoviePlayerControllerNew setControlStyle:] + 45
 12  MediaPlayer                         0x009abff3 -[MPMoviePlayerViewController moviePlayer] + 201
 13  MediaPlayer                         0x009ac215 -[MPMoviePlayerViewController initWithContentURL:] + 63
 14  ello                                0x0000cf7d -[PreviewViewController next:] + 909
 15  ello                                0x0000c3c5 -[PreviewViewController viewWillAppear:] + 309
 16  UIKit                               0x00c11210 -[UINavigationController viewWillAppear:] + 334
 17  UIKit                               0x00c19622 -[UITabBarController viewWillAppear:] + 131
 18  UIKit                               0x00e078e4 -[UIWindowController transition:fromViewController:toViewController:target:didEndSelector:] + 6192
 19  UIKit                               0x00c0c385 -[UIViewController _dismissModalViewControllerWithTransition:from:] + 2058
 20  UIKit                               0x00c08eb8 -[UIViewController dismissModalViewControllerWithTransition:] + 940
 21  MediaPlayer                         0x009abbea __-[UIViewController(MPMoviePlayerViewController) dismissMoviePlayerViewControllerAnimated]_block_invoke_1 + 45
 22  MediaPlayer                         0x009acb1d -[UIViewController(MPMoviePlayerViewController) dismissMoviePlayerViewControllerAnimated] + 281
 23  Foundation                          0x000f9669 _nsnote_callback + 145
 24  CoreFoundation                      0x0163f9f9 __CFXNotificationPost_old + 745
 25  CoreFoundation                      0x015be93a _CFXNotificationPostNotification + 186
 26  Foundation                          0x000ef20e -[NSNotificationCenter postNotificationName:object:userInfo:] + 134
 27  MediaPlayer                         0x00951d24 -[MPMoviePlayerControllerNew _postDidFinishNotificationWithUserInfo:] + 69
 28  Foundation                          0x000f9669 _nsnote_callback + 145
 29  CoreFoundation                      0x0163f9f9 __CFXNotificationPost_old + 745
 30  CoreFoundation                      0x015be93a _CFXNotificationPostNotification + 186
 31  Foundation                          0x000ef20e -[NSNotificationCenter postNotificationName:object:userInfo:] + 134
 32  MediaPlayer                         0x0096d974 -[MPAVController _itemPlaybackDidEndNotification:] + 491
 33  Foundation                          0x000f9669 _nsnote_callback + 145
 34  CoreFoundation                      0x0163f9f9 __CFXNotificationPost_old + 745
 35  CoreFoundation                      0x015be93a _CFXNotificationPostNotification + 186
 36  Foundation                          0x000ef20e -[NSNotificationCenter postNotificationName:object:userInfo:] + 134
 37  Celestial                           0x02b8c7a7 -[NSObject(NSObject_AVShared) postNotificationWithDescription:] + 176
 38  Celestial                           0x02b90a7d -[AVController itemHasFinishedPlayingNotification:] + 169
 39  Celestial                           0x02b949ca -[AVController fpItemNotification:sender:] + 2177
 40  Celestial                           0x02b9ea8d -[AVPlaybackItem fpItemNotificationInfo:] + 1473
 41  Celestial                           0x02b8cf51 -[AVObjectRegistry safeInvokeWithDescription:] + 211
 42  Foundation                          0x0010e94e __NSThreadPerformPerform + 251
 43  CoreFoundation                      0x016488ff __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 15
 44  CoreFoundation                      0x015a688b __CFRunLoopDoSources0 + 571
 45  CoreFoundation                      0x015a5d86 __CFRunLoopRun + 470
 46  CoreFoundation                      0x015a5840 CFRunLoopRunSpecific + 208
 47  CoreFoundation                      0x015a5761 CFRunLoopRunInMode + 97
 48  GraphicsServices                    0x020271c4 GSEventRunModal + 217
 49  GraphicsServices                    0x02027289 GSEventRun + 115
 50  UIKit                               0x00b65c93 UIApplicationMain + 1160
 51  ello                                0x0000273f main + 127
 52  ello                                0x000026b5 start + 53
 )
 terminate called throwing an exception[Switching to process 35164 thread 0xf503]
 Current language:  auto; currently objective-c

 */
