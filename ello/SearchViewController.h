//
//  SearchViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	kNone,
	kArtist,
	kClip
}SearchMode;

@interface SearchViewController : RootViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate>{
    UITableView*				_tableView;
	NSMutableArray*				_dataSource;
}

@property(nonatomic, assign)SearchMode mode;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)bundle mode:(SearchMode)mode;

@end
