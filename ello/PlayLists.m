//
//  PlayLists.m
//  ello
//
//  Created by Dmitry Sazanovich on 27/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayLists.h"

#import "PlayList.h"

@implementation PlayLists

@synthesize playlists;
@synthesize status;

- (id)init {
    self = [super init];
    if (self) {
        playlists = [NSMutableArray new];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) 
		{ 			 
			playlists = [[decoder decodeObjectForKey:@"playlists"] retain];
			status = [[decoder decodeObjectForKey:@"status"] retain];
		}
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
	[encoder encodeObject:playlists forKey:@"playlists"];
	[encoder encodeObject:status forKey:@"status"];
}

- (NSString*)description{
	return [NSString stringWithFormat:@"playlist count is %d", [playlists count]];
}

- (void)addPlaylist:(PlayList*)playlist{
	[playlists addObject:playlist];
	[NSKeyedArchiver archiveRootObject:self toFile:[[__delegate applicationDocumentsDirectory] stringByAppendingPathComponent:@"playlists.plist"]];
}
- (void)removePlaylist:(PlayList*)playlist{
	[playlists removeObject:playlist];
	[NSKeyedArchiver archiveRootObject:self toFile:[[__delegate applicationDocumentsDirectory] stringByAppendingPathComponent:@"playlists.plist"]];
}

@end
