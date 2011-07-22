//
//  ArtistsViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>
 
#import "RootViewController.h"

@interface ArtistsViewController : RootViewController {
    NSMutableArray*		_dataSoutce;
	ArtistParser*		_artistParser;
	UITableView*		_tableView;
}

@end
