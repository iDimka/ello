//
//  Channels.h
//  ello
//
//  Created by Dmitry Sazanovich on 07/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface Channels : NSObject{
	NSMutableArray*		_channels;
}

@property(nonatomic, retain)NSString*		status;
@property(nonatomic, retain)NSMutableArray*	channels;

@end
