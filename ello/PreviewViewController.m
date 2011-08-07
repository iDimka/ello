//
//  PreviewViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PreviewViewController.h"

#import "PlayList.h"
#import "Clip.h"
#import "Clips.h"
#import "asyncimageview.h"
#import "PlayerViewController.h"

@interface PreviewViewController()

@property(nonatomic, retain)Clip*					currentClip;
@property(nonatomic, retain)PlayerViewController*	moviePlayer;

- (void)prev:(UIButton*)sender;
- (void)next:(UIButton*)sender;

@end

@implementation PreviewViewController

@synthesize moviePlayer = _moviePlayer;
@synthesize playlist = _playlist;
@synthesize sun;
@synthesize thumbView;
@synthesize artistName;
@synthesize clipName;
@synthesize viewCount;
@synthesize currentClip = _currentClip;

#pragma mark - View lifecycle

- (id)initWithPlaylist:(PlayList*)playlist inPlayMode:(PlayMode)mode {
    self = [super init];
    if (self) {
		_playMode = mode;
		_playCountMode = kMultiClips;
        _playlist = [playlist retain];
		
		switch ((int)_playMode) {
			case kNormal:
				self.currentClip = [_playlist.clips objectAtIndex:_index];
				_moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
				break; 
			case kShufle:
				[self next:nil];
				break;
		}
		_moviePlayer.delegate = self;
	}
	return self;
}
- (id)initWithClip:(Clip*)clip{
    self = [super init];
    if (self) {
		_playMode = kNormal; 	
		_playCountMode = kSingleClip;
		self.currentClip = clip;
        _playlist = [PlayList new];
		[_playlist.clips addObject:clip];
		
		switch ((int)_playMode) {
			case kNormal:
				_moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
				break; 
			case kShufle:
				[self next:nil];
				break;
		}
		
	}
	return self;
}
  
- (void)viewWillAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:)	name:MPMoviePlayerLoadStateDidChangeNotification		object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:)	name:MPMoviePlayerPlaybackDidFinishNotification			object:nil];
	 
	if (_playCountMode == kMultiClips) {
//		[self next:nil];
	}
	
	if ([_currentClip thumb])[self.thumbView setImage:_currentClip.thumb];
	else [self.thumbView loadImageFromURL:[NSURL URLWithString:[_currentClip clipImageURL]]];
	
	[self.artistName setText:_currentClip.artistName];
	[self.clipName setText:_currentClip.clipName];
	[self.viewCount setText:[NSString stringWithFormat:@"%d views", [_currentClip.viewCount intValue]]];
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	[_moviePlayer.moviePlayer stop]; 
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}
  
- (void)push4play{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:)	name:MPMoviePlayerLoadStateDidChangeNotification		object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:)	name:MPMoviePlayerPlaybackDidFinishNotification			object:nil];
	self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
	[sun startAnimating];
}
- (void)playClip:(Clip*)clip{
	
}
- (void)loadStateDidChange:(NSNotification*)notification{
	switch ([self.moviePlayer.moviePlayer loadState]) {
		case MPMovieLoadStatePlayable:			
//		case MPMovieLoadStatePlaythroughOK:
			[[NSNotificationCenter defaultCenter] removeObserver:self];
			[sun stopAnimating];
			[self presentMoviePlayerViewControllerAnimated:_moviePlayer]; 
			break;
		case MPMovieLoadStateStalled:
			
			break;
	}
	NSLog(@"loadState is %d", self.moviePlayer.moviePlayer.loadState);
}
- (void)playbackDidFinish:(NSNotification*)notification{
	MPMovieFinishReason reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
	if (MPMovieFinishReasonPlaybackEnded == reason) [self next:nil];
}
- (void)done{
	_playCountMode = kDone;	
}
- (void)next:(UIButton*)sender{
	[self.moviePlayer dismissModalViewControllerAnimated:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:)	name:MPMoviePlayerLoadStateDidChangeNotification		object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:)	name:MPMoviePlayerPlaybackDidFinishNotification			object:nil];
	switch (_playMode)
	{
		case kNormal:
		
		if (_index == [_playlist.clips count] - 1) {
			[self.navigationController popViewControllerAnimated:YES];
			return;
		};
		self.currentClip = [_playlist.clips objectAtIndex:++_index];
		self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
		
		break;
		
		case kShufle:
		
		self.currentClip = [_playlist.clips objectAtIndex:(arc4random()% [_playlist.clips count])];
		self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
		
		break;
	}
	[sun startAnimating];
	self.moviePlayer.delegate = self;
}
- (void)prev:(UIButton*)sender{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:)	name:MPMoviePlayerLoadStateDidChangeNotification		object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:)	name:MPMoviePlayerPlaybackDidFinishNotification			object:nil];
	switch (_playMode){
		case kNormal:
			if (_index == 0) {
				[self.navigationController popViewControllerAnimated:YES];
				return;
			};
			self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[[_playlist.clips objectAtIndex:--_index] clipVideoURL]]];
			break;
			
		case kShufle:
			self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[[_playlist.clips objectAtIndex:(arc4random()% [_playlist.clips count])] clipVideoURL]]];
			break;
	}
	[sun startAnimating];
	self.moviePlayer.delegate = self;
}

- (void)dealloc {
	
    self.sun = nil;
	[_moviePlayer release];
	
    [super dealloc];
}

@end
