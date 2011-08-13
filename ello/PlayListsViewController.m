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

@end

@implementation PlayListsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
	 
	self.title = @"Плейлисты";
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setRowHeight:TBL_V_H];
	UIImageView* tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
	[_tableView setBackgroundView:tmp];
	[tmp release];
	[_tableView setSeparatorColor:[UIColor clearColor]];
	  
	_segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Топ ", @"Чарты", @"Мои", nil]];
	[_segment setSegmentedControlStyle:UISegmentedControlStyleBar];
	[_segment addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = _segment; 
	[_segment setSelectedSegmentIndex:0];
	
}  
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
}
- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	[_tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
	switch (_segment.selectedSegmentIndex) {
		case 0:
			return [[[_dataSourceTop objectAtIndex:0] playlists] count]; 
			break;
		case 1:  
			return [[[_dataSourceCharts objectAtIndex:0] playlists] count];
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
			playlist = [[[_dataSourceTop objectAtIndex:0] playlists] objectAtIndex:indexPath.row]; 
			break;
		case 1:  
			playlist = [[[_dataSourceCharts objectAtIndex:0] playlists] objectAtIndex:indexPath.row];
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
	
	PlayList* playlist =  nil;
	switch (_segment.selectedSegmentIndex) {
		case 0:
			playlist = [[[_dataSourceTop objectAtIndex:0] playlists] objectAtIndex:indexPath.row]; 
			break;
		case 1:  
			playlist = [[[_dataSourceCharts objectAtIndex:0] playlists] objectAtIndex:indexPath.row];
			break;
		case 2:
			playlist = [[[_dataSourceMy objectAtIndex:0] playlists] objectAtIndex:indexPath.row]; 
			break; 	
	}

	PlayListViewController *detailViewController = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:nil]; 
	[detailViewController setPlaylist:playlist];
	[detailViewController setMode:(_segment.selectedSegmentIndex == 2 ? kLocalhost : kNetwork)];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
}

- (void)segmentTapped:(id)sender{
	[self showDimView];
 
	switch (_segment.selectedSegmentIndex) 
	{
		case 0:			
		if ([_dataSourceTop count]){
			[_tableView reloadData];
			break;
		}
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=playlist&action=getTopPlaylists" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"playlists"] delegate:self];
		break; 
		case 1:			
		if ([_dataSourceCharts count]) {
			[_tableView reloadData];
			break;
		}
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=playlist&action=getChartPlaylists" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"playlists"] delegate:self]; 
			break;		
		case 2:
			if (!_dataSourceMy) _dataSourceMy = [NSMutableArray new];
			[_dataSourceMy removeAllObjects];
			[_dataSourceMy addObject:[__delegate playlists]];
			[_tableView reloadData];
		break;
	}
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
 
	
	switch (_segment.selectedSegmentIndex) {
		case 0:
			if (!_dataSourceTop) _dataSourceTop = [NSMutableArray new];
			[_dataSourceTop removeAllObjects];
			[_dataSourceTop addObject:[objects objectAtIndex:0]];
			break;
		case 1:
			if (!_dataSourceCharts) _dataSourceCharts = [NSMutableArray new];
			[_dataSourceCharts removeAllObjects];
			[_dataSourceCharts addObject:[objects objectAtIndex:0]];
			break;
		case 2:
			
			break; 	
	}
	[self hideDimView];
	[_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
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
