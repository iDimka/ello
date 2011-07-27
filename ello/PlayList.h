//
//  PlayList.h
//  ello
//
//  Created by Dmitry Sazanovich on 23/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayList : NSObject

@property(nonatomic, retain)UIImage*		thumb;
@property(nonatomic, retain)NSNumber*		playListID;
@property(nonatomic, retain)NSNumber*		artistID;
@property(nonatomic, retain)NSString*		artistName;
@property(nonatomic, retain)NSString*		imageURLString;
@property(nonatomic, retain)NSNumber*		genreID;
@property(nonatomic, retain)NSString*		genreName;
@property(nonatomic, retain)NSNumber*		viewCount;
@property(nonatomic, retain)NSString*		name;
@property(nonatomic, retain)NSString*		videoURLString;
@property(nonatomic, retain)NSString*		label;

@end
