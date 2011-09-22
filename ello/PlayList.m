//
//  PlayList.m
//  ello
//
//  Created by Dmitry Sazanovich on 23/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayList.h"

@implementation PlayList

@synthesize playMode;
@synthesize thumb;
@synthesize playListID;
@synthesize clipsCount;
@synthesize playlistName;
@synthesize image;
@synthesize artistID;
@synthesize clips; 
@synthesize artistName;
@synthesize imageURLString;
@synthesize genreID;
@synthesize genreName; 
@synthesize name;
@synthesize videoURLString;
@synthesize label;


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
			clips = [NSMutableArray new];
			
			playlistName = [[decoder decodeObjectForKey:@"playlistName"] retain];
			playListID = [[decoder decodeObjectForKey:@"playListID"] retain];
			artistID = [[decoder decodeObjectForKey:@"artistID"] retain];
			artistName = [[decoder decodeObjectForKey:@"artistName"] retain];
			imageURLString = [[decoder decodeObjectForKey:@"imageURLString"] retain];
			genreID = [[decoder decodeObjectForKey:@"genreID"] retain];
			genreName = [[decoder decodeObjectForKey:@"genreName"] retain];
			clipsCount = [[decoder decodeObjectForKey:@"clipsCount"] retain];
			name = [[decoder decodeObjectForKey:@"name"] retain];
			videoURLString = [[decoder decodeObjectForKey:@"videoURLString"] retain];
			label = [[decoder decodeObjectForKey:@"label"] retain];
			clips = [[decoder decodeObjectForKey:@"clips"] retain];
//			NSKeyedUnarchiver* ua = [[NSKeyedUnarchiver alloc] initForReadingWithData:[NSData dataWithContentsOfFile:[[__delegate applicationDocumentsDirectory] stringByAppendingPathComponent:@"clips.plist"]]];
//			clips = [[NSKeyedUnarchiver unarchiveObjectWithFile:[[__delegate applicationDocumentsDirectory] stringByAppendingPathComponent:@"clips.txt"]] retain];
//			clips = [ua decodeObject];
		}
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
	
	[encoder encodeObject:playlistName forKey:@"playlistName"];
	[encoder encodeObject:playListID forKey:@"playListID"];
	[encoder encodeObject:artistID forKey:@"artistID"];
	[encoder encodeObject:artistName forKey:@"artistName"];
	[encoder encodeObject:imageURLString forKey:@"imageURLString"];
	[encoder encodeObject:genreID forKey:@"genreID"];
	[encoder encodeObject:genreName forKey:@"genreName"];
	[encoder encodeObject:clipsCount forKey:@"clipsCount"];
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:videoURLString forKey:@"videoURLString"];
	[encoder encodeObject:label forKey:@"label"];
//	NSKeyedArchiver* ua = [[NSKeyedArchiver alloc] initForWritingWithMutableData:[NSData dataWithContentsOfFile:[[__delegate applicationDocumentsDirectory] stringByAppendingPathComponent:@"clips.plist"]]];
//	[NSKeyedArchiver archiveRootObject:self toFile:[[__delegate applicationDocumentsDirectory] stringByAppendingPathComponent:@"clips.txt"]];
//	[ua encodeObject:clips];

	[encoder encodeObject:clips forKey:@"clips"]; 
}

- (NSNumber*)clipsCount{
	return [NSNumber numberWithInt:[clips count]];
}

- (NSString*)description{
	return [NSString stringWithFormat:@"clips count is %d\n\n\n%@", [clips count], clips];
}


@end
