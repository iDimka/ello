//
//  MultiPlayerViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 04/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import "PreviewViewController.h"
//typedef enum{
//	kNormal = 0,
//	kShufle
//}PlayMode;

@class PlayList;

@interface MultiPlayerViewController : UIViewController{
	MPMoviePlayerController*		_moviePlayer;
	PlayList*						_playlist;
	PlayMode						_playMode;	
	NSInteger						_index;
}

- (id)initWithPlaylist:(PlayList*)playlist inPlayMode:(PlayMode)mode;

@end
