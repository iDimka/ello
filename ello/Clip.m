//
//  Clip.m
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "Clip.h"

@implementation Clip

@synthesize type;
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
@synthesize mainArtist;
@synthesize dirrector;
@synthesize producer; 


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) 
		{ 
			 
			label = [[decoder decodeObjectForKey:@"label"] retain];
			clipID = [[decoder decodeObjectForKey:@"clipID"] retain];
			artistId = [[decoder decodeObjectForKey:@"artistId"] retain];
			artistName = [[decoder decodeObjectForKey:@"artistName"] retain];
			viewCount = [[decoder decodeObjectForKey:@"viewCount"] retain];
			clipName = [[decoder decodeObjectForKey:@"clipName"] retain];
			clipImageURL = [[decoder decodeObjectForKey:@"clipImageURL"] retain];
			clipVideoURL = [[decoder decodeObjectForKey:@"clipVideoURL"] retain];
			clipGanre = [[decoder decodeObjectForKey:@"clipGanre"] retain];
			clipGanreName = [[decoder decodeObjectForKey:@"clipGanreName"] retain];
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

- (void)setType:(NSString *)t{
	if (t != type) {
		[type release];
		type = [t retain];
		if ([type isEqualToString:@"yoututbe"]) 
			{
			NSLog(@"type youtube");
		}
	}
}

- (NSString*)description{
	return [NSString stringWithFormat:@"name is %@, url: %@ clipID: %@", clipName, clipImageURL, clipID];
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
