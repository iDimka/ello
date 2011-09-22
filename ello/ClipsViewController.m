//
//  ViewViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 08/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ClipsViewController.h"

#import "PrerollViewController.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>
#import "PrerollViewController.h"
#import "MKEntryPanel.h"
#import "PlayList.h"
#import "PlayLists.h"
#import "Clips.h"
#import "Clip.h" 
#import "Artist.h"
#import "SearchViewController.h"
#import "PreviewViewController.h"
#import "VideoObject.h"
#import "VideoTableViewCell.h"

@interface ClipsViewController()

@property(nonatomic, retain)NSMutableArray*		dataSource;

@end

@implementation ClipsViewController

@synthesize hasHeader = _isHasHeader;
@synthesize clipToPlaylist;
@synthesize dataSource = _dataSource;
 
#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];

	self.title = @"Клипы";
	
	_dataSource = [[NSMutableArray alloc] init];
	[_dataSource addObject:[NSNull null]];
	[_dataSource addObject:[NSNull null]];
	[_dataSource addObject:[NSNull null]];
	[_dataSource addObject:[NSNull null]];
	
	[self showDimView];
  
	[_tableView setRowHeight:TBL_V_H];
	[_tableView setSeparatorColor:[UIColor clearColor]];
	UIImageView* tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
	[_tableView setBackgroundView:tmp];
	[tmp release];
	
	_segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"Премьеры", @"Популярные", @"Новинки", nil]];
	[_segment setSegmentedControlStyle:UISegmentedControlStyleBar];
	[_segment addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = _segment; 
	[_segment setSelectedSegmentIndex:0];
	
} 
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[_tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
	
	[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}
 
- (void)segmentTapped:(UISegmentedControl*)segmentedControl{
	[_tableView reloadData];
 

	NSLog(@"segm index %d", segmentedControl.selectedSegmentIndex);
	[self showDimView];
	self.clipToPlaylist = nil;
	switch (segmentedControl.selectedSegmentIndex) {
			case 0:			
			 [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=clip&action=getPremierClips" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self];
			break;
		case 1:			
			 [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=clip&action=getLatestClips" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self]; 
			break;
		case 2:
			 [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=clip&action=getPopularClips" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self];
			break;	
		case 3:
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=genre&action=getAllGenres" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"genres"] delegate:self]; 
			break;	
	}
}

#pragma mark - Table view data source
 
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (!self.clipToPlaylist) {
		return 0;
	}	
	return 155;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (!self.clipToPlaylist) {
		return nil;
	}
	AsyncImageView* _videoThumb = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, 5, 112, 69)];
	
	if (self.clipToPlaylist.thumb && ![self.clipToPlaylist.thumb isKindOfClass:[NSNull class]])  _videoThumb.image = self.clipToPlaylist.thumb;
	else [_videoThumb loadImageFromURL:[NSURL URLWithString:self.clipToPlaylist.clipImageURL]];

	UIImageView* header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 155)];
	[header setUserInteractionEnabled:YES];
	[header setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	[header addSubview:_videoThumb];
	
	UIButton* repeatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[repeatButton setTitle:@"Еще раз" forState:UIControlStateNormal];
	[repeatButton setFrame:CGRectMake(10, 80, 70, 30)];
	[repeatButton setImage:[UIImage imageNamed:@"OnceMoreWhite.png"] forState:UIControlStateNormal];
	[repeatButton setImage:[UIImage imageNamed:@"OnceMore.png"] forState:UIControlStateSelected];
	[repeatButton addTarget:self action:@selector(repeatClip) forControlEvents:UIControlEventTouchUpInside];
	[header addSubview:repeatButton];
	
	UIButton* addToPlaylistButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[addToPlaylistButton setFrame:CGRectMake(255, header.frame.size.height / 2 - 32 / 2, 27, 32)];
	[addToPlaylistButton setImage:[UIImage imageNamed:@"cellBtnAdd.png"] forState:UIControlStateNormal];
	[addToPlaylistButton addTarget:self action:@selector(addToPlaylist) forControlEvents:UIControlEventTouchUpInside];
	[header addSubview:addToPlaylistButton];
	
	UISegmentedControl* s = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, header.frame.size.height - 30, 320, 30)];
	[s setSegmentedControlStyle:UISegmentedControlStyleBar];
	[s setTintColor:[UIColor darkGrayColor]];
	[s insertSegmentWithTitle:@"Похожие клипы" atIndex:0 animated:NO];
//	[s insertSegmentWithTitle:@"Информация" atIndex:1 animated:NO];
	[s setSelectedSegmentIndex:0];
	[s setMomentary:YES];
	[s addTarget:self action:@selector(segmentHeaderTapped:) forControlEvents:UIControlEventValueChanged];
	[header addSubview:s];
	[s release];
	
	return [header autorelease];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([[_dataSource objectAtIndex:_segment.selectedSegmentIndex] isKindOfClass:[NSNull class]] ) {
	
		return 0;
	}
    return [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] clips] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    VideoTableViewCell *cell = (VideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    Clip* clip = [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] clips] objectAtIndex:indexPath.row]; 
	
	[cell setClipDelegate:self];
	[cell configCellByClip:clip];
	[cell setClipNumber:indexPath.row];
//    NSLog([clip.artistId stringValue]);
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	    
	Clip* clip = [[[_dataSource objectAtIndex:_segment.selectedSegmentIndex] clips] objectAtIndex:indexPath.row]; 
	
	NSURL* prerollURL = nil;
	if ((prerollURL = [AVPlayerDemoPlaybackViewController hasPreroll])) {
		
		AVPlayerDemoPlaybackViewController* tmp = [[AVPlayerDemoPlaybackViewController alloc] initWithClip:clip];
		[tmp setURL:prerollURL];
		[tmp setAvdelegate:self]; 
		[[__delegate window] addSubview:tmp.view]; 
	}
	else{
		self.clipToPlaylist = clip;
		PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithClip:self.clipToPlaylist];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
     
}

- (void)showClip:(NSInvocationOperation*)inv{
	PreviewViewController* tmp = (PreviewViewController*)[inv result]; 
	[self.navigationController pushViewController:tmp animated:YES];
	[tmp release];
	
}

- (void)segmentHeaderTapped:(UISegmentedControl*)segmentedControl{
	switch (segmentedControl.selectedSegmentIndex) {
		case 0:			
	[self showDimView];
			[[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/service.php?service=util&action=getAfterPlayClips&id=%d", [self.clipToPlaylist.clipID intValue]]
														 objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] 
															  delegate:self];
			self.clipToPlaylist = nil;
			break;
		case 1:			 
			break;
		case 2: 
			break;		
	}
}
- (void)repeatClip{	
	
	if ([PrerollViewController hasPreroll]) {

		PrerollViewController *detailViewController = [[PrerollViewController alloc] initWithClip:self.clipToPlaylist]; 
		[detailViewController setPrerollDelegate:self];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
	else{
		PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithClip:self.clipToPlaylist];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
}
- (void)search:(id)sender{
	SearchViewController *detailViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil mode:kClip]; 
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}
- (void)addToPlaylist{
	
	[self addToPlaylist:self.clipToPlaylist];

}
- (void)addToPlaylist:(Clip*)clip{
	
	self.clipToPlaylist = clip;
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Добавить это видео в..." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Новый плейлист", nil];
	for (PlayList* pl in [[__delegate playlists] playlists]) {
		[actionSheet addButtonWithTitle:pl.playlistName];
	}
	[actionSheet addButtonWithTitle:@"Отмена"];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	 [actionSheet release];
	
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSLog(@"button index is %d", buttonIndex);
	if (buttonIndex == [actionSheet numberOfButtons] - 1) return;
	if (buttonIndex == 0) {
		
		PlayList* playList = [PlayList new];
		[MKEntryPanel showPanelWithTitle:NSLocalizedString(@"Название листа", @"") 
								  inView:self.view 
						   onTextEntered:^(NSString* enteredString)
		 {
		
		 playList.playlistName = enteredString;
		 [[__delegate playlists] addPlaylist:playList];

		 }];
		[[playList clips] addObject:clipToPlaylist];
		[playList release];
		self.clipToPlaylist = nil;
	}else{
		PlayList* myPlaylist = [[[__delegate playlists] playlists] objectAtIndex:buttonIndex - 1];
		[[myPlaylist clips] addObject:clipToPlaylist];
		self.clipToPlaylist = nil;
		[[__delegate playlists] save];
	}
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	if ([[_dataSource objectAtIndex:_segment.selectedSegmentIndex] isKindOfClass:[NSNull class]] ) {
		[_dataSource insertObject:[objects objectAtIndex:0] atIndex:_segment.selectedSegmentIndex];
	}
	[self hideDimView];
	[_tableView reloadData]; //Sections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}

- (void)dealloc{
	
	
	[_segment release];
	
    [super dealloc];
}

@end
