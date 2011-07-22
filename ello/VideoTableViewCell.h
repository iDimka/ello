//
//  VideoTableViewCell.h
//  ello
//
//  Created by Dmitry Sazanovich on 11/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Clip;
@class AsyncImageView;
@class VideoObject;

@interface VideoTableViewCell : UITableViewCell {
    UILabel*		_title;
	UILabel*		_artist;
	UILabel*		_viewCount;
	
	UIButton*		_add2playlist;
	AsyncImageView*	_videoThumb;
	VideoObject*	_videoObject;
}

- (void)configCellByClip:(Clip*)object;
- (void)configCellByArtitst:(Artist*)object;
- (void)configCell:(VideoObject*)videoObject;

@end
