//
//  PreviewViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PreviewViewController.h"

#import "Preroll.h"
#import "Prerolls.h"
#import "AdViews.h"
#import "PlayList.h"
#import "Clip.h"
#import "Clips.h"
#import "asyncimageview.h"
#import "PlayerViewController.h"



@interface PreviewViewController()

@property(nonatomic, retain)UIWebView*	webPlayer;
@property(nonatomic, retain)PlayerViewController*	moviePlayer;

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame;
- (void)prev:(UIButton*)sender;
- (void)next:(UIButton*)sender;

@end

@implementation PreviewViewController

@synthesize trackPosition;
@synthesize webPlayer;
@synthesize moviePlayer = _moviePlayer;
@synthesize playlist = _playlist;
@synthesize sun;
@synthesize thumbView;
@synthesize artistName;
@synthesize clipName;
@synthesize viewCount;
@synthesize currentClip = _currentClip;

#pragma mark - View lifecycle

- (id)init {NSLog(@"%s", __func__);
    self = [super init];
    if (self) {
		
		[self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}
- (id)initWithYouTubeVideo:(Clip*)clip{
	if (self = [self init]) 
		{		
		_playMode = kYouTubeClip; 	
		_playCountMode = kYouTubeClip;
		self.currentClip = clip;						
			
	}
	return self;
}
- (id)initWithPlaylist:(PlayList*)playlist{
    self = [self init];
    if (self) {
		_playMode = playlist.playMode;
		_playCountMode = kMultiClips;
        _playlist = [playlist retain]; 
		
		switch ((int)_playMode) {
			case kNormal:
				self.currentClip = [_playlist.clips objectAtIndex:_index];
				_moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
				[_moviePlayer setPlaylist:_playlist];
				[_moviePlayer setDelegate:self];
				break; 
			case kShufle:
				[self next:nil];
				break;
		}
		trackPosition.text = [NSString stringWithFormat:@"%d из %d", _index + 1, [[_playlist clips] count]];
							  
	}
	return self;
}
- (id)initWithClip:(Clip*)clip{
	
	
	if ([clip.type isEqualToString:@"youtube"]) 
		{ 
		return [self initWithYouTubeVideo:clip];		
	}
    self = [self init];
    if (self) {
		_playMode = kNormal; 	
		_playCountMode = kSingleClip;
		self.currentClip = clip;
        _playlist = [PlayList new];
		[_playlist.clips addObject:clip];
		 
		self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
		[_moviePlayer release];
		_moviePlayer.delegate = self; 
	}
	return self;
}
   
- (void)viewDidLoad{
	[super viewDidLoad];
	 
	
	[[self view] setBounds:CGRectMake(0, 0, 480, 320)];
	[[self view] setCenter:CGPointMake(160, 240)];
	[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
	
 	
	if (_playMode == kYouTubeClip) {
		[self embedYouTube:_currentClip.clipVideoURL frame:CGRectMake(26, 89, 161, 121)];
		
		[_buffering setHidden:YES];
		[sun stopAnimating];
		
		UIButton* share = [UIButton buttonWithType:UIButtonTypeCustom];
		[share setFrame:CGRectMake(100, 10, 33, 37)];
		[share setImage:[UIImage imageNamed:@"btnShare.png"] forState:UIControlStateNormal];
		[share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:share];
	}
	if ([self.currentClip.type isEqualToString:@"youtube"]) _youTubeIcn.hidden = NO; 
	
	[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=banner&action=getBanner" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"banners"] delegate:self]; 

}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillDisappear:animated];
	 
 	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
	
	if ([_currentClip thumb])[self.thumbView setImage:_currentClip.thumb];
	else [self.thumbView loadImageFromURL:[NSURL URLWithString:[_currentClip clipImageURL]]];
	[self.artistName setText:_currentClip.artistName];
	[self.clipName setText:_currentClip.clipName];
	[self.viewCount setText:[NSString stringWithFormat:@"%d views", [_currentClip.viewCount intValue]]];

	if (_playCountMode == kMultiClips) 
		{		
//			trackPosition.text = [NSString stringWithFormat:@"%d из %d", _index + 1, [[_playlist clips] count]];
		}

}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[_buffering setHidden:YES];
	[self.moviePlayer.moviePlayer stop];
	self.moviePlayer = nil; 
} 
- (void)viewDidUnload{
	[_youTubeIcn release];
	_youTubeIcn = nil;
	[super viewDidUnload];
	 
}

- (void)bannerViewDidLoadAd:(AdView *)banner{
	[banner setFrame:CGRectMake(160, 215, 320, 50)];
	[UIView animateWithDuration:.4 animations:^{
		[self.view addSubview:banner];
	}];
}
- (void)bannerViewDidError:(AdView *)banner{
	
}

- (void)push4play{ NSLog(@"%s", __func__);
	PlayerViewController* tmp = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
	self.moviePlayer = tmp;
	[tmp release];
	
	[_buffering setHidden:NO];
	[sun startAnimating];
}
 
- (void)loadStateDidChange:(NSNotification*)notification{
//	NSLog(@"load State is %d ", _moviePlayer.moviePlayer.loadState );
	
	switch (_moviePlayer.moviePlayer.loadState) 
	{
		case MPMovieLoadStatePlayable:			
		case MPMovieLoadStatePlaythroughOK: 
#warning may be need unkoment		
//		if (_playCountMode == kMultiClips) 
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:)	name:MPMoviePlayerPlaybackDidFinishNotification		object:nil];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
			[sun stopAnimating];
			[_buffering setHidden:YES];
			if (_playCountMode != kDone) [self presentMoviePlayerViewControllerAnimated:_moviePlayer]; 
			break; 
	}
}
- (void)playbackDidFinish:(NSNotification*)notification{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	
	MPMovieFinishReason reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
	NSLog(@"reason %d", reason);
	if (MPMovieFinishReasonPlaybackEnded == reason && _playCountMode != kDone) [self next:nil];;
}
- (void)done{NSLog(@"%s", __func__);
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	_playCountMode = kDone;	
	[self.navigationController popViewControllerAnimated:NO];
}
- (void)next:(UIButton*)sender{NSLog(@"%s %d", __func__, _index);
	 
	[self.moviePlayer.moviePlayer stop];
	[self.moviePlayer dismissModalViewControllerAnimated:YES]; 
	switch (_playMode)
	{
		case kNormal:
		
		if (++_index == [_playlist.clips count]) {
			[self.navigationController popViewControllerAnimated:YES];
			return;
		};
		self.currentClip = [_playlist.clips objectAtIndex:_index];
		self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
		[_moviePlayer release];
		
		break;
		
		case kShufle:
		_index = arc4random()% [_playlist.clips count];
		self.currentClip = [_playlist.clips objectAtIndex:_index];
		self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
		[_moviePlayer release];
		
		break;
	}

	[sun startAnimating];
	[_buffering setHidden:NO];
	[_moviePlayer setPlaylist:_playlist];
	_moviePlayer.delegate = self;

	if (_playCountMode == kMultiClips) 
		{		
			trackPosition.text = [NSString stringWithFormat:@"%d из %d", _index + 1, [[_playlist clips] count]];
		}
	if ([self.currentClip.type isEqualToString:@"youtube"]) _youTubeIcn.hidden = NO;
}
- (void)prev:(UIButton*)sender{NSLog(@"%s %d", __func__, _index);
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	[self.moviePlayer.moviePlayer stop];
	[self.moviePlayer dismissModalViewControllerAnimated:YES];  
	switch (_playMode){
		case kNormal:
			if (_index == 0) {
				[self.navigationController popViewControllerAnimated:YES];
				return;
			};
			self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[[_playlist.clips objectAtIndex:--_index] clipVideoURL]]];
			[_moviePlayer release];
			break;
			
		case kShufle:
			
			_index = arc4random()% [_playlist.clips count];
			self.currentClip = [_playlist.clips objectAtIndex:_index];
			self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
			[_moviePlayer release];
			break;
	}
	[sun startAnimating];
	[_buffering setHidden:NO];	
	[_moviePlayer setPlaylist:_playlist];
	_moviePlayer.delegate = self;
	if (_playCountMode == kMultiClips) 
		{		
		trackPosition.text = [NSString stringWithFormat:@"%d из %d", _index + 1, [[_playlist clips] count]];
		}
	if ([self.currentClip.type isEqualToString:@"youtube"]) _youTubeIcn.hidden = NO;
}
- (void)selectClip:(Clip*)clip{
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	_index = [_playlist.clips indexOfObject:clip];
									 NSLog(@"%s %d", __func__, _index);
	[self.moviePlayer.moviePlayer stop]; 
	self.currentClip = clip;
	self.moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[_currentClip clipVideoURL]]];
	[_moviePlayer release];
	[sun startAnimating];
		[_buffering setHidden:NO];
	[_moviePlayer setPlaylist:_playlist];
	_moviePlayer.delegate = self;
	[self.moviePlayer dismissModalViewControllerAnimated:YES];
	
	if ([_currentClip thumb])[self.thumbView setImage:_currentClip.thumb];
	else [self.thumbView loadImageFromURL:[NSURL URLWithString:[_currentClip clipImageURL]]];
	
	[self.artistName setText:_currentClip.artistName];
	[self.clipName setText:_currentClip.clipName];
	[self.viewCount setText:[NSString stringWithFormat:@"%d views", [_currentClip.viewCount intValue]]];
 
	trackPosition.text = [NSString stringWithFormat:@"%d из %d", _index + 1, [[_playlist clips] count]];

}
- (IBAction)back:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame {
    NSString *embedHTML = @"<html><head>\
	<body style=\"margin:0\">\
	<embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" height=\"%0.0f\"></embed>\
	</body></html>";
    NSString *html = [NSString stringWithFormat:embedHTML, urlString, frame.size.width, frame.size.height];
    UIWebView *videoView = [[UIWebView alloc] initWithFrame:frame];
    [videoView loadHTMLString:html baseURL:nil];
    [self.view addSubview:videoView];
    [videoView release];
}

- (void)share:(id)sender{
	 
	[[SHK currentHelper] setRootViewController:self];
	
	[SHK setUserExclusions:[NSDictionary dictionaryWithObject:@"1" forKey:@"SHKReadItLater"]];
	SHKItem *item = [SHKItem URL:[NSURL URLWithString:_currentClip.clipVideoURL] title:_currentClip.clipName];
	
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	[actionSheet showInView:self.view];
	
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	NSLog(@"ldd %@\n\n", objects);
	if ([objects count]) 
		{
		if ([[objects objectAtIndex:0] isKindOfClass:[AdViews class]]) {
			[[[[objects objectAtIndex:0] banners] objectAtIndex:0] retain];
			[[[[objects objectAtIndex:0] banners] objectAtIndex:0] setAddelegate:self];
			[[[[objects objectAtIndex:0] banners] objectAtIndex:0] loadAdvert];
			return;
		}
		}
	
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}


- (void)dealloc {//NSLog(@"%s", __func__);
		
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.webPlayer = nil;
    self.sun = nil;
	[_moviePlayer release];
	
	[_youTubeIcn release];
    [super dealloc];
}

@end

/*
 
 NSString* htmlString = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 320\"/></head><body style=\"background:#000;margin-top:0px;margin-left:0px\">\
 <div><object width=\"320\" height=\"372\">\
 <param name=\"movie\" value=\"http://www.youtube.com/v/oHg5SJYRHA0&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"></param>\
 <param name=\"wmode\" value=\"transparent\"></param>\
 <embed src=\"%@\"\
 type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"320\" height=\"416\"></embed>\
 </object></div></body></html>", _url];
 
 [_webView loadHTMLString:htmlString baseURL:_url];
 
 */