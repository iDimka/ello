 
#import "AVPlayerDemoPlaybackViewController.h"
#import "AVPlayerDemoPlaybackView.h"
#import "AVPlayerDemoMetadataViewController.h"

#import "PreviewViewController.h"
#import "Preroll.h"
#import "Prerolls.h"
#import "AdView.h"
#import "AdViews.h"
#import "PlayList.h"
#import "Clip.h"
#import "Clips.h"
#import "asyncimageview.h"
#import "PlayerViewController.h" 

/* Asset keys */
NSString * const kTracksKey         = @"tracks";
NSString * const kPlayableKey		= @"playable";

/* PlayerItem keys */
NSString * const kStatusKey         = @"status";

/* AVPlayer keys */
NSString * const kRateKey			= @"rate";
NSString * const kCurrentItemKey	= @"currentItem";

@interface AVPlayerDemoPlaybackViewController ()
- (void)play:(id)sender;
- (void)pause:(id)sender;
- (void)showMetadata:(id)sender;
- (void)initScrubberTimer;
- (void)showPlayButton;
- (void)showStopButton;
- (void)syncScrubber;
- (void)beginScrubbing:(id)sender;
- (void)scrub:(id)sender;
- (void)endScrubbing:(id)sender;
- (BOOL)isScrubbing;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (id)init;
- (void)dealloc;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)viewDidLoad;
- (void)viewWillDisappear:(BOOL)animated;
- (void)handleSwipe:(UISwipeGestureRecognizer*)gestureRecognizer;
//- (void)syncPlayPauseButtons;
- (void)setURL:(NSURL*)URL;
- (NSURL*)URL;
@end

@interface AVPlayerDemoPlaybackViewController (Player)
 
//- (BOOL)isPlaying;
- (void)playerItemDidReachEnd:(NSNotification *)notification ;
- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context;
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
@end

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;

#pragma mark -
@implementation AVPlayerDemoPlaybackViewController

@synthesize avdelegate;
@synthesize mPlayer, mPlayerItem, mPlaybackView, mToolbar, mPlayButton, mStopButton, mScrubber;
 


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


#pragma mark Asset URL

- (void)setURL:(NSURL*)URL{
	if (mURL != URL)
	{
		[mURL release];
		mURL = [URL copy];
	 
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mURL options:nil]; 
        NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil]; 
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{		 
             dispatch_async( dispatch_get_main_queue(), 
                            ^{ 
                                [self prepareToPlayAsset:asset withKeys:requestedKeys];
                            });
         }];
	}
}
- (NSURL*)URL{
	return mURL;
}
  
#pragma mark
#pragma mark View Controller
 
- (id)init{
	_previewViewController = [PreviewViewController alloc];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        return [self initWithNibName:@"AVPlayerDemoPlaybackView-iPad" bundle:nil];
	} 
    else 
    {
        return [self initWithNibName:@"AVPlayerDemoPlaybackView" bundle:nil];
	}
}
  
- (void)viewDidLoad{
	[super viewDidLoad];
	
	
	[[self view] setBounds:CGRectMake(0, 0, 480, 320)];
	[[self view] setCenter:CGPointMake(160, 240)];
	[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}
 
- (void)dealloc{
 	 
	[mPlayer.currentItem removeObserver:self forKeyPath:@"status"];
	
	[mPlayer pause];
	[mPlayer release];
	
	[mURL release];
	
	[super dealloc];
}

@end

@implementation AVPlayerDemoPlaybackViewController (Player)

#pragma mark Player Item
  
- (void)playerItemDidReachEnd:(NSNotification *)notification { 
	[_previewItiter start];
	[_previewItiter waitUntilFinished];
	[self.view removeFromSuperview]; 
	[avdelegate showClip:_previewItiter];
} 

#pragma mark -
#pragma mark Error Handling - Preparing Assets for Playback Failed
  
-(void)assetFailedToPrepareForPlayback:(NSError *)error{
  
    
    /* Display the error. */
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
														message:[error localizedFailureReason]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark Prepare to play asset, URL
 
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys{
    /* Make sure that the value of each key has loaded successfully. */
	for (NSString *thisKey in requestedKeys)
	{
		NSError *error = nil;
		AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
		if (keyStatus == AVKeyValueStatusFailed)
		{
			[self assetFailedToPrepareForPlayback:error];
			return;
		}
		/* If you are also implementing -[AVAsset cancelLoading], add your code here to bail out properly in the case of cancellation. */
	}
     
	
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.mPlayerItem addObserver:self 
                      forKeyPath:kStatusKey 
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
	
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.mPlayerItem];
	
    seekToZeroBeforePlay = NO;
	
    /* Create new player, if we don't already have one. */
    if (![self player])
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.mPlayerItem]];	
	[self.player addObserver:self 
				  forKeyPath:kCurrentItemKey 
					 options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
					 context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];

        /* Observe the AVPlayer "rate" property to update the scrubber control. */
//        [self.player addObserver:self 
//                      forKeyPath:kRateKey 
//                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
//                         context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.player.currentItem != self.mPlayerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs 
         asynchronously; observe the currentItem property to find out when the 
         replacement will/did occur*/
        [[self player] replaceCurrentItemWithPlayerItem:self.mPlayerItem];
         
    }
 
}
- (void)observeValueForKeyPath:(NSString*) path	ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
	/* AVPlayerItem "status" property value observer. */
	if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext)
	{
//		[self syncPlayPauseButtons];

        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
           
            case AVPlayerStatusReadyToPlay:
            { 
			[mPlayer play];
            }
            break;
                
            case AVPlayerStatusFailed:
            {
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
            break;
        }
	}  
	else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
	{ 
            [mPlaybackView setPlayer:mPlayer]; 
//            [mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect]; 
	}
	else
	{
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
	}
}


@end

