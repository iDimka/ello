//
//  GanrObject.m
//  ello
//
//  Created by Dmitry Sazanovich on 28/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "GanrObject.h"


@implementation GanrObject

@synthesize title = _title;
@synthesize ganrName = _ganrName;
@synthesize ganrCount = _ganrCount;
@synthesize ganrURL = _ganrURL;


- (void)dealloc {
    
	[_ganrURL release];
	
    [super dealloc];
}
@end
