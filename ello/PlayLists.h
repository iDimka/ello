//
//  PlayLists.h
//  ello
//
//  Created by Dmitry Sazanovich on 27/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlayList;

@interface PlayLists : NSObject

@property(nonatomic, retain)NSString*	status;
@property(nonatomic, retain)NSMutableArray* playlists;

- (void)addPlaylist:(PlayList*)playlist;
- (void)removePlaylist:(PlayList*)playlist;

@end
