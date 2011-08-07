//
//  ChannelsViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 07/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelsViewController :  RootViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate>{
    NSMutableArray*		_dataSource;
    IBOutlet UITableView* _tableView;
}

@end
