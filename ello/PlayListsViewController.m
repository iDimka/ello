//
//  PlayListViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayListsViewController.h"

#import "PlayList.h"

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

@synthesize dataSource = _dataSoutce;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//	[RKObjectManager objectManagerWithBaseURL:@"http://themedibook.com/ello/services"];
//	
//    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[PlayList class]];
//    [mapping mapKeyPathsToAttributes:
//     @"id", @"accountID",
//     nil];
//	
//    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=artist&action=getAllArtists" objectMapping:mapping delegate:self];
	
	//	self.dataSource = [[__delegate artistParser] valueForKeyPath:@"_content"];
	
	UISegmentedControl* tmp = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Топ ", @"Чарты", @"Мои артисты", nil]];
	[tmp setSegmentedControlStyle:UISegmentedControlStyleBar];
	[tmp addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = tmp; 
	[tmp setSelectedSegmentIndex:0];
	[tmp release];
	
	self.tableView.rowHeight = 154;
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    return [_dataSoutce count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	Artist* artist = [_dataSoutce objectAtIndex:indexPath.row]; 
	
	[cell configCellByArtitst:artist];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	PlayListViewController *detailViewController = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:nil]; 
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
}

- (void)segmentTapped:(id)sender{
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}

- (void)dealloc {
    
	[_dataSoutce release];
	
    [super dealloc];
}

@end
