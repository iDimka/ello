//
//  PlayerViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

#import "PreviewViewController.h"
#import "ClipThumb.h"
#import "PlayLists.h"
#import "PlayList.h"

@class TimelineViewController;
@class Clip;

@interface PlayerViewController : MPMoviePlayerViewController <UIActionSheetDelegate, ClipThumbProtocol>{
	UIImageView*			_topControl;
	UIImageView*			_bottomControl;	
	id<PlaylistProtocol>	_delegate;
	Clip*					_currentClip;
	UIScrollView*			_clipsBund;
	UIButton*				_stopPlayButton;
	TimelineViewController*	_timeLineView;
}

@property(nonatomic, retain)Clip*					currentClip;
@property(nonatomic, assign)id<PlaylistProtocol>	delegate;
@property(nonatomic, retain)PlayList*				playlist;



@end
