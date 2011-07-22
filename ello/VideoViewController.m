//
//  ViewViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 08/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "VideoViewController.h"

#import "Clip.h"
#import "ClipsParser.h"
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
 
#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
	
	[self showDimView];
	_clipsParser = [[ClipsParser alloc] init];
	[_clipsParser setDelegate:self];
	[_clipsParser loadURL:[NSURL URLWithString:@"http://themedibook.com/ello/services/service.php?service=clip&action=getLatestClips"]];
 
	UISegmentedControl* tmp = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Hot", @"Premieres", @"New", nil]];
	[tmp setSegmentedControlStyle:UISegmentedControlStyleBar];
	[tmp addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmp];
	
	self.navigationItem.leftBarButtonItem = barButtonItem;
	[barButtonItem release];
	[tmp release];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	
//	_dataSource = [[[__delegate artistParser] content] retain];
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
- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)segmentTapped:(UISegmentedControl*)segmentedControl{
	NSLog(@"segm index %d", segmentedControl.selectedSegmentIndex);
	[self showDimView];
	switch (segmentedControl.selectedSegmentIndex) {
		case 0:			
			[_clipsParser loadURL:[NSURL URLWithString:@"http://themedibook.com/ello/services/service.php?service=clip&action=getLatestClips"]];
			break;
			case 1:			
			[_clipsParser loadURL:[NSURL URLWithString:@"http://themedibook.com/ello/services/service.php?service=clip&action=getPremierClips"]];
			break;
		case 2:
			[_clipsParser loadURL:[NSURL URLWithString:@"http://themedibook.com/ello/services/service.php?service=clip&action=getPopularClips"]];
			break;		
	}
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
    Clip* artist = [_dataSource objectAtIndex:indexPath.row]; 
	
	[cell configCellByClip:artist];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
     PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController" bundle:nil];
	detailViewController.clip = [_dataSource objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
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

- (void)dealloc{
    [super dealloc];
}

@end
