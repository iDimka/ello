//
//  Clips.m
//  ello
//
//  Created by Dmitry Sazanovich on 26/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "Clips.h"

#import "Clip.h"

@implementation Clips

@synthesize status;
@synthesize clips;


- (id)init {
    self = [super init];
    if (self) {
        clips = [NSMutableArray new];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) 
		{ 
			
			clips = [[decoder decodeObjectForKey:@"clips"] retain];
		}
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
	[encoder encodeObject:clips forKey:@"clips"];
}


- (void)addClip:(Clip*)clip{
	[clips addObject:clip];
}
- (void)removeClip:(Clip*)clip{
	[clips removeObject:clip];
}

- (NSString*)description{
	return [self.clips description];
}


@end
