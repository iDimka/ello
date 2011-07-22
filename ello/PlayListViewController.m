//
//  PlayListViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayListViewController.h"


@implementation PlayListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
 
#pragma mark - View lifecycle

- (void) configTableViewAppearence {
  UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
	[header setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	UILabel* plName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 250, 20)];
	[plName setFont:[UIFont boldSystemFontOfSize:13]];
	[plName setBackgroundColor:[UIColor clearColor]];
	[plName setTextColor:[UIColor whiteColor]];
	[plName setText:@"Плейлист #1"];
	[header addSubview:plName];
	[plName release];
	
	
	UILabel* plCompiler = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 250, 20)];
	[plCompiler setFont:[UIFont systemFontOfSize:13]];
	[plCompiler setBackgroundColor:[UIColor clearColor]];
	[plCompiler setTextColor:[UIColor whiteColor]];
	[plCompiler setText:@"Составлено: Команда ЕЛЛО"];
	[header addSubview:plCompiler];
	[plCompiler release];
	
	
	UILabel* plClipsCount = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 250, 20)];
	[plClipsCount setFont:[UIFont boldSystemFontOfSize:13]];
	[plClipsCount setBackgroundColor:[UIColor clearColor]];
	[plClipsCount setTextColor:[UIColor lightGrayColor]];
	[plClipsCount setTextColor:[UIColor whiteColor]];
	[plClipsCount setText:[NSString stringWithFormat:@"%d клипов", [_dataSoutce count]]];
	[header addSubview:plClipsCount];
	[plClipsCount release];
	
	self.tableView.tableHeaderView = header;
	
	UIButton* showAll = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[showAll addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
	[showAll setCenter:CGPointMake(278, 24)];
	[header addSubview:showAll];
	
	
	[header release];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

	
	_dataSoutce = [NSMutableArray new];
	[_dataSoutce addObject:@"Инь-Ян"];
	[_dataSoutce addObject:@"Вера Брежнева"];
	[_dataSoutce addObject:@"Карандаш"];
	[_dataSoutce addObject:@"Гуф"];
	[_dataSoutce addObject:@"Баста"];
	[_dataSoutce addObject:@"Тату"];
	[_dataSoutce addObject:@"Moby"];
	[_dataSoutce addObject:@"Mozart"];
	[_dataSoutce addObject:@"DJ Smash"];
	[_dataSoutce addObject:@"Paul van Dayke"];
	[_dataSoutce addObject:@"Eminem"];
	
	[self configTableViewAppearence];

	
	self.tableView.rowHeight = 80;
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];

	
	
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.imageView.image = [UIImage imageNamed:@"cellThumb.png"];
    cell.textLabel.text = [_dataSoutce objectAtIndex:indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)showAll:(id)sender{
	UIActionSheet* menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Просмотреть Все", @"Вперемешку", nil];
	[menu showInView:self.tableView.tableHeaderView];
	[menu release];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
}

@end
