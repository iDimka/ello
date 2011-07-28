//
//  elloAppDelegate.h
//  ello
//
//  Created by Dmitry Sazanovich on 07/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h> 
  
@class RKReachabilityObserver;

@interface elloAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
 
	
}

@property (nonatomic, retain) RKReachabilityObserver* reachability;
@property (nonatomic, retain) IBOutlet UIWindow *window; 
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (void)show;

@end
