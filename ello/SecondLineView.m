//
//  TimeLineView.m
//  ello
//
//  Created by Dmitry Sazanovich on 28/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "SecondLineView.h"

@implementation SecondLineView

@synthesize dataSource;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

		self.image = [[UIImage imageNamed:@"greyCircle.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = YES;
		
		_bufferedTime = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"whiteCircle.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4]];
		[self addSubview:_bufferedTime];
		
		_playedTime = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"blueCircle.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4]];
		[self addSubview:_playedTime];
		
		_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    
	}
    return self;
}

- (void)tick:(NSTimer*)timer{
//	NSLog(@"%f:%f", dataSource.duration, dataSource.playableDuration);
	if (!dataSource) return;
	if (dataSource.duration == dataSource.currentPlaybackTime) [timer invalidate];
	[_playedTime setFrame:CGRectMake(0, 0, self.frame.size.width / dataSource.duration * dataSource.currentPlaybackTime, self.frame.size.height)];
	[_bufferedTime setFrame:CGRectMake(0, 0, self.frame.size.width / dataSource.duration * dataSource.playableDuration, self.frame.size.height)];
	
}

- (void)dealloc {
	NSLog(@"%s", __func__);
    if ([_timer isValid]) {
		[_timer invalidate];
		[_timer release];
	}
	
    [super dealloc];
}

@end
