//
//  Preoll.h
//  ello
//
//  Created by Dmitry Sazanovich on 15/09/2011.
//  Copyright (c) 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preroll : NSObject{
	NSString* preollID;
	NSString* preollName;
	NSString* preollURL;
}

@property(nonatomic, retain)NSString* preollID;
@property(nonatomic, retain)NSString* preollName;
@property(nonatomic, retain)NSString* preollURL;
@property(nonatomic, retain)NSString* viewCount;

@end
