//
//  PlayerViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <MediaPlayer/MediaPlayer.h>

#import "PlayList.h"

@protocol PlaylistProtocol;

@class Clip;

@interface PlayerViewController : MPMoviePlayerViewController <UIActionSheetDelegate, PlaylistProtocol>{
	UIImageView*			_topControl;
	UIImageView*			_bottomControl;	
	id<PlaylistProtocol>	_delegate;
	Clip*					_currentClip;
	UIScrollView*			_clipsBund;
	UIButton*				_stopPlay;
}

@property(nonatomic, retain)Clip*					currentClip;
@property(nonatomic, assign)id<PlaylistProtocol>	delegate;
@property(nonatomic, retain)PlayList*				playlist;



@end
