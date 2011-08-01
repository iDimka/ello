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

@interface PlayListViewController : RootViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, RKObjectLoaderDelegate>{
    UITableView*		_tableView;
    NSMutableArray*		_dataSource;
}

@property(nonatomic, assign)PlaylistStorePlace		mode;
@property(nonatomic, retain)PlayList*				playlist;

@end
