//
//  PlayListViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayListViewController.h"

#import "PreviewViewController.h"
#import "PlayerViewController.h"
#import "Clip.h"
#import "Clips.h"
#import "PlayList.h"

@interface PlayListViewController()

@property(nonatomic, retain)Clip*				clipToPlaylist;

@end

@implementation PlayListViewController

@synthesize clipToPlaylist;
@synthesize mode;
@synthesize playlist = _playList;
 
#pragma mark - View lifecycle

- (void)configTableViewAppearence {
  UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
	[header setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	UILabel* plName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 250, 20)];
	[plName setFont:[UIFont boldSystemFontOfSize:13]];
	[plName setBackgroundColor:[UIColor clearColor]];
	[plName setTextColor:[UIColor whiteColor]];
	[plName setText:[NSString stringWithFormat:@"Плейлист #%d", [_playList.playListID intValue] + 1]];
	[header addSubview:plName];
	[plName release];
		
	UILabel* plCompiler = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 250, 20)];
	[plCompiler setFont:[UIFont systemFontOfSize:13]];
	[plCompiler setBackgroundColor:[UIColor clearColor]];
	[plCompiler setTextColor:[UIColor whiteColor]];
	[plCompiler setText:@"Составлено: Команда ЕЛЛО"];
	[header addSubview:plCompiler];
	[plCompiler release];
	
	plClipsCount = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 250, 20)];
	[plClipsCount setFont:[UIFont boldSystemFontOfSize:13]];
	[plClipsCount setBackgroundColor:[UIColor clearColor]];
	[plClipsCount setTextColor:[UIColor lightGrayColor]];
	[plClipsCount setTextColor:[UIColor whiteColor]];
	[header addSubview:plClipsCount];
	[plClipsCount release];
	
	_tableView.tableHeaderView = header;
	
	UIButton* showAll = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[showAll addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
	[showAll setCenter:CGPointMake(278, 24)];
	[header addSubview:showAll];
	
	
	[header release];

}

- (void)viewDidLoad{
    [super viewDidLoad];

	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
	[self.view addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setSeparatorColor:[UIColor darkGrayColor]];
	[_tableView setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	_dataSource = [NSMutableArray new];
	
	
	_tableView.rowHeight = 80;
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
	
	
	switch ((int)mode) {
		case kNetwork:
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat: @"/service.php?service=clip&action=getClipsByPlaylistId&id=%d", [_playList.playListID intValue]] objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self];
			
			break;
			
		case kLocalhost:;
			PlayList* pl = _playList;
			Clips* clips = [Clips new];
			[clips setClips:pl.clips];
			[_dataSource addObject:clips];
			[clips release];
			break;
	}
	
	[self configTableViewAppearence];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

#pragma mark - Table view data source
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
	if (![_dataSource count]) return 0;
	[plClipsCount setText:[NSString stringWithFormat:@"%d клипов", [[[_dataSource objectAtIndex:0] clips] count]]];
    return [[[_dataSource objectAtIndex:0] clips] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    Clip* clip = [[[_dataSource objectAtIndex:0] clips] objectAtIndex:indexPath.row]; 
	
	[cell setClipDelegate:self];
	[cell configCellByClip:clip];
	[cell setClipNumber:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    Clip* clip = [[[_dataSource objectAtIndex:0] clips] objectAtIndex:indexPath.row]; 
	PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController" bundle:nil];
	detailViewController.clip = clip;
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
}

- (void)addToPlaylist:(Clip*)clip{
	
	self.clipToPlaylist = clip;
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Добавить это видео в..." delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Отмена" otherButtonTitles:@"Новый плейлист", nil];
	for (PlayList* pl in [[__delegate playlists] playlists]) {
		[actionSheet addButtonWithTitle:pl.name];
	}
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
	
	
}
- (void)showAll:(id)sender{
	UIActionSheet* menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Просмотреть Все", @"Вперемешку", nil];
	[menu showInView:_tableView.tableHeaderView];
	[menu release];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 0) {
		PlayList* playlist = [_dataSource objectAtIndex:0];
		PlayerViewController *detailViewController = [[PlayerViewController alloc] initWithPlaylist:playlist inPlayMode:kNormal];
		detailViewController.playlist = playlist;
		[self presentMoviePlayerViewControllerAnimated:detailViewController]; 
		[detailViewController release];
	}	
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	if ([objects count] == 0) return;
			if (!_dataSource) _dataSource = [NSMutableArray new];
			[_dataSource removeAllObjects];
			[_dataSource addObject:[objects objectAtIndex:0]];
	

	[self hideDimView];
	[_tableView reloadData];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}


@end
