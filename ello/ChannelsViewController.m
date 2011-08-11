//
//  ChannelsViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 07/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ChannelsViewController.h"

#import "ChannelViewController.h"
#import "VideoTableViewCell.h"
#import "Channel.h"
#import "Channels.h"

@implementation ChannelsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad{   _dataSource = [[NSMutableArray alloc] init];
    [super viewDidLoad];
	
	self.title = @"Каналы";
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
//	[_tableView setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
[_tableView setRowHeight:TBL_V_H];
	[_tableView setSeparatorColor:[UIColor clearColor]];
	UIImageView* tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
	[_tableView setBackgroundView:tmp];
	[tmp release];
	
	[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=channel&action=getAllChannels" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"channels"] delegate:self]; 
	[self showDimView];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
	if (![_dataSource count]) return 0;
	return [[[_dataSource objectAtIndex:0] channels] count];
 
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	Channel* channel = [[[_dataSource objectAtIndex:0] channels] objectAtIndex:indexPath.row]; 
	 
 
	[cell configCellByChannel:channel];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	Channel* channel = [[[_dataSource objectAtIndex:0] channels] objectAtIndex:indexPath.row];  	
	ChannelViewController* tmp = [[ChannelViewController alloc] initWitChannel:channel];
	[self.navigationController pushViewController:tmp animated:YES];
	[tmp release];
 
	
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
