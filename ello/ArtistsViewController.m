//
//  ArtistsViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ArtistsViewController.h"

#import "Artist.h" 
#import "Artists.h" 
#import "VideoTableViewCell.h"
#import "SearchViewController.h"
#import "PreviewViewController.h"

@interface ArtistsViewController()
 
@end

@implementation ArtistsViewController
 
#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
  	 
	_segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Все", @"Топ", @"Новые", nil]];
	[_segment setSegmentedControlStyle:UISegmentedControlStyleBar];
	[_segment addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = _segment; 
	[_segment setSelectedSegmentIndex:0];
	
	self.title = nil;
	
	UIBarButtonItem* barButtonRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
	self.navigationItem.rightBarButtonItem = barButtonRight;
	[barButtonRight release];
	
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];

	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setSeparatorColor:[UIColor darkGrayColor]];
	[_tableView setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	_tableView.rowHeight = 154; 
	[self showDimView];
	
	
	_dataSource = [[NSMutableArray alloc] init];
	[_dataSource addObject:[NSNull null]];
	[_dataSource addObject:[NSNull null]];
	[_dataSource addObject:[NSNull null]];
	
	
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Artist class]];
    [mapping mapKeyPathsToAttributes:
     @"artist.id",		@"artistID",
	 @"artist.image",	@"artistImage",
	 @"artist.name",	@"artistName",  
     nil];
	 
	_clipsMapping = [[RKObjectMapping mappingForClass:[Artists class]] retain];
	[_clipsMapping mapKeyPathsToAttributes:
	 @"status", @"status",
	 nil];
	RKObjectRelationshipMapping* rel = [RKObjectRelationshipMapping mappingFromKeyPath:@"artists" toKeyPath:@"artists" objectMapping:mapping];
	[_clipsMapping addRelationshipMapping:rel];
	
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=artist&action=getAllArtists" objectMapping:_clipsMapping delegate:self];
	

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
    return [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] artists] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
 
    }
    
    Artist* artist = [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] artists] objectAtIndex:indexPath.row];
	
	[cell configCellByArtitst:artist];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 

    
}

- (void)segmentTapped:(UISegmentedControl*)segmentedControl{
	
	if (![[_dataSource objectAtIndex:_segment.selectedSegmentIndex] isMemberOfClass:[NSNull class]] ) {
		[_tableView reloadData];
		return;
	}
	 
	[self showDimView];
	switch (segmentedControl.selectedSegmentIndex) {
		case 0:			
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=artist&action=getAllArtists" objectMapping:_clipsMapping delegate:self]; 
			break;
		case 1:			
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=artist&action=getTopArtists" objectMapping:_clipsMapping delegate:self];
			break;
		case 2:
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=artist&action=getNewArtists" objectMapping:_clipsMapping delegate:self];
			break;		
	}

}
- (void)search:(id)sender{
	SearchViewController *detailViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil]; 
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	if ([[_dataSource objectAtIndex:_segment.selectedSegmentIndex] isMemberOfClass:[NSNull class]] ) {
		[_dataSource insertObject:[objects objectAtIndex:0] atIndex:_segment.selectedSegmentIndex];
	}
	[self hideDimView];
	[_tableView reloadData];
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
