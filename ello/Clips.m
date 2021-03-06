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

@synthesize playMode;
@synthesize loadAllImages;
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

- (void)loadAllImages:(LoadImages)block{
	self.loadAllImages = block;
	
	for (Clip* clip in clips) {
		NSLog(@"%@:%@", clip.clipName, clip.clipVideoURL);
		NSURLResponse* response = nil;
		NSError* error = nil;
		NSData* payload = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[clip clipImageURL]]] returningResponse:&response error:&error];
		clip.thumb = [UIImage imageWithData:payload]; 
		[payload writeToFile:[[__delegate applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", clip.clipName]] atomically:YES];
		if (error) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//			[alert show];
			[alert release];
			self.loadAllImages(NO);
		}
	}
	self.loadAllImages(YES);
}

@end
