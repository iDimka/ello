//
//  SearchViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "SearchViewController.h"

#import "Artist.h"
#import "Artists.h"
#import "VideoTableViewCell.h"
#import "Clip.h"
#import "Clips.h"

@implementation SearchViewController

@synthesize mode;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];

	_dataSource = [NSMutableArray new];
	
	   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[self.searchDisplayController setActive:YES animated:NO];
 

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
		[self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
	switch (mode) {
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
		[self.searchDisplayController setActive:NO animated:NO];
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	[RKObjectManager objectManagerWithBaseURL:@"http://themedibook.com/ello/services"];
	[[[RKObjectManager sharedManager] objectLoaderWithResourcePath:nil delegate:self] setDelegate:nil];
	switch (mode) {
		case kClip:;
			
//			//[RKObjectManager objectManagerWithBaseURL:@"http://themedibook.com/ello/services"];
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
			
			_clipsMapping = [[RKObjectMapping mappingForClass:[Clips class]] retain];
			[_clipsMapping mapKeyPathsToAttributes:@"status", @"status", nil];
			RKObjectRelationshipMapping* rel = [RKObjectRelationshipMapping mappingFromKeyPath:@"clips" toKeyPath:@"clips" objectMapping:mapping];
			[_clipsMapping addRelationshipMapping:rel];
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/service.php?service=util&action=searchByClipName&name=%@", searchText] objectMapping:_clipsMapping delegate:self]; 
			break;
		case kArtist:
			
			mapping = [RKObjectMapping mappingForClass:[Artist class]];
			[mapping mapKeyPathsToAttributes:
			 @"artist.id",		@"artistID",
			 @"artist.image",	@"artistImage",
			 @"artist.name",	@"artistName",  
			 nil];
			
			_clipsMapping = [[RKObjectMapping mappingForClass:[Artists class]] retain];
			[_clipsMapping mapKeyPathsToAttributes:
			 @"status", @"status", nil]; 
			[_clipsMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"artists" toKeyPath:@"artists" objectMapping:mapping]];
			 
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath: [NSString stringWithFormat:@"/service.php?service=util&action=searchByArtistName&name=%@", searchText]  objectMapping:_clipsMapping delegate:self]; 
			break; 
	} 
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
	
//	[o_searchArray removeAllObjects];
//	[o_tableView reloadData];
	return  YES;
}
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
	 
}
  
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[_dataSource removeAllObjects];
	switch (mode) {
		case kClip:
			[_dataSource addObjectsFromArray:[[objects objectAtIndex:0] clips]];
			break;
			
		default:
			[_dataSource addObjectsFromArray:[[objects objectAtIndex:0] artists]];
			break;
	}
	[self.tableView reloadData];
	[[[UIApplication sharedApplication] delegate] performSelector:@selector(show)];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}



@end
