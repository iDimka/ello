//
//  ChannelViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 07/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ChannelViewController.h"

#import "Channel.h"

@implementation ChannelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 
- (id)initWitChannel:(Channel*)channel {
    self = [super init];
    if (self) {
        _channel = [channel retain];
    }
    return self;
}


#pragma mark - View lifecycle
 

- (void)viewDidLoad{
	[super viewDidLoad];
	
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setRowHeight:85];
	[_tableView setSeparatorColor:[UIColor darkGrayColor]];
	[_tableView setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	
	self.title = _channel.channelName;
	self.navigationItem.titleView = nil;
}

- (void)segmentTapped:(UISegmentedControl*)segmentedControl{
	
	[[RKObjectManager sharedManager]
	 loadObjectsAtResourcePath:[NSString stringWithFormat:@"/service.php?service=clip&action=getClipsByChannelId&id=%d", [_channel.channelID intValue]] objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self];
	
}


@end
