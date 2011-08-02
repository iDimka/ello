//
//  GanriViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 27/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "GanriTableViewCell.h"

@interface GenresViewController :  RootViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate>{
    NSMutableArray*		_dataSource;
    IBOutlet UITableView* _tableView;
}
    
- (IBAction)search:(id)sender;
    


@end
