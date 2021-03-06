//
//  elloAppDelegate.m
//  ello
//
//  Created by Dmitry Sazanovich on 07/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "elloAppDelegate.h"

#import "Preroll.h"
#import "Prerolls.h"
#import "AdView.h"
#import "AdViews.h"
#import "PlayerViewController.h"
#import "PreviewViewController.h"
#import "PlayListViewController.h"
#import "ClipsViewController.h"
#import "Channels.h"
#import "Channel.h"
#import "Genre.h"
#import "Genres.h"
#import "PlayList.h"
#import "PlayLists.h"
#import "Artist.h"
#import "Artists.h"
#import "Clip.h"
#import "Clips.h"

@implementation elloAppDelegate

@synthesize playlists = _playlists;
@synthesize reachability;
@synthesize window=_window; 
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
 
	[self initRestKit];
	[[NSBundle mainBundle] loadNibNamed:@"TabbarViewController" owner:self options:nil];

	[self.tabBarController setDelegate:self];
 
	[self.tabBarController.moreNavigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	[self.tabBarController.moreNavigationController setDelegate:self];
	[[self.tabBarController.moreNavigationController.viewControllers objectAtIndex:0] setTitle:@"Ещё"];
	[[[self.tabBarController.moreNavigationController tabBarController] tabBarItem] setTitle:@"Ещё"];
	
	_playlists = [[NSKeyedUnarchiver unarchiveObjectWithFile:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"playlists.plist"]] retain];
	if (!_playlists) {
		_playlists = [[PlayLists alloc] init];
	}
  
    return YES;
}

- (void)initRestKit {
	RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://50.17.200.31"];
	
	[RKRequestQueue sharedQueue].delegate = (NSObject<RKRequestQueueDelegate>*)self;
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
	 @"clip.type",		@"type",
	 @"clip.producer",	@"producer",
     nil];
	
	RKObjectMapping*  clipsMapping = [RKObjectMapping mappingForClass:[Clips class]];
	[clipsMapping mapKeyPathsToAttributes: @"status", @"status",  nil];
	[clipsMapping mapRelationship:@"clips" withObjectMapping:mapping]; 
	[objectManager.mappingProvider setObjectMapping:clipsMapping forKeyPath:@"clips"];
	
	mapping = [RKObjectMapping mappingForClass:[AdView class]];
    [mapping mapKeyPathsToAttributes:
     @"banner.id",			@"bannerID", 
	 @"banner.image",		@"bannerImage",
	 @"banner.url",			@"url",
	 @"banner.name",		@"name",
	 @"banner.view_count",	@"viewCount",
	 @"banner.action",		@"action",
     nil];
	
	clipsMapping = [RKObjectMapping mappingForClass:[AdViews class]]; 
	[clipsMapping mapRelationship:@"banners" withObjectMapping:mapping]; 
	[objectManager.mappingProvider setObjectMapping:clipsMapping forKeyPath:@"banners"];
	
	mapping = [RKObjectMapping mappingForClass:[Preroll class]];
    [mapping mapKeyPathsToAttributes:
     @"preroll.id",			@"preollID", 
	 @"preroll.name",		@"preollName",
	 @"preroll.url",		@"preollURL",
	 @"preroll.view_count",	@"viewCount",
     nil];
	
	clipsMapping = [RKObjectMapping mappingForClass:[Prerolls class]]; 
	[clipsMapping mapRelationship:@"prerolls" withObjectMapping:mapping]; 
	[objectManager.mappingProvider setObjectMapping:clipsMapping forKeyPath:@"prerolls"];
	
	
	mapping = [RKObjectMapping mappingForClass:[Artist class]];
	[mapping mapKeyPathsToAttributes:
	 @"artist.id",		@"artistID",
	 @"artist.image",	@"artistImage",
	 @"artist.name",	@"artistName",  
	 @"artist.details",	@"details",
	 nil];
	
	RKObjectMapping*  artistMapping = [RKObjectMapping mappingForClass:[Artists class]];
	[artistMapping mapKeyPathsToAttributes:@"status", @"status", nil];  
	[artistMapping mapRelationship:@"artists" withObjectMapping:mapping]; 
	[objectManager.mappingProvider setObjectMapping:artistMapping forKeyPath:@"artists"];
	
	mapping = [RKObjectMapping mappingForClass:[PlayList class]];
    [mapping mapKeyPathsToAttributes:
     @"playlist.id",		@"playListID",
	 @"playlist.artistId",	@"artistID",
	 @"playlist.artistName",@"artistName",
  	 @"playlist.genreId",	@"genreID",
  	 @"playlist.genreName",	@"genreName",
  	 @"playlist.clipsCount",@"clipsCount",
	 @"playlist.playlistName",		@"playlistName",
	 @"playlist.image",		@"imageURLString",
 	 @"playlist.video",		@"videoURLString",
  	 @"playlist.label",		@"label", 
     nil];
	
	RKObjectMapping* playlistsMapping = [RKObjectMapping mappingForClass:[PlayLists class]];
	[playlistsMapping mapKeyPathsToAttributes: @"status", @"status", nil];
	[playlistsMapping mapRelationship:@"playlists" withObjectMapping:mapping];
	[objectManager.mappingProvider setObjectMapping:playlistsMapping forKeyPath:@"playlists"];
	
	mapping = [RKObjectMapping mappingForClass:[Genre class]];
    [mapping mapKeyPathsToAttributes:
	 @"genre.id",		@"genreID",
	 @"genre.name",		@"genreName",
     nil];
	
	RKObjectMapping* ganresMapping = [RKObjectMapping mappingForClass:[Genres class]];
	[ganresMapping mapKeyPathsToAttributes: @"status", @"status", nil];
	[ganresMapping mapRelationship:@"genres" withObjectMapping:mapping];
	[objectManager.mappingProvider setObjectMapping:ganresMapping forKeyPath:@"genres"];
	
	mapping = [RKObjectMapping mappingForClass:[Channel class]];
    [mapping mapKeyPathsToAttributes:
	 @"channel.id",		@"channelID",
	 @"channel.image",	@"channelImage",
	 @"channel.name",	@"channelName",  
     nil];
	
 	RKObjectMapping* channels = [RKObjectMapping mappingForClass:[Channels class]];
	[channels mapKeyPathsToAttributes: @"status", @"status", nil];
	[channels mapRelationship:@"channels" withObjectMapping:mapping];
	[objectManager.mappingProvider setObjectMapping:channels forKeyPath:@"channels"];
	
}
- (void)show{
	self.window.rootViewController = self.tabBarController;
	[self.window makeKeyAndVisible];	
	[bg setHidden:YES];
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	if ([viewController isKindOfClass:[PreviewViewController class]]) 
		{
		[navigationController setNavigationBarHidden:YES]; 
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
		}
	if (![viewController isKindOfClass:[PreviewViewController class]] && ![viewController isKindOfClass:[PreviewViewController class]])
		{
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
		[navigationController setNavigationBarHidden:NO];
		}
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
	
	if ([viewController isKindOfClass:[UINavigationController class]] && 
		 [[[(UINavigationController*)viewController viewControllers] objectAtIndex:0] isKindOfClass:[ClipsViewController class]])
		{
		[(ClipsViewController*)[[(UINavigationController*)viewController viewControllers] objectAtIndex:0] setClipToPlaylist:nil];
		}else if ([viewController isKindOfClass:[UINavigationController class]] && 
				  [[[(UINavigationController*)viewController viewControllers] objectAtIndex:0] isKindOfClass:[PlayListViewController class]])
			{
			[(PlayListViewController*)[[(UINavigationController*)viewController viewControllers] objectAtIndex:0] setRepeatPlaylist:nil];
			}
	return YES;
}

- (void)dealloc{
	
	[_playlists release];
	[_window release];
	[_tabBarController release];
    [super dealloc];
}

 

@end
