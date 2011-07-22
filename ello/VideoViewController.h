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

@interface VideoViewController : RootViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray*		_dataSource;
	ClipsParser*		_clipsParser;
	IBOutlet UITableView* _tableView;
}

- (IBAction)search:(id)sender;

@end
