//
//  ViewViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 08/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ClipsViewController.h"

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

#import "MKEntryPanel.h"
#import "PlayList.h"
#import "PlayLists.h"
#import "Clips.h"
#import "Clip.h" 
#import "Artist.h"
#import "SearchViewController.h"
#import "PreviewViewController.h"
#import "VideoObject.h"
#import "VideoTableViewCell.h"

@interface ClipsViewController()

@property(nonatomic, retain)Clip*				clipToPlaylist;
@property(nonatomic, retain)NSMutableArray*		dataSource;

@end

@implementation ClipsViewController

@synthesize clipToPlaylist;
@synthesize dataSource = _dataSource;
 
#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];

	self.title = @"Клипы";
	
	
	_dataSource = [[NSMutableArray alloc] init];
	[_dataSource addObject:[NSNull null]];
	[_dataSource addObject:[NSNull null]];
	[_dataSource addObject:[NSNull null]];
	
	[self showDimView];
  
	_segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"Премеры", @"Популярные", @"Новинки", nil]];
	[_segment setSegmentedControlStyle:UISegmentedControlStyleBar];
	[_segment addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = _segment; 
	[_segment setSelectedSegmentIndex:0];
	
} 
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
	
	[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}
 
- (void)segmentTapped:(UISegmentedControl*)segmentedControl{
	[_tableView reloadData];
 

	NSLog(@"segm index %d", segmentedControl.selectedSegmentIndex);
	[self showDimView];
	switch (segmentedControl.selectedSegmentIndex) {
			case 0:			
			 [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=clip&action=getPremierClips" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self];
			break;
		case 1:			
			 [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=clip&action=getLatestClips" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self]; 
			break;
		case 2:
			 [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=clip&action=getPopularClips" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self];
			break;		
	}
}

#pragma mark - Table view data source
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([[_dataSource objectAtIndex:_segment.selectedSegmentIndex] isKindOfClass:[NSNull class]] ) {
	
		return 0;
	}
    return [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] clips] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    Clip* clip = [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] clips] objectAtIndex:indexPath.row]; 
	
	[cell setClipDelegate:self];
	[cell configCellByClip:clip];
	[cell setClipNumber:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    Clip* clip = [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] clips] objectAtIndex:indexPath.row]; 
	PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithClip:clip];
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}
 
- (void)search:(id)sender{
	SearchViewController *detailViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil mode:kClip]; 
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}
- (void)addToPlaylist:(Clip*)clip{
	
	self.clipToPlaylist = clip;
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Добавить это видео в..." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Новый плейлист", nil];
	for (PlayList* pl in [[__delegate playlists] playlists]) {
		[actionSheet addButtonWithTitle:pl.name];
	}
	[actionSheet addButtonWithTitle:@"Отмена"];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
	
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSLog(@"button index is %d", buttonIndex);
	if (buttonIndex == [actionSheet numberOfButtons] - 1) return;
	if (buttonIndex == 0) {
		
		PlayList* playList = [PlayList new];
		[MKEntryPanel showPanelWithTitle:NSLocalizedString(@"Название листа", @"") 
								  inView:self.view 
						   onTextEntered:^(NSString* enteredString)
		 {
		
		 playList.name = enteredString;
		 [[__delegate playlists] addPlaylist:playList];

		 }];
		[[playList clips] addObject:clipToPlaylist];
		[playList release];
		self.clipToPlaylist = nil;
	}else{
		PlayList* myPlaylist = [[[__delegate playlists] playlists] objectAtIndex:buttonIndex - 1];
		[[myPlaylist clips] addObject:clipToPlaylist];
		self.clipToPlaylist = nil;
		[[__delegate playlists] save];
	}
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	if ([[_dataSource objectAtIndex:_segment.selectedSegmentIndex] isKindOfClass:[NSNull class]] ) {
		[_dataSource insertObject:[objects objectAtIndex:0] atIndex:_segment.selectedSegmentIndex];
	}
	[self hideDimView];
	[_tableView reloadData];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}

- (void)dealloc{
	
	
	[_segment release];
	
    [super dealloc];
}

@end
