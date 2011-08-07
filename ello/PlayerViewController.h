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

@interface PlayerViewController : MPMoviePlayerViewController <UIActionSheetDelegate>{
	UIView*					_topControl;
	UIView*					_bottomControl;	
	id<PlaylistProtocol>	_delegate;
	Clip*					_currentClip;
}

@property(nonatomic, retain)Clip*					currentClip;
@property(nonatomic, assign)id<PlaylistProtocol>	delegate;
@property(nonatomic, retain)PlayList*				playlist;



@end
