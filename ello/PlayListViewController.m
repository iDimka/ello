//
//  PlayListViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PlayListViewController.h"

#import "MKEntryPanel.h"
#import "PreviewViewController.h"
#import "PlayerViewController.h"
#import "Clip.h"
#import "Clips.h"
#import "PlayList.h"
#import "PlayLists.h"

@interface PlayListViewController()

@property(nonatomic, retain)Clip*				clipToPlaylist;

- (void)addToPlaylist:(Clip*)cell;

@end

@implementation PlayListViewController

@synthesize repeatPlaylist = _repeatPlayList;
@synthesize clipToPlaylist;
@synthesize mode;
@synthesize playlist = _playList;
 
#pragma mark - View lifecycle

- (void)configTableViewAppearence {
 

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
	
	self.title = _playList.name;
	
	[self configTableViewAppearence];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	[_tableView reloadData];
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

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (!self.repeatPlaylist) {
		return 70;
	}	
	return 120;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (!self.repeatPlaylist) 
		{
	 
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
	 
	
	UIButton* showAll = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[showAll addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
	[showAll setCenter:CGPointMake(278, 24)];
	[header addSubview:showAll];
	
	 
	
	return [header autorelease];
	}
	
	UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
	[header setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	UILabel* plType = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 180, 20)];
	[plType setFont:[UIFont boldSystemFontOfSize:13]];
	[plType setBackgroundColor:[UIColor clearColor]];
	[plType setTextColor:[UIColor whiteColor]];
	[plType setText:[NSString stringWithFormat:@"Тип плейлиста...", [_playList.playListID intValue] + 1]];
	[header addSubview:plType];
	[plType release];
	
	
	AsyncImageView* videoThumb = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, 5, 112, 69)];	
	if (_repeatPlayList.imageURLString)[videoThumb loadImageFromURL:[NSURL URLWithString:_repeatPlayList.imageURLString]];	
	else if ([_repeatPlayList.clips count]) [videoThumb loadImageFromURL:[NSURL URLWithString:[(Clip*)[_repeatPlayList.clips objectAtIndex:0] clipImageURL]]];
	[header addSubview:videoThumb];
	   
	UIButton* repeat = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[repeat addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
	[repeat setTitle:@"Еще раз" forState:UIControlStateNormal];
	[repeat setFrame:CGRectMake(140, 30, 70, 30)];
	[header addSubview:repeat];
	
	UISegmentedControl* s = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, header.frame.size.height - 30, 320, 30)];
	[s setSegmentedControlStyle:UISegmentedControlStyleBar];
	[s setTintColor:[UIColor darkGrayColor]]; 
	[s insertSegmentWithTitle:@"В Этом Плейлисте"	atIndex:0 animated:NO];
	[s insertSegmentWithTitle:@"Похожие плейлисты"	atIndex:1 animated:NO];
	[s setSelectedSegmentIndex:0];
	[s addTarget:self action:@selector(segmentHeaderTapped:) forControlEvents:UIControlEventValueChanged];
	[header addSubview:s];
	[s release];
		  
	return [header autorelease];

	
}
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
//	NSLog([clip.artistId stringValue]);
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    Clip* clip = [[[_dataSource objectAtIndex:0] clips] objectAtIndex:indexPath.row]; 
	PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithClip:clip];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	 
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	if (mode == kLocalhost ) {
		[[_playList clips] removeObjectAtIndex:indexPath.row];
		[[__delegate playlists] save];
		[tableView reloadData];
	}
} 
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	if (mode == kLocalhost) {
		return YES;
	}
	return NO;
}

#pragma mark -

- (void)segmentHeaderTapped:(UISegmentedControl*)sender{
	
}
- (void)showAll:(id)sender{
	if (![_dataSource count]) return;
	UIActionSheet* menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Просмотреть Все", @"Вперемешку", nil];
	[menu showInView:self.view];
	[menu release];

}
- (void)addToPlaylist:(Clip*)clip{
	
	self.clipToPlaylist = clip;
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Добавить это видео в..." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Новый плейлист", nil];
	[actionSheet setTag:777];
	for (PlayList* pl in [[__delegate playlists] playlists]) {
		[actionSheet addButtonWithTitle:pl.name];
	}
	[actionSheet addButtonWithTitle:@"Отмена"];
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
	
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet.tag == 777) {
		if (buttonIndex == [actionSheet numberOfButtons] - 1) return;
		if (buttonIndex == 0) {
			
			PlayList* playList = [PlayList new];
			[MKEntryPanel showPanelWithTitle:NSLocalizedString(@"Название листа", @"") 
									  inView:self.view 
							   onTextEntered:^(NSString* enteredString)
			 {
			 
			 playList.name = enteredString;
			 [[__delegate playlists] addPlaylist:playList];
			 
			 }];
			[[playList clips] addObject:clipToPlaylist];
			[playList release];
			self.clipToPlaylist = nil;
		}else{
			PlayList* myPlaylist = [[[__delegate playlists] playlists] objectAtIndex:buttonIndex - 1];
			self.repeatPlaylist = myPlaylist;
			[[myPlaylist clips] addObject:clipToPlaylist];
			self.clipToPlaylist = nil;
		}
		return;
	}
	if (buttonIndex != actionSheet.cancelButtonIndex)
		{
		PlayList* playlist = [_dataSource objectAtIndex:0];
		self.repeatPlaylist = _playList;
		PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithPlaylist:playlist inPlayMode:(buttonIndex ? kShufle : kNormal)];
		[self.navigationController pushViewController:detailViewController  animated:YES]; 
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
