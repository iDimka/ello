//
//  GenreViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 01/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "GenreViewController.h"

@interface GenreViewController()

//@property(nonatomic, retain)UITableView*	tableView;

@end


@implementation GenreViewController

- (id)initWithGenre:(Genre*)genre {
    self = [super init];
    if (self) {
        _genre = [genre retain];
    }
    return self;
}

- (void)viewDidLoad{
	[super viewDidLoad];
	
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setRowHeight:TBL_V_H];
	UIImageView* tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
	[_tableView setBackgroundView:tmp];
	[tmp release];
	[_tableView setSeparatorColor:[UIColor clearColor]];
	
	
	self.title = _genre.genreName;
	self.navigationItem.titleView = nil;
}

- (void)segmentTapped:(UISegmentedControl*)segmentedControl{
	
	[[RKObjectManager sharedManager]
	 loadObjectsAtResourcePath:[NSString stringWithFormat:@"/service.php?service=clip&action=getClipsByGenreId&id=%d", [_genre.genreID intValue]] objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self];
	
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	if ([[_dataSource objectAtIndex:_segment.selectedSegmentIndex] isKindOfClass:[NSNull class]] ) {
		[_dataSource insertObject:[objects objectAtIndex:0] atIndex:_segment.selectedSegmentIndex];
	}
	[self hideDimView];
	[_tableView reloadData];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}

@end
