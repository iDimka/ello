//
//  ArtistViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 01/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ArtistViewController.h"

#import "MKEntryPanel.h"
#import "PlayList.h"
#import "PlayLists.h"
#import "PreviewViewController.h"
#import "Clip.h"
#import "Clips.h"
#import "Artist.h"
#import "asyncimageview.h"

#define paggin	20

@interface ArtistViewController()

@property(nonatomic, retain)Clip*				clipToPlaylist; 

- (NSString *) deleteHTMLTags:(NSString *)str;

@end

@implementation ArtistViewController

@synthesize clipToPlaylist;

- (id)initWithArtist:(Artist*)artist {
    self = [super init];
    if (self) {
        _artist = [artist retain];
		_dataSource =[NSMutableArray new];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
	
	_contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	_artistPhoto = [[AsyncImageView alloc] initWithFrame:CGRectMake(20, paggin, 280, 280)];
	[_artistPhoto setBackgroundColor:[UIColor darkGrayColor]];
	
	_artistTweets = [[UITextView alloc] initWithFrame:CGRectMake(20, _artistPhoto.frame.origin.y + _artistPhoto.frame.size.height + paggin, 280, 30)];
	_artistTweets.text = [self deleteHTMLTags:_artist.details];
	_artistTweets.textColor = [UIColor whiteColor];
	[_artistTweets setBackgroundColor:[UIColor clearColor]];  
	[_contentScroll addSubview:_artistTweets]; 
	[_artistTweets setFrame:CGRectMake(20, _artistPhoto.frame.origin.y + _artistPhoto.frame.size.height + paggin, 280, _artistTweets.contentSize.height)];
	NSLog(@"a d %@", _artistTweets);
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _artistTweets.frame.origin.y + _artistTweets.frame.size.height + paggin, 320, 1) style:UITableViewStylePlain];;
	[_contentScroll addSubview:_tableView];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setSeparatorColor:[UIColor darkGrayColor]];
	[_tableView setRowHeight:85];
	
	[self.view addSubview:_contentScroll];
	
	[_contentScroll addSubview:_artistPhoto];
	
	self.title = _artist.artistName;
	if (!(_artistPhoto.image = _artist.thumb))	[_artistPhoto loadImageFromURL:[NSURL URLWithString:_artist.artistImage]];
	
	[[RKObjectManager sharedManager] 
	 loadObjectsAtResourcePath:[NSString stringWithFormat:@"/service.php?service=clip&action=getClipsByArtistId&id=%d", [_artist.artistID intValue]] 
	 objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] 
	 delegate:self]; 
}  
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	[_contentScroll setContentSize:CGSizeMake(320, _tableView.frame.origin.y + _tableView.frame.size.height + paggin)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if (![_dataSource count]) {
		return 0;
	}
	
	[_tableView setFrame:CGRectMake(0, _artistTweets.frame.origin.y + _artistTweets.frame.size.height + paggin, 320, _tableView.rowHeight * [[[_dataSource objectAtIndex:0] clips] count])];	
	[_contentScroll setContentSize:CGSizeMake(320, _tableView.frame.origin.y + _tableView.frame.size.height + paggin)];
	NSLog(@"table superview is %@", [_tableView superview]);
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
	PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithClip:clip];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
}

- (void)addToPlaylist:(Clip*)clip{
	
	self.clipToPlaylist = clip;
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Добавить это видео в..." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Новый плейлист", nil];
	for (PlayList* pl in [[__delegate playlists] playlists]) {
		[actionSheet addButtonWithTitle:pl.name];
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
	}
}

- (NSString *) deleteHTMLTags:(NSString *)str{
    NSMutableString *ms = [NSMutableString stringWithCapacity:[str length]];
	
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    NSString *s = nil;
    while (![scanner isAtEnd])
		{
        [scanner scanUpToString:@"<" intoString:&s];
        if (s != nil)
            [ms appendString:s];
        [scanner scanUpToString:@">" intoString:NULL];
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation]+1];
        s = nil;
		} 
	
    return [[ms stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"\""] stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"\""];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	
	[_dataSource addObject:[objects objectAtIndex:0]];
	
	[self hideDimView];
	[_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}

@end
