//
//  PlayListViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClipsViewController.h"

typedef enum{
	kNetwork,
	kLocalhost
}PlaylistStorePlace;

@class PlayList;

@interface PlayListViewController : RootViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, RKObjectLoaderDelegate, PlayListProtocol>{
    UITableView*		_tableView;
    NSMutableArray*		_dataSource;
	UILabel*			plClipsCount;
	PlayList*			_playList;
	PlayList*			_repeatPlayList;
}

@property(nonatomic, assign)PlaylistStorePlace		mode;
@property(nonatomic, retain)PlayList*				playlist;
@property(nonatomic, retain)PlayList*				repeatPlaylist;

@end
