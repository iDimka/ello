//
//  ViewViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 08/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootViewController.h"

@class ClipsParser;

@interface VideoViewController : RootViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate>{
	ClipsParser*			_clipsParser;
	IBOutlet UITableView*	_tableView;
	NSMutableArray*			_dataSource;
	UISegmentedControl*		_segment;
	
	RKObjectMapping* _clipsMapping;
}

- (IBAction)search:(id)sender;

@end
