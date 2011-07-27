//
//  Clips.m
//  ello
//
//  Created by Dmitry Sazanovich on 26/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "Clips.h"

@implementation Clips

@synthesize status;
@synthesize clips;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (NSString*)description{
	return [self.clips description];
}


@end
