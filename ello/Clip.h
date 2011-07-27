//
//  Clip.h
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Clip : NSObject {
  
	NSNumber*		clipID;
	NSNumber*		artistId;
	NSString*		artistName;
	NSNumber*		viewCount;
	NSNumber*		clipGanre;
	NSString*		clipName;
	NSString*		clipGanreName;
	NSString*		clipImageURL;
	NSString*		clipVideoURL;	
	NSString*		label;
	
	
	
}

@property(nonatomic, retain)UIImage*	thumb;
@property(nonatomic, retain)NSString*	label;
@property(nonatomic, retain)NSNumber*	clipID;
@property(nonatomic, retain)NSNumber*	artistId;
@property(nonatomic, retain)NSString*	artistName;
@property(nonatomic, retain)NSNumber*	viewCount;
@property(nonatomic, retain)NSNumber*	clipGanre;
@property(nonatomic, retain)NSString*	clipName;
@property(nonatomic, retain)NSString*	clipGanreName;
@property(nonatomic, retain)NSString*	clipImageURL;
@property(nonatomic, retain)NSString*	clipVideoURL;

@end
