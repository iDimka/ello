//
//  ViewViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 08/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "VideoViewController.h"

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

#import "Clips.h"
#import "Clip.h" 
#import "Artist.h"
#import "SearchViewController.h"
#import "PreviewViewController.h"
#import "VideoObject.h"
#import "VideoTableViewCell.h"

@interface VideoViewController()

@property(nonatomic, retain)NSMutableArray*		dataSource;

@end

@implementation VideoViewController

@synthesize dataSource = _dataSource;
 
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
	
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
	
	
	_dataSource = [[NSMutableArray alloc] init];
	[_dataSource addObject:[NSNull null]];
	[_dataSource addObject:[NSNull null]];
	[_dataSource addObject:[NSNull null]];
	
	[self showDimView];
 
	
//	[RKObjectManager objectManagerWithBaseURL:@"http://themedibook.com/ello/services"];
//	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Clip class]];
//    [mapping mapKeyPathsToAttributes:
//     @"clip.id",		@"clipID",
//	 @"clip.artistId",	@"artistId",
//	 @"clip.artistName",@"artistName",
//  	 @"clip.genreId",	@"clipGanre",
//  	 @"clip.genreName",	@"clipGanreName",
//  	 @"clip.viewCount",	@"viewCount",
//	 @"clip.name",		@"clipName",
//	 @"clip.image",		@"clipImageURL",
// 	 @"clip.video",		@"clipVideoURL",
//  	 @"clip.label",		@"label", 
//     nil];
//	
//	_clipsMapping = [[RKObjectMapping mappingForClass:[Clips class]] retain];
//	[_clipsMapping mapKeyPathsToAttributes: @"status", @"status",  nil];
//	RKObjectRelationshipMapping* rel = [RKObjectRelationshipMapping mappingFromKeyPath:@"clips" toKeyPath:@"clips" objectMapping:mapping];
//	[_clipsMapping addRelationshipMapping:rel];

	
	_segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Популярные ", @"Премеры", @"Новинки", nil]];
	[_segment setSegmentedControlStyle:UISegmentedControlStyleBar];
	[_segment addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = _segment; 
	[_segment setSelectedSegmentIndex:0];
	
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	
//	_dataSource = [[[__delegate artistParser] content] retain];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
	
	[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)segmentTapped:(UISegmentedControl*)segmentedControl{
	[_tableView reloadData];
 

	NSLog(@"segm index %d", segmentedControl.selectedSegmentIndex);
	[self showDimView];
	switch (segmentedControl.selectedSegmentIndex) {
		case 0:			
			 [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=clip&action=getLatestClips" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self]; 
			break;
			case 1:			
			 [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=clip&action=getPremierClips" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self];
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
     PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController" bundle:nil];
	detailViewController.clip = clip;
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}
 
- (void)search:(id)sender{
	SearchViewController *detailViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil mode:kClip]; 
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}
- (void)addToPlaylist:(Clip*)clip{
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Добавить это видео в..." delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Отмена" otherButtonTitles:@"Новый плейлист", nil];
	[actionSheet addButtonWithTitle:@"Мой плейлист"];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
	
	
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
