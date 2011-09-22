//
//  VideoTableViewCell.m
//  ello
//
//  Created by Dmitry Sazanovich on 11/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "VideoTableViewCell.h"

#import "Channel.h"
#import "PlayList.h"
#import "asyncimageview.h"
#import "Artist.h"
#import "Clip.h"
#import "VideoObject.h"

@implementation VideoTableViewCell

@synthesize clipDelegate;
@synthesize clipNumber;
@synthesize dataObject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(155, 3, 130, 30)];
		[_title setFont:[UIFont boldSystemFontOfSize:13]];
		[_title setNumberOfLines:0];
		[_title setTextColor:[UIColor redColor]];
		[_title setBackgroundColor:[UIColor clearColor]];
		
		_artist = [[UILabel alloc] initWithFrame:CGRectMake(155, 33, 185, 20)];
		[_artist setFont:[UIFont boldSystemFontOfSize:13]];
		[_artist setTextColor:[UIColor whiteColor]];
		[_artist setBackgroundColor:[UIColor clearColor]];
		
		_viewCount = [[UILabel alloc] initWithFrame:CGRectMake(155, 50, 185, 20)];
		[_viewCount setFont:[UIFont systemFontOfSize:13]];
		[_viewCount setTextColor:[UIColor grayColor]];
		[_viewCount setBackgroundColor:[UIColor clearColor]];
		
		_videoThumb = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 112, 69)];
		_videoThumb.delegate = self;
		
		_clipNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 51, 20, 20)];
		[_clipNumberLabel setFont:[UIFont boldSystemFontOfSize:13]];
		[_clipNumberLabel setTextColor:[UIColor whiteColor]];
		[_clipNumberLabel setTextAlignment:UITextAlignmentCenter];
		[_clipNumberLabel setBackgroundColor:[UIColor redColor]];
		[_clipNumberLabel setHidden:YES];
		
		UIButton* addToPlaylistButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[addToPlaylistButton setTag:777];
		[addToPlaylistButton setHidden:YES];
		[addToPlaylistButton setFrame:CGRectMake(285, TBL_V_H / 2 - 32 / 2, 27, 32)];
		[addToPlaylistButton setImage:[UIImage imageNamed:@"cellBtnAdd.png"] forState:UIControlStateNormal];
		[addToPlaylistButton addTarget:self action:@selector(addToPlaylist) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:_videoThumb];
		[self addSubview:_title];
		[self addSubview:_artist];
		[self addSubview:_viewCount];
		[self addSubview:_clipNumberLabel];
		[self addSubview:addToPlaylistButton];
		
		UIImageView* bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
		[bg setImage:[[UIImage imageNamed:@"cellBg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]];		
		[self setBackgroundView:bg];
		[bg release]; 
    }
    return self;
}

- (void)setClipNumber:(NSInteger)clipNumberInt{
	if (clipNumberInt != -1) 
		{
		_clipNumberLabel.hidden = NO;
		_clipNumberLabel.text = [NSString stringWithFormat:@"%d", clipNumberInt + 1];
	}else _clipNumberLabel.hidden = YES;
}

- (void)imageDidLoad:(UIImage*)image{
	[dataObject setThumb:image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellByArtitst:(Artist*)object{
	self.dataObject = object; 
	_artist.text = object.artistName;
	if (object.thumb)  _videoThumb.image = object.thumb;
	else {
		_videoThumb.image = nil;
		[_videoThumb loadImageFromURL:[NSURL URLWithString:object.artistImage]];
//		NSLog(object.artistImage);
	}
}
- (void)configCellByChannel:(Channel*)object{
	self.dataObject = object;
	//	_title.text = object.clipName;
	_artist.text = object.channelName;
	if (object.thumb)  _videoThumb.image = object.thumb;
	else [_videoThumb loadImageFromURL:[NSURL URLWithString:object.channelImage]];
}

- (void)configCellByClip:(Clip*)object{
	[_clip release];
	_clip = [object retain];
	self.dataObject = object;
	
	if (clipDelegate) [[self viewWithTag:777] setHidden:NO];
	
	_title.text = object.clipName;
	_artist.text = object.artistName;
	_viewCount.text = [NSString stringWithFormat:@"%D views", [object.viewCount intValue]];
	[_videoThumb setImage:nil];
	if (object.thumb && ![object.thumb isKindOfClass:[NSNull class]])  _videoThumb.image = object.thumb;
	else [_videoThumb loadImageFromURL:[NSURL URLWithString:object.clipImageURL]];
}
- (void)configCellByPlayList:(PlayList*)object{
	self.dataObject = object;
	_title.text = object.playlistName; 
	_viewCount.text = [NSString stringWithFormat:@"%D clips", [object.clipsCount intValue]];
	[_videoThumb setImage:nil];
	if (object.thumb)  _videoThumb.image = object.thumb;
	else {
	if (object.imageURLString)[_videoThumb loadImageFromURL:[NSURL URLWithString:object.imageURLString]];	
	else if ([object.clips count]) [_videoThumb loadImageFromURL:[NSURL URLWithString:[(Clip*)[object.clips objectAtIndex:0] clipImageURL]]];	 
	 
	}
}
- (void)configCell:(VideoObject*)videoObject{
	_title.text = videoObject.title;
	_artist.text = videoObject.artist;
	_viewCount.text = [NSString stringWithFormat:@"%D views", videoObject.viewCount];
	self.imageView.image = videoObject.thumb;
}

- (void)addToPlaylist{
	if ([clipDelegate respondsToSelector:@selector(addToPlaylist:)]) {
		[clipDelegate addToPlaylist:_clip];
	}
}

- (void)dealloc{
	 
	self.dataObject = nil;
	
    [super dealloc];
}

@end
