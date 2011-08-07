//
//  Artist.m
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "Artist.h"


@implementation Artist
 
@synthesize thumb;
@synthesize artistID;
@synthesize artistName;
@synthesize artistImage;

-(NSString*)description{
 
	NSString* tmp = [NSString stringWithFormat:@"id=%@;name=%@;imageURL=%@", self.artistID, self.artistName, self.artistImage];
	return tmp;
}

@end
