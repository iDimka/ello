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

//@property(nonatomic, retain)NSMutableArray* dataSource;

@end

@implementation PlayListsViewController

//@synthesize dataSource = _dataSource;

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
        
//		//[RKObjectManager objectManagerWithBaseURL:@"http://themedibook.com/ello/services"];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
	 
	
	
//    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=playlist&action=getChartPlaylists" objectMapping:_clipsMapping delegate:self];
	  
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
	switch (_segment.selectedSegmentIndex) {
		case 0:  
			return [[[_dataSourceCharts objectAtIndex:0] playlists] count];
			break;
		case 1:
			return [[[_dataSourceTop objectAtIndex:0] playlists] count]; 
			break;
		case 2:
			return [[[_dataSourceMy objectAtIndex:0] playlists]		count]; 
			break; 	
	}
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	PlayList* playlist =  nil;
	switch (_segment.selectedSegmentIndex) {
		case 0:  
			playlist = [[[_dataSourceCharts objectAtIndex:0] playlists] objectAtIndex:indexPath.row];
			break;
		case 1:
			playlist = [[[_dataSourceTop objectAtIndex:0] playlists] objectAtIndex:indexPath.row]; 
			break;
		case 2:
			playlist = [[[_dataSourceMy objectAtIndex:0] playlists] objectAtIndex:indexPath.row]; 
			break; 	
	}
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
		[self.tableView reloadData];	
 
//	[RKObjectManager objectManagerWithBaseURL:@"http://themedibook.com/ello/services"];
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
	
	
	_clipsMapping = [[RKObjectMapping mappingForClass:[PlayLists class]] retain];
	[_clipsMapping mapKeyPathsToAttributes:
	 @"status", @"status",
	 nil];
	RKObjectRelationshipMapping* rel = [RKObjectRelationshipMapping mappingFromKeyPath:@"playlists" toKeyPath:@"playlists" objectMapping:mapping];
	[_clipsMapping addRelationshipMapping:rel];
	  
	switch (_segment.selectedSegmentIndex) {
		case 0:			
			if ([_dataSourceCharts count]) break;
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=playlist&action=getChartPlaylists" objectMapping:_clipsMapping delegate:self]; 
			break;
		case 1:			
			if ([_dataSourceTop count])break;
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=playlist&action=getTopPlaylists" objectMapping:_clipsMapping delegate:self];
			break; 		
	}

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
 
	
	switch (_segment.selectedSegmentIndex) {
		case 0:
			if (!_dataSourceCharts) _dataSourceCharts = [NSMutableArray new];
			[_dataSourceCharts removeAllObjects];
			[_dataSourceCharts addObject:[objects objectAtIndex:0]];
			break;
		case 1:
			if (!_dataSourceTop) _dataSourceTop = [NSMutableArray new];
			[_dataSourceTop removeAllObjects];
			[_dataSourceTop addObject:[objects objectAtIndex:0]];
			break;
		case 2:
			if (!_dataSourceMy) _dataSourceMy = [NSMutableArray new];
			[_dataSourceMy removeAllObjects];
			[_dataSourceMy addObject:[objects objectAtIndex:0]];
			break; 	
	}
	
	[self.tableView reloadData];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}

- (void)dealloc {

    [_segment release]; 
	
    [super dealloc];
}

@end
