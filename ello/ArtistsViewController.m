//
//  ArtistsViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ArtistsViewController.h"

#import "Artist.h"
#import "ArtistParser.h"
#import "VideoTableViewCell.h"
#import "SearchViewController.h"
#import "PreviewViewController.h"

@interface ArtistsViewController()

@property(nonatomic, retain)NSMutableArray* dataSource;

@end

@implementation ArtistsViewController

@synthesize dataSource = _dataSoutce;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

		
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];

}
 
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  	
	_artistParser = [[ArtistParser alloc] init];
	[_artistParser setDelegate:self];
	[_artistParser loadURL:[NSURL URLWithString:@"http://themedibook.com/ello/services/service.php?service=artist&action=getAllArtists"]];
	
	 
	
	UISegmentedControl* tmp = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Все", @"Топ", @"Новые", nil]];
	[tmp setSegmentedControlStyle:UISegmentedControlStyleBar];
	[tmp setSelectedSegmentIndex:0];
	[tmp addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmp];
	self.navigationItem.leftBarButtonItem = barButtonItem;
	[barButtonItem release];
	[tmp release];
	
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
 

    
}

- (void)segmentTapped:(UISegmentedControl*)segmentedControl{
	NSLog(@"segm index %d", segmentedControl.selectedSegmentIndex);
	[self showDimView];
	switch (segmentedControl.selectedSegmentIndex) {
		case 0:
			[_artistParser loadURL:[NSURL URLWithString:@"http://themedibook.com/ello/services/service.php?service=artist&action=getAllArtists"]];
			break;
		case 1:
			[_artistParser loadURL:[NSURL URLWithString:@"http://themedibook.com/ello/services/service.php?service=artist&action=getTopArtists"]];
			break;
		case 2:
			[_artistParser loadURL:[NSURL URLWithString:@"http://themedibook.com/ello/services/service.php?service=artist&action=getNewArtists"]];
			break;
	}
}

- (void)search:(id)sender{
	SearchViewController *detailViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil]; 
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}


- (void)parser:(ArtistParser*)parser xmlDidParsed:(NSArray*)content{
	self.dataSource = [NSMutableArray arrayWithArray:content];
	[_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	[self hideDimView];
	 
}
- (void)parser:(ArtistParser*)parser xmlDidError:(NSError*)error{
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[[error userInfo] valueForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
