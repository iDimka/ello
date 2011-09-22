//
//  PrerollViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 18/09/2011.
//  Copyright (c) 2011 iDimka. All rights reserved.
//

#import "PrerollViewController.h"

#import "Preroll.h"
#import "Prerolls.h"
#import "AdView.h"
#import "AdViews.h"
#import "PlayList.h"
#import "Clip.h"
#import "Clips.h"
#import "asyncimageview.h"
#import "PlayerViewController.h" 

@implementation PrerollViewController

@synthesize prerollDelegate;

+ (BOOL)hasPreroll{
	NSData* payload = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://50.17.200.31/service.php?service=preroll&action=getPreroll"]] returningResponse:nil error:nil];
	
	
	return payload != nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _previewViewController = [PreviewViewController alloc];
		
    }
    return self;
}

- (id)initWithYouTubeVideo:(Clip*)clip{
	if (self = [self init]) 
		{		 					
			_previewItiter = [[NSInvocationOperation alloc] initWithTarget:_previewViewController selector:_cmd object:clip];
		}
	return self;
}
- (id)initWithPlaylist:(PlayList*)playlist{
    self = [self init];
    if (self) { 
		_previewItiter = [[NSInvocationOperation alloc] initWithTarget:_previewViewController selector:_cmd object:playlist];
	}
	return self;
}
- (id)initWithClip:(Clip*)clip{
	
    self = [self init];
    if (self) {
		_previewItiter = [[NSInvocationOperation alloc] initWithTarget:_previewViewController selector:_cmd object:clip];
	}
	return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
	//    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:)	name:MPMoviePlayerPlaybackDidFinishNotification		object:nil];
	
	[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=preroll&action=getPreroll" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"prerolls"] delegate:self]; 
} 

- (void)playbackDidFinish:(NSNotification*)notification{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	
	[_previewItiter start];
	[_previewItiter waitUntilFinished]; 
	[self dismissMoviePlayerViewControllerAnimated];
	[self.navigationController popViewControllerAnimated:NO];
//	[prerollDelegate performSelector:@selector(showClip:) withObject:_previewItiter];
	[prerollDelegate performSelector:@selector(showClip:) withObject:_previewItiter afterDelay:.7];	
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
		
		if ([[objects objectAtIndex:0] isKindOfClass:[Prerolls class]]) 
			{ 
				NSURL* url = [NSURL URLWithString:[[[[objects objectAtIndex:0] prerolls] objectAtIndex:0] preollURL]];
				MPMoviePlayerViewController* moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url]; 
//				[moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleNone];
				[self presentMoviePlayerViewControllerAnimated:moviePlayer];
			}
		}
	
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s", __func__);
    [super dealloc];
}

@end
