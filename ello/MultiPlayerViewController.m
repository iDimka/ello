//
//  MultiPlayerViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 04/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "MultiPlayerViewController.h"

#import "PlayList.h"
#import "Clip.h"
#import "Clips.h"

@interface MultiPlayerViewController()

@property(nonatomic, retain)MPMoviePlayerController*	moviePlayer;

- (void)next:(UIButton*)sender;

@end

@implementation MultiPlayerViewController

@synthesize moviePlayer = _moviePlayer;

- (id)initWithPlaylist:(PlayList*)playlist inPlayMode:(PlayMode)mode {
    self = [super init];
    if (self) {
		_playMode = mode;
        _playlist = [playlist retain];
		

			switch ((int)_playMode) {
				case kNormal:
					self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[[_playlist.clips objectAtIndex:_index] clipVideoURL]]];
					break;
					
				default:
					break;
			}
			
		}
		return self;
	}
- (void)dealloc {
    
	self.moviePlayer = nil;
	
    [super dealloc];
}

#pragma mark
#pragma mark - View lifecycle

- (void)viewDidLoad{
//	
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}
- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)playClip:(Clip*)clip{
	
}
- (void)loadStateDidChange:(NSNotification*)notification{
	switch (self.moviePlayer.loadState) {
		case MPMovieLoadStatePlayable:			
		case MPMovieLoadStatePlaythroughOK:
			
			break;
		case MPMovieLoadStateStalled:
			
			break;
	}
	NSLog(@"loadState is %d", self.moviePlayer.loadState);
}
- (void)playbackDidFinish:(NSNotification*)notification{
	MPMovieFinishReason reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
	if (MPMovieFinishReasonPlaybackEnded == reason) [self next:nil];
}
- (void)next:(UIButton*)sender{
	switch (_playMode)
	{
		case kNormal:
			if (_index == [_playlist.clips count] - 1) return;
			self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[[_playlist.clips objectAtIndex:++_index] clipVideoURL]]];
			break;
			
		case kShufle:
			self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[[_playlist.clips objectAtIndex:(arc4random()% [_playlist.clips count])] clipVideoURL]]];
			break;
	}
}
- (void)prev:(UIButton*)sender{
	switch (_playMode){
		case kNormal:
			if (_index == 0) return;
			self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[[_playlist.clips objectAtIndex:--_index] clipVideoURL]]];
			break;
			
		case kShufle:
			self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[[_playlist.clips objectAtIndex:(arc4random()% [_playlist.clips count])] clipVideoURL]]];
			break;
	}
}

@end
