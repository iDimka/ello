//
//  VideoTableViewCell.h
//  ello
//
//  Created by Dmitry Sazanovich on 11/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "asyncimageview.h"

@class Channel;
@class VideoTableViewCell;
@class Clip; 
@class Artist;
@class PlayList;
@class VideoObject;

@protocol PlayListProtocol <NSObject>

- (void)addToPlaylist:(Clip*)cell;

@end

@interface VideoTableViewCell : UITableViewCell <AsyncImageViewProtocol> {
    UILabel*		_title;
	UILabel*		_artist;
	UILabel*		_viewCount;
	UILabel*		_clipNumberLabel;
	
	UIButton*		_add2playlist;
	AsyncImageView*	_videoThumb;
	VideoObject*	_videoObject;
	Clip*			_clip;
	
}

@property(nonatomic, assign)id<PlayListProtocol>	clipDelegate;
@property(nonatomic, assign)NSInteger				clipNumber;
@property(nonatomic, retain)id						dataObject;

- (void)configCellByChannel:(Channel*)object;
- (void)configCellByPlayList:(PlayList*)object;
- (void)configCellByClip:(Clip*)object;
- (void)configCellByArtitst:(Artist*)object;
//- (void)configCell:(VideoObject*)videoObject;

@end
