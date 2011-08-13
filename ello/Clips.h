//
//  Clips.h
//  ello
//
//  Created by Dmitry Sazanovich on 26/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoadImages)(BOOL isOK);

@class Clip;

@interface Clips : NSObject<NSCoding>

@property (nonatomic, copy) LoadImages loadAllImages;
@property(nonatomic, retain)NSString*	status;
@property(nonatomic, retain)NSMutableArray* clips;

- (void)addClip:(Clip*)clip;
- (void)removeClip:(Clip*)clip;
- (void)loadAllImages:(LoadImages)block;

@end
