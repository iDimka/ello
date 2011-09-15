//
//  Artist.h
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Artist : NSObject {
    NSString*		details;
	UIImage*		thumb;
	NSNumber*		artistID;
	NSString*		artistName;
	NSString*		artistImage;
}

@property(nonatomic, retain)NSString*		details;
@property(nonatomic, retain)UIImage*		thumb;
@property(nonatomic, retain)NSNumber*		artistID;
@property(nonatomic, retain)NSString*		artistName;
@property(nonatomic, retain)NSString*		artistImage;

@end
