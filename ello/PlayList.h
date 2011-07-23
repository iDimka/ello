//
//  PlayList.h
//  ello
//
//  Created by Dmitry Sazanovich on 23/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayList : NSObject

@property(nonatomic, assign)NSInteger	artistID;
@property(nonatomic, copy)NSString*		artistName;
@property(nonatomic, copy)NSURL*		artistImage;

@end
