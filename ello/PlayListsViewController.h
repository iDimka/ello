//
//  PlayListViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootViewController.h"

@interface PlayListsViewController : RootViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate> {
    
	UITableView*		_tableView;
    NSMutableArray*		_dataSourceCharts;
	NSMutableArray*		_dataSourceTop;
	NSMutableArray*		_dataSourceMy;
	RKObjectMapping*	_clipsMapping;
	
	UISegmentedControl*	_segment;
}

@end
