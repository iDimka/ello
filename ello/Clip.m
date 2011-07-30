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


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) 
		{ 
			 
			thumb = [[decoder decodeObjectForKey:@"label"] retain];
			thumb = [[decoder decodeObjectForKey:@"clipID"] retain];
			thumb = [[decoder decodeObjectForKey:@"artistId"] retain];
			thumb = [[decoder decodeObjectForKey:@"artistName"] retain];
			thumb = [[decoder decodeObjectForKey:@"viewCount"] retain];
			thumb = [[decoder decodeObjectForKey:@"clipName"] retain];
			thumb = [[decoder decodeObjectForKey:@"clipImageURL"] retain];
			thumb = [[decoder decodeObjectForKey:@"clipVideoURL"] retain];
			thumb = [[decoder decodeObjectForKey:@"clipGanre"] retain];
			thumb = [[decoder decodeObjectForKey:@"clipGanreName"] retain];
		}
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
	
	[encoder encodeObject:label forKey:@"label"];
	[encoder encodeObject:clipID forKey:@"clipID"];
	[encoder encodeObject:artistId forKey:@"artistId"];
	[encoder encodeObject:artistName forKey:@"artistName"];
	[encoder encodeObject:viewCount forKey:@"viewCount"];
	[encoder encodeObject:clipName forKey:@"clipName"];
	[encoder encodeObject:clipImageURL forKey:@"clipImageURL"];
	[encoder encodeObject:clipVideoURL forKey:@"clipVideoURL"];
	[encoder encodeObject:clipGanre forKey:@"clipGanre"];
	[encoder encodeObject:clipGanreName forKey:@"clipGanreName"]; 
}


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
