//
//  Channels.m
//  ello
//
//  Created by Dmitry Sazanovich on 07/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "Channels.h"

@implementation Channels

@synthesize status;
@synthesize channels = _channels;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)dealloc {
	
    [_channels release];
	
    [super dealloc];
}

+ (NSDictionary*)elementToPropertyMappings{
	NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys: @"status", @"status",  nil];
	return attributes;
								
}
+ (NSDictionary*) elementToRelationshipMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"channels", @"channels", nil];
}

@end
