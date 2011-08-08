//
//  SearchViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "SearchViewController.h"

#import "PreviewViewController.h"
#import "ArtistViewController.h"
#import "Artist.h"
#import "Artists.h"
#import "VideoTableViewCell.h"
#import "Clip.h"
#import "Clips.h"

@implementation SearchViewController

@synthesize mode;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)bundle mode:(SearchMode)mod{
    self = [super initWithNibName:nibNameOrNil bundle:bundle];
    if (self) {
		
		self.mode = mod;		
    }
    return self;
}
- (void)dealloc{
	[[RKRequestQueue sharedQueue] cancelAllRequests]; 
	[_dataSource release];
	
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
	 	
	self.title = @"Поиск";
	_dataSource = [NSMutableArray new];
	 
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setSeparatorColor:[UIColor darkGrayColor]];
	[_tableView setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	_tableView = [self.searchDisplayController.searchResultsTableView retain];
	
	[self.searchDisplayController.searchResultsTableView setRowHeight:85];
	[self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	[self.searchDisplayController.searchResultsTableView setSeparatorColor:[UIColor darkGrayColor]];
	[_tableView setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	[_tableView setSeparatorColor:[UIColor darkGrayColor]];
	
	
} 
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

	[self.navigationController setNavigationBarHidden:NO animated:YES];	

} 

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
    return [_dataSource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	id data;
	switch ((int)mode) {
		case kArtist:
			data = [_dataSource  objectAtIndex:indexPath.row]; 
			[cell configCellByArtitst:data];
			break;
		case kClip:
			data = [_dataSource  objectAtIndex:indexPath.row]; 
			[cell configCellByClip:data];
			break;
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	switch ((int)mode) {
		case kClip:;
			PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithClip:[_dataSource  objectAtIndex:indexPath.row]];
			[self.navigationController pushViewController:detailViewController animated:YES];
			[detailViewController release];
			break;
		case kArtist:;			
			ArtistViewController* tmp = [[ArtistViewController alloc] initWithArtist:[_dataSource  objectAtIndex:indexPath.row]];
			[self.navigationController pushViewController:tmp animated:YES];
			[tmp release];
			break; 
	} 
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
	[self.searchDisplayController setActive:NO animated:NO];
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	
	[[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self];
	switch ((int)mode) {
		case kClip:;
			
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/service.php?service=util&action=searchByClipName&name=%@", searchText] objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self]; 
			break;
		case kArtist:
			
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath: [NSString stringWithFormat:@"/service.php?service=util&action=searchByArtistName&name=%@", searchText]  objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"artists"] delegate:self]; 
			break; 
	} 
} 

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[_dataSource removeAllObjects];
	if (![objects count]) return;
	switch (mode) {
		case kClip:
			[_dataSource addObjectsFromArray:[[objects objectAtIndex:0] clips]];
			break;
			
		default:
			[_dataSource addObjectsFromArray:[[objects objectAtIndex:0] artists]];
			break;
	}
	[_tableView reloadData];

}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
	NSString* url  = [[objectLoader URL] absoluteString];
	NSLog(@"\%@", url);
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}



@end
