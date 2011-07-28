//
//  SlideshowImageView.m
//  ello
//
//  Created by Dmitry Sazanovich on 28/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "SlideshowImageView.h"

@implementation SlideshowImageView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

	if ([delegate respondsToSelector:@selector(touchedInView:)]) {
		[delegate touchedInView:self];
	}
	
}


@end
