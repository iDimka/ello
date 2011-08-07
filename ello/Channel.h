//
//  Channel.h
//  ello
//
//  Created by Dmitry Sazanovich on 07/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property(nonatomic, retain)UIImage*		thumb;
@property(nonatomic, retain)NSNumber*		channelID;
@property(nonatomic, retain)NSString*		channelName;
@property(nonatomic, retain)NSString*		channelImage;

@end
