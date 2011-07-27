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

@end
