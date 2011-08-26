//
//  GanriViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 27/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "GenresViewController.h"

#import "GenreViewController.h"
#import "SearchViewController.h"
#import "Genres.h"
#import "GanriTableViewCell.h"
@interface GenresViewController()

- (void)InesrtViewInCantainer;

@end

@implementation GenresViewController;
 
- (void)dealloc{
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{   _dataSource = [[NSMutableArray alloc] init];
    [super viewDidLoad];
	
	self.title = @"Жанры";
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setSeparatorColor:[UIColor darkGrayColor]];
	[_tableView setRowHeight:TBL_V_H];
	[_tableView setSeparatorColor:[UIColor clearColor]];
	UIImageView* tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
	[_tableView setBackgroundView:tmp];
	[tmp release];

	
	[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=genre&action=getAllGenres" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"genres"] delegate:self]; 
	[self showDimView];
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
- (void)InesrtViewInCantainer{
//
//    for (int ind = 0; ind < 3; ind++) 
//    {
//        Genre* tmp = [Genre new];    
//        
//		tmp.ge = [NSNumber numberWithInt:ind];
//        if (ind ==0) tmp.ge =@"Pop";
//        if (ind ==1) tmp.GanrName =@"Rok";
//        if (ind ==2) tmp.GanrName =@"Tehno";
//        [_dataSource addObject:tmp];
//        [tmp release];
//	}  
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![_dataSource count]) {
		return 0;
	}
    return [[[_dataSource objectAtIndex:0] genres] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    GanriTableViewCell *cell = (GanriTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[GanriTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    Genre* ganrName = [[[_dataSource objectAtIndex:0] genres]  objectAtIndex:indexPath.row]; 
	
	[cell configCellByGanri:ganrName];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    Genre* ganrName = [[[_dataSource objectAtIndex:0] genres]  objectAtIndex:indexPath.row]; 
	GenreViewController* tmp = [[GenreViewController alloc] initWithGenre:ganrName];
	[self.navigationController pushViewController:tmp animated:YES];
	[tmp release];
}
- (IBAction)search:(id)sender{
	
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	_dataSource = [NSMutableArray new];
	[_dataSource addObject:[objects objectAtIndex:0]];
	[self hideDimView];
	[_tableView reloadData];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}


@end
