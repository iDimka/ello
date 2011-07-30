//
//  Clips.h
//  ello
//
//  Created by Dmitry Sazanovich on 26/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Clip;

@interface Clips : NSObject<NSCoding>

@property(nonatomic, retain)NSString*	status;
@property(nonatomic, retain)NSMutableArray* clips;

- (void)addClip:(Clip*)clip;
- (void)removeClip:(Clip*)clip;

@end
