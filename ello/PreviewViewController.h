//
//  PreviewViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClipThumb.h"

typedef enum{
	kNormal = 0,
	kShufle
}PlayMode;

typedef enum{
	kSingleClip,
	kMultiClips,
	kDone
}PlayCountMode;

@protocol PlaylistProtocol <NSObject>

@property(nonatomic, retain)Clip*					currentClip;

- (void)done;
- (void)next:(UIButton*)sender;
- (void)prev:(UIButton*)sender;

@end

@protocol PlaylistProtocol;

@class PlayList;
@class Clip;
@class AsyncImageView;
@class PlayerViewController;

@interface PreviewViewController : RootViewController <PlaylistProtocol, ClipThumbProtocol, ClipThumbProtocol>{
	IBOutlet UILabel*		_buffering;
    PlayerViewController*	_moviePlayer;
	PlayList*				_playlist;
	Clip*					_clip;
	PlayMode				_playMode;
	PlayCountMode			_playCountMode;
	NSInteger				_index;
	BOOL					_willNext;
}

@property(nonatomic, retain)PlayList*	playlist;
@property(nonatomic, retain)IBOutlet UIActivityIndicatorView*	sun;
@property(nonatomic, retain)IBOutlet AsyncImageView*thumbView;
@property(nonatomic, retain)IBOutlet UILabel*		artistName;
@property(nonatomic, retain)IBOutlet UILabel*		clipName;
@property(nonatomic, retain)IBOutlet UILabel*		viewCount;
@property(nonatomic, retain)Clip*					currentClip;

- (id)initWithClip:(Clip*)clip;
- (id)initWithPlaylist:(PlayList*)playlist inPlayMode:(PlayMode)mode;

@end
