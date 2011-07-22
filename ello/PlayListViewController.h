//
//  PlayListViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoViewController.h"

@interface PlayListViewController : UITableViewController <UIActionSheetDelegate>{
    
    NSMutableArray*		_dataSoutce;
}

@end
