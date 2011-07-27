//
//  VideoTableViewCell.h
//  ello
//
//  Created by Dmitry Sazanovich on 11/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "asyncimageview.h"

@class Clip; 
@class Artist;
@class PlayList;
@class VideoObject;

@interface VideoTableViewCell : UITableViewCell <AsyncImageViewProtocol> {
    UILabel*		_title;
	UILabel*		_artist;
	UILabel*		_viewCount;
	
	UIButton*		_add2playlist;
	AsyncImageView*	_videoThumb;
	VideoObject*	_videoObject;
}

@property(nonatomic, retain)id		dataObject;

- (void)configCellByPlayList:(PlayList*)object;
- (void)configCellByClip:(Clip*)object;
- (void)configCellByArtitst:(Artist*)object;
//- (void)configCell:(VideoObject*)videoObject;

@end
