//
//  VideoTableViewCell.m
//  ello
//
//  Created by Dmitry Sazanovich on 11/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "VideoTableViewCell.h"

#import "asyncimageview.h"
#import "Artist.h"
#import "Clip.h"
#import "VideoObject.h"

@implementation VideoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(155, 35, 185, 20)];
		[_title setFont:[UIFont boldSystemFontOfSize:13]];
		[_title setTextColor:[UIColor redColor]];
		[_title setBackgroundColor:[UIColor clearColor]];
		
		_artist = [[UILabel alloc] initWithFrame:CGRectMake(155, 50, 185, 20)];
		[_artist setFont:[UIFont boldSystemFontOfSize:13]];
		[_artist setTextColor:[UIColor whiteColor]];
		[_artist setBackgroundColor:[UIColor clearColor]];
		
		_viewCount = [[UILabel alloc] initWithFrame:CGRectMake(155, 68, 185, 20)];
		[_viewCount setFont:[UIFont systemFontOfSize:13]];
		[_viewCount setTextColor:[UIColor grayColor]];
		[_viewCount setBackgroundColor:[UIColor clearColor]];
		
		_videoThumb = [[AsyncImageView alloc] initWithFrame:CGRectMake(2, 2, 150, 150)];

		[self addSubview:_videoThumb];
		[self addSubview:_title];
		[self addSubview:_artist];
		[self addSubview:_viewCount];
		
		
		UIImageView* bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
		[bg setImage:[[UIImage imageNamed:@"cellBG.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]];		
		[self setBackgroundView:bg];
		[bg release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellByArtitst:(Artist*)object{
	_title.text = @"Video name";
	_artist.text = object.artistName;
	_viewCount.text = [NSString stringWithFormat:@"%D views", 7];
	[_videoThumb loadImageFromURL:object.artistImage];
}

- (void)configCellByClip:(Clip*)object{
	_title.text = object.clipName;
	_artist.text = object.artistName;
	_viewCount.text = [NSString stringWithFormat:@"%D views", object.viewCount];
	[_videoThumb loadImageFromURL:object.clipImageURL];
}

- (void)configCell:(VideoObject*)videoObject{
	_title.text = videoObject.title;
	_artist.text = videoObject.artist;
	_viewCount.text = [NSString stringWithFormat:@"%D views", videoObject.viewCount];
	self.imageView.image = videoObject.thumb;
}

- (void)dealloc
{
    [super dealloc];
}

@end
