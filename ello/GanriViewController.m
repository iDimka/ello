//
//  GanriViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 27/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "GanriViewController.h"
#import "SearchViewController.h"
#import "Ganri.h"
#import "GanriTableViewCell.h"
@interface GanriViewController()

- (void)InesrtViewInCantainer;

@end

@implementation GanriViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{   _dataSource = [[NSMutableArray alloc] init];
    [super viewDidLoad];
	
	self.title = @"Жанры";
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setSeparatorColor:[UIColor darkGrayColor]];
	[_tableView setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
    [self InesrtViewInCantainer];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)InesrtViewInCantainer{

    for (int ind = 0; ind < 3; ind++) 
    {
        Ganri* tmp = [Ganri new];    
        
		tmp.GanrID = [NSNumber numberWithInt:ind];
        if (ind ==0) tmp.GanrName =@"Pop";
        if (ind ==1) tmp.GanrName =@"Rok";
        if (ind ==2) tmp.GanrName =@"Tehno";
        [_dataSource addObject:tmp];
        [tmp release];
	}  
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataSource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    GanriTableViewCell *cell = (GanriTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[GanriTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    Ganri* ganrName = [_dataSource objectAtIndex:indexPath.row]; 
	
	[cell configCellByGanri:ganrName];
    
    return cell;
}


- (IBAction)search:(id)sender{
	
}

@end
