//
//  TimeLineView.h
//  ello
//
//  Created by Dmitry Sazanovich on 28/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

@interface SecondLineView : UIImageView{
	
	UIImageView*	_playedTime;
	UIImageView*	_bufferedTime;
	NSTimer*		_timer;
	
}

@property MPMoviePlayerController* dataSource;

@end
