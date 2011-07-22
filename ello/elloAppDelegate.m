//
//  elloAppDelegate.m
//  ello
//
//  Created by Dmitry Sazanovich on 07/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "elloAppDelegate.h"

@implementation elloAppDelegate


@synthesize window=_window;
@synthesize artistParser = _artistParser;
@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

	_artistParser = [[ArtistParser alloc] init];
	[_artistParser loadURL:[NSURL URLWithString:@"http://themedibook.com/ello/services/service.php?service=artist&action=getAllArtists"]];
	[_artistParser setDelegate:self];
	 

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}
- (void)applicationWillEnterForeground:(UIApplication *)application{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc{
	[_window release];
	[_tabBarController release];
    [super dealloc];
}


- (void)parser:(ArtistParser*)parser xmlDidParsed:(NSArray*)content{
	
	self.window.rootViewController = self.tabBarController;
	[self.window makeKeyAndVisible];
}
- (void)parser:(ArtistParser*)parser xmlDidError:(NSError*)error{
		
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[[error userInfo] valueForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
