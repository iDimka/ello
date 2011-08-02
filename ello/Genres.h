//
//  Ganri.h
//  ello
//
//  Created by Dmitry Sazanovich on 28/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Genres : NSObject {
	NSMutableArray* _genres;
}
@property(nonatomic, retain)NSMutableArray* genres;
@property(nonatomic, copy)NSString*	status;

@end
