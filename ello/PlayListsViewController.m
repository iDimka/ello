//
//  PlayListViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayListsViewController.h"

#import "PlayList.h"
#import "PlayLists.h"

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

#import "VideoTableViewCell.h"
#import "Artist.h"
#import "AsyncImageView.h"
#import "PlayListViewController.h"

@interface PlayListsViewController()

@property(nonatomic, retain)NSMutableArray* dataSource;

@end

@implementation PlayListsViewController

@synthesize dataSource = _dataSource;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
//		[RKObjectManager objectManagerWithBaseURL:@"http://themedibook.com/ello/services"];
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
	 
	 
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[PlayList class]];
    [mapping mapKeyPathsToAttributes:
     @"playlist.id",		@"playListID",
	 @"playlist.artistId",	@"artistID",
	 @"playlist.artistName",@"artistName",
  	 @"playlist.genreId",	@"genreID",
  	 @"playlist.genreName",	@"genreName",
  	 @"playlist.viewCount",	@"viewCount",
	 @"playlist.name",		@"name",
	 @"playlist.image",		@"imageURLString",
 	 @"playlist.video",		@"videoURLString",
  	 @"playlist.label",		@"label", 
     nil];
	
	/*
	 NSNumber*		playListID;
	 NSNumber*		artistID;
	 NSString*		artistName;
	 NSURL*			imageURLString;
	 NSNumber*		genreID;
	 NSString*		genreName;
	 NSNumber*		viewCount;
	 NSString*		name;
	 NSString*		videoURLString;
	 NSString*		label;
	 */
	_clipsMapping = [[RKObjectMapping mappingForClass:[PlayLists class]] retain];
	[_clipsMapping mapKeyPathsToAttributes:
	 @"status", @"status",
	 nil];
	RKObjectRelationshipMapping* rel = [RKObjectRelationshipMapping mappingFromKeyPath:@"playlists" toKeyPath:@"playlists" objectMapping:mapping];
	[_clipsMapping addRelationshipMapping:rel];
	
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=playlist&action=getChartPlaylists" objectMapping:_clipsMapping delegate:self];
	  
	_segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Чарты", @"Топ ", @"Мои артисты", nil]];
	[_segment setSegmentedControlStyle:UISegmentedControlStyleBar];
	[_segment addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = _segment; 
	[_segment setSelectedSegmentIndex:0];
	[_segment setEnabled:NO forSegmentAtIndex:2];
	 
	[self.tableView setBackgroundColor:[UIColor blackColor]];
	self.tableView.rowHeight = 154;
	
}
- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	
	
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
} 

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
	if ([[_dataSource objectAtIndex:_segment.selectedSegmentIndex] isMemberOfClass:[NSNull class]] ) return 0; 
    return [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] playlists] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	PlayList* playlist =  [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] playlists] objectAtIndex:indexPath.row]; 
	
	[cell configCellByPlayList:playlist];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
//	PlayList* artist =  [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] playlists] objectAtIndex:indexPath.row];
	PlayListViewController *detailViewController = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:nil]; 
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
}

- (void)segmentTapped:(id)sender{
	
	if (![[_dataSource objectAtIndex:_segment.selectedSegmentIndex] isMemberOfClass:[NSNull class]] ) {
		[self.tableView reloadData];
		return;
	}
	  
	switch (_segment.selectedSegmentIndex) {
		case 0:			
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=playlist&action=getChartPlaylists" objectMapping:_clipsMapping delegate:self]; 
			break;
		case 1:			
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=playlist&action=getTopPlaylists" objectMapping:_clipsMapping delegate:self];
			break; 		
	}

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	if ([[_dataSource objectAtIndex:_segment.selectedSegmentIndex] isMemberOfClass:[NSNull class]] ) {
		[_dataSource insertObject:[objects objectAtIndex:0] atIndex:_segment.selectedSegmentIndex];
	}
//	[self hideDimView];
	[self.tableView reloadData];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}

- (void)dealloc {

    [_segment release];
	[_dataSource release];
	
    [super dealloc];
}

@end
