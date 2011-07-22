//
//  VideoObject.h
//  ello
//
//  Created by Dmitry Sazanovich on 11/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoObject : NSObject {
    NSString*		_title;
	NSString*		_artist;
	NSInteger		_viewCount;
	NSURL*			_videoURL;
	UIImage*		_thumb;
}

@property(nonatomic, copy)NSString*		title;
@property(nonatomic, copy)NSString*		artist;
@property(nonatomic, assign)NSInteger	viewCount;
@property(nonatomic, retain)NSURL*		videoURL;
@property(nonatomic, retain)UIImage*	thumb;

@end
