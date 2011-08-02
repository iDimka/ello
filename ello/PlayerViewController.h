//
//  PlayerViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <MediaPlayer/MediaPlayer.h>

typedef enum{
	kNormal = 0,
	kShufle
}PlayMode;

#import "PlayList.h"

@interface PlayerViewController : MPMoviePlayerViewController <UIActionSheetDelegate>{
	UIView*		_topControl;
	UIView*		_bottomControl;	
	PlayMode	_playMode;
	NSInteger	_index;
}

@property(nonatomic, retain)PlayList*	playlist;

- (id)initWithPlaylist:(PlayList*)pl inPlayMode:(PlayMode)mode;

@end
