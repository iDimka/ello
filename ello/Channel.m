//
//  Channel.m
//  ello
//
//  Created by Dmitry Sazanovich on 07/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "Channel.h"

@implementation Channel

@synthesize thumb;
@synthesize channelID;
@synthesize channelName;
@synthesize channelImage;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
