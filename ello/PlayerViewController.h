//
//  PlayerViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <MediaPlayer/MediaPlayer.h>

@interface PlayerViewController : MPMoviePlayerViewController {
	UIView*	_topControl;
	UIView* _bottomControl;
	
}

@end
