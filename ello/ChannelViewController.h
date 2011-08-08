//
//  ChannelViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 07/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClipsViewController.h"

@class Channel;

@interface ChannelViewController : ClipsViewController{
	Channel*		_channel;
}

- (id)initWitChannel:(Channel*)channel;

@end
