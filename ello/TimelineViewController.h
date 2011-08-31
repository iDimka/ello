//
//  TimelineViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 29/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import <MediaPlayer/MediaPlayer.h>

#import "SliderThumbView.h"

@class SecondLineView;

@interface TimelineViewController : UIImageView{
	SecondLineView*			_timeLineView;	
	SliderThumbView*		_thumbOne;
	NSTimer*				_timer;
}

@property (nonatomic, assign) MPMoviePlayerController* dataSource;

@end
