//
//  ArtistViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 01/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoTableViewCell.h"

@class Artist;
@class AsyncImageView;

@interface ArtistViewController : RootViewController
<
UITableViewDelegate,
UITableViewDataSource,
PlayListProtocol,
RKObjectLoaderDelegate,
UIActionSheetDelegate
>{
	Artist*			_artist;
	UIScrollView*	_contentScroll;
	AsyncImageView*	_artistPhoto;
	UITextView*		_artistTweets;
	UITableView*	_tableView;;
	NSMutableArray*	_dataSource;
}

- (id)initWithArtist:(Artist*)artist;

@end
