//
//  ClipThumb.m
//  ello
//
//  Created by Dmitry Sazanovich on 07/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ClipThumb.h"

#import "Clip.h"
#import "asyncimageView.h"

@implementation ClipThumb

@synthesize delegate = _delegate;
@synthesize clip;

- (id)initWithFrame:(CGRect)frame clip:(Clip*)cl
{
    self = [super initWithFrame:frame];
    if (self) {
		self.clip = cl;
		
		_thumb = [[AsyncImageView alloc] initWithFrame:CGRectMake(17, 7, 125, 70)];		
		if (clip.thumb)  _thumb.image = clip.thumb;
		else [_thumb loadImageFromURL:[NSURL URLWithString:clip.clipImageURL]];
		[self addSubview:_thumb];
		
		_artistName = [[UILabel alloc] initWithFrame:CGRectMake(17, 75, frame.size.width - 20, 20)];
		[_artistName setBackgroundColor:[UIColor clearColor]];
		[_artistName setFont:[UIFont boldSystemFontOfSize:14]];
		[_artistName setText:clip.artistName];
		[self addSubview:_artistName];
		
		_songName = [[UILabel alloc] initWithFrame:CGRectMake(17, 90, frame.size.width - 20, 20)];
		[_songName setBackgroundColor:[UIColor clearColor]];
		[_songName setFont:[UIFont systemFontOfSize:13]];
		[_songName setText:clip.clipName];
		[self addSubview:_songName];
    }
    return self;
}
- (void)dealloc {
    
	[_thumb release];
	[_artistName release];
	[_songName release];
	
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	NSLog(@"thumb touch %@", clip);
	[_delegate selectClip:clip];
}

@end
