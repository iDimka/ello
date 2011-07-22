//
//  VideoObject.m
//  ello
//
//  Created by Dmitry Sazanovich on 11/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "VideoObject.h"


@implementation VideoObject

@synthesize title = _title;
@synthesize artist = _artist;
@synthesize viewCount = _viewCount;
@synthesize videoURL = _videoURL;
@synthesize thumb = _thumb;

- (void)dealloc {
    
	[_videoURL release];
	[_thumb release];
	
    [super dealloc];
}


@end
