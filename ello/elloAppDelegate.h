//
//  elloAppDelegate.h
//  ello
//
//  Created by Dmitry Sazanovich on 07/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistParser.h"


@interface elloAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

	ArtistParser*		_artistParser;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, readonly)ArtistParser*	artistParser;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
