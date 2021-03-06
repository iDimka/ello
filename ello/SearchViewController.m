//
//  SearchViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "SearchViewController.h"

#import "PrerollViewController.h"
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
	
	_tableView = [self.searchDisplayController.searchResultsTableView retain];
	for (UIView *view in self.searchDisplayController.searchBar.subviews)
		{
		if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
			{
			[view removeFromSuperview];
			}
		if([view isKindOfClass: [UITextField class]])
			{
			[(UITextField *)view setKeyboardAppearance: UIKeyboardAppearanceAlert];
			}
		}
	[self.searchDisplayController.searchResultsTableView setRowHeight:TBL_V_H];
//	[self.searchDisplayController.searchResultsTableView setSeparatorColor:[UIColor clearColor]];
	UIImageView* tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
	[self.view insertSubview:tmp atIndex:0];
	[tmp release];
	
	
	[_tableView setRowHeight:TBL_V_H];
	[_tableView setSeparatorColor:[UIColor clearColor]];
	tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
	[_tableView setBackgroundView:tmp];
	[tmp release];
	
	
} 
- (void)viewDidAppear{
	[self viewDidAppear];
	
	[self.searchDisplayController setActive:YES animated:YES];
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
	[self.searchDisplayController setActive:NO];
	
	switch ((int)mode) {
		case kClip:; 
			NSURL* prerollURL = nil;
			if ((prerollURL = [AVPlayerDemoPlaybackViewController hasPreroll])) 
				{
				Clip* clip = [_dataSource objectAtIndex:[_dataSource  objectAtIndex:indexPath.row]];
				AVPlayerDemoPlaybackViewController* tmp = [[AVPlayerDemoPlaybackViewController alloc] initWithClip:clip];
				[tmp setURL:prerollURL];
				[tmp setAvdelegate:self]; 
				[[__delegate window] addSubview:tmp.view]; 
			}
			else{
				Clip* clip = [_dataSource  objectAtIndex:indexPath.row];
				PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithClip:[_dataSource  objectAtIndex:indexPath.row]];
				[self.navigationController pushViewController:detailViewController animated:YES];
				[detailViewController release];
			}
			break;
		case kArtist:;			
			ArtistViewController* tmp = [[ArtistViewController alloc] initWithArtist:[_dataSource  objectAtIndex:indexPath.row]];
			[self.navigationController pushViewController:tmp animated:YES];
			[tmp release];
			break; 
	} 
}

- (void)showClip:(NSInvocationOperation*)inv{
	PreviewViewController* tmp = (PreviewViewController*)[inv result]; 
	[self.navigationController pushViewController:tmp animated:YES];
	[tmp release];
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
	[self.searchDisplayController setActive:NO animated:NO];
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	if ([searchText isEqualToString:@""]) {
		return;
	} 
	UIImageView* tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
	[self.searchDisplayController.searchResultsTableView setBackgroundView:tmp];
	[tmp release];
//	[_dataSource removeAllObjects];
	[self.searchDisplayController.searchResultsTableView setRowHeight:TBL_V_H];
//	[self.searchDisplayController.searchResultsTableView reloadData];
//	[_tableView reloadData];
	
	[[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self];
	switch ((int)mode) {
		case kClip:;
			
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/service.php?service=util&action=searchByClipName&name=%@", [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self]; 
			break;
		case kArtist:
			
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath: [NSString stringWithFormat:@"/service.php?service=util&action=searchByArtistName&name=%@", [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]  objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"artists"] delegate:self]; 
			break; 
	} 
} 

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	if (![objects count]) return;
	[_dataSource removeAllObjects];
	switch (mode) {
		case kClip:
			[_dataSource addObjectsFromArray:[[objects objectAtIndex:0] clips]];
			break;
			
		default:
			[_dataSource addObjectsFromArray:[[objects objectAtIndex:0] artists]];
			break;
	}
	
	NSLog(@"---%@---", [objects objectAtIndex:0]);
	[_tableView reloadData];

}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
	NSString* url  = [[objectLoader URL] absoluteString];
	NSLog(@"\%@", url);
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"%@", tmp);
	
}



@end
