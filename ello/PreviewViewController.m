//
//  PreviewViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PreviewViewController.h"

#import "Clip.h"
#import "asyncimageview.h"
#import "PlayerViewController.h"

@implementation PreviewViewController

@synthesize sun;
@synthesize thumbView;
@synthesize artistName;
@synthesize clipName;
@synthesize viewCount;
@synthesize clip;
 
#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push4play) name:MPMoviePlayerContentPreloadDidFinishNotification object:nil];
	
	_moviePlayer = [[PlayerViewController alloc] initWithContentURL:[NSURL URLWithString:clip.clipVideoURL]];

	if ([self.clip thumb]) {
		[self.thumbView setImage:self.clip.thumb];
	}else [self.thumbView loadImageFromURL:[NSURL URLWithString:[self.clip clipImageURL]]];
	[self.artistName setText:self.clip.artistName];
	[self.clipName setText:self.clip.clipName];
	[self.viewCount setText:[NSString stringWithFormat:@"%d views", [clip.viewCount intValue]]];
	
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)push4play{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[sun stopAnimating];
	[self presentMoviePlayerViewControllerAnimated:_moviePlayer]; 	
}

- (void)dealloc {

    self.sun = nil;
	[_moviePlayer release];
	
    [super dealloc];
}

@end
