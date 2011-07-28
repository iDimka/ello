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

@interface SearchViewController : UITableViewController <RKObjectLoaderDelegate>{
    
	RKObjectMapping*			_clipsMapping;
	NSMutableArray*				_dataSource;
}

@property(nonatomic, assign)SearchMode mode;

@end
