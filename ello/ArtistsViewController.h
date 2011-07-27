//
//  ArtistsViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>
 
#import "RootViewController.h"

@interface ArtistsViewController : RootViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate> {
    
    NSMutableArray*		_dataSource;
	RKObjectMapping*	_clipsMapping;
	
	UISegmentedControl*	_segment;
	UITableView*		_tableView;
}

@end
