//
//  elloAppDelegate.m
//  ello
//
//  Created by Dmitry Sazanovich on 07/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "elloAppDelegate.h"
 
#import "Artist.h"
#import "Artists.h"
#import "Clip.h"
#import "Clips.h"

@implementation elloAppDelegate

@synthesize reachability;
@synthesize window=_window; 
@synthesize tabBarController=_tabBarController;

- (void)initRestKit {
	RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://themedibook.com/ello/services"];
	 
	[RKRequestQueue sharedQueue].delegate = self;
	[RKRequestQueue sharedQueue].showsNetworkActivityIndicatorWhenBusy = YES;
	 
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Clip class]];
    [mapping mapKeyPathsToAttributes:
     @"clip.id",		@"clipID",
	 @"clip.artistId",	@"artistId",
	 @"clip.artistName",@"artistName",
  	 @"clip.genreId",	@"clipGanre",
  	 @"clip.genreName",	@"clipGanreName",
  	 @"clip.viewCount",	@"viewCount",
	 @"clip.name",		@"clipName",
	 @"clip.image",		@"clipImageURL",
 	 @"clip.video",		@"clipVideoURL",
  	 @"clip.label",		@"label", 
     nil];
	
	RKObjectMapping*  clipsMapping = [RKObjectMapping mappingForClass:[Clips class]];
	[clipsMapping mapKeyPathsToAttributes: @"status", @"status",  nil];
	[clipsMapping mapRelationship:@"clips" withObjectMapping:mapping]; 
	[objectManager.mappingProvider setObjectMapping:clipsMapping forKeyPath:@"clips"];
	
	mapping = [RKObjectMapping mappingForClass:[Clip class]];
	
	mapping = [RKObjectMapping mappingForClass:[Artist class]];
	[mapping mapKeyPathsToAttributes:
	 @"artist.id",		@"artistID",
	 @"artist.image",	@"artistImage",
	 @"artist.name",	@"artistName",  
	 nil];
	
	RKObjectMapping*  artistMapping = [[RKObjectMapping mappingForClass:[Artists class]] retain];
	[artistMapping mapKeyPathsToAttributes:@"status", @"status", nil];  
	[artistMapping mapRelationship:@"artists" withObjectMapping:mapping]; 
	[objectManager.mappingProvider setObjectMapping:artistMapping forKeyPath:@"artists"];

}
- (void)applicationDidFinishLaunching:(UIApplication *)application{
	
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

	[self initRestKit];
  
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

- (void)show{
	self.window.rootViewController = self.tabBarController;
	[self.window makeKeyAndVisible];	
}


- (void)requestQueueWasUnsuspended:(RKRequestQueue*)queue;{
	
}
- (void)requestQueueWasSuspended:(RKRequestQueue*)queue;{
	
}
- (void)requestQueue:(RKRequestQueue*)queue didFailRequest:(RKRequest*)request withError:(NSError*)error{
	
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

 

@end
