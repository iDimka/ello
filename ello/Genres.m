//
//  Ganri.m
//  ello
//
//  Created by Dmitry Sazanovich on 28/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "Genres.h"


@implementation Genres

@synthesize genres = _genres;
@synthesize status;

- (NSString*)description{
	return [NSString stringWithFormat:@"count %D", [_genres count]];
}

@end
