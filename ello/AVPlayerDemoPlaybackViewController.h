 

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PreviewViewController;
@class Clip;
@class PlayList;
@class AVPlayer;
@class AVPlayerDemoPlaybackView;

@interface AVPlayerDemoPlaybackViewController : UIViewController
{
@private
	IBOutlet AVPlayerDemoPlaybackView* mPlaybackView;
	
	IBOutlet UISlider* mScrubber;
    IBOutlet UIToolbar *mToolbar;
    IBOutlet UIBarButtonItem *mPlayButton;
    IBOutlet UIBarButtonItem *mStopButton;

	float mRestoreAfterScrubbingRate;
	BOOL seekToZeroBeforePlay;
	id mTimeObserver;

	NSURL* mURL;
    
	AVPlayer* mPlayer;
    AVPlayerItem * mPlayerItem;
	
	NSInvocationOperation*		_previewItiter;
	PreviewViewController*		_previewViewController;
}

@property (nonatomic, assign)id avdelegate;
@property (nonatomic, copy) NSURL* URL;
@property (readwrite, retain, setter=setPlayer:, getter=player) AVPlayer* mPlayer;
@property (retain) AVPlayerItem* mPlayerItem;
@property (nonatomic, retain) IBOutlet AVPlayerDemoPlaybackView *mPlaybackView;
@property (nonatomic, retain) IBOutlet UIToolbar *mToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mPlayButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mStopButton;
@property (nonatomic, retain) IBOutlet UISlider* mScrubber;
 
- (id)initWithYouTubeVideo:(Clip*)clip;
- (id)initWithClip:(Clip*)clip;
- (id)initWithPlaylist:(PlayList*)playlist;

@end
