//
//  elloAppDelegate.h
//  ello
//
//  Created by Dmitry Sazanovich on 07/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "SHK.h"

@class PlayLists;
@class RKReachabilityObserver;

@interface elloAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate> {
	PlayLists* _playlists;
	IBOutlet UIImageView* bg;
	
}

@property (nonatomic, retain) PlayLists* playlists;
@property (nonatomic, retain) RKReachabilityObserver* reachability;
@property (nonatomic, retain) IBOutlet UIWindow *window; 
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (NSString *)applicationDocumentsDirectory;
- (void)show;
- (void)initRestKit;

@end
