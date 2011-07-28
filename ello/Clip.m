//
//  Clip.m
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "Clip.h"

@implementation Clip

@synthesize thumb;
@synthesize label;
@synthesize clipID;
@synthesize artistId;
@synthesize artistName;
@synthesize viewCount;
@synthesize clipName;
@synthesize clipImageURL;
@synthesize clipVideoURL; 
@synthesize clipGanre;
@synthesize clipGanreName;


- (NSString*)description{
	return clipName;
}

- (void)setClipImageURL:(NSString *)clipImageURL_{
	clipImageURL = [clipImageURL_ retain];
	AsyncImageView* tmp = [[[AsyncImageView alloc] init] autorelease];
	[tmp performSelectorOnMainThread:@selector(loadImageFromURL:) withObject:[NSURL URLWithString:clipImageURL_] waitUntilDone:YES];
	[tmp setDelegate:self];
}

- (void)imageDidLoad:(UIImage*)image{
	self.thumb = image;
}

@end
