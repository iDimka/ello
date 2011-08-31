//
//  TimelineViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 29/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "TimelineViewController.h"

#import "SecondLineView.h"

@interface TimelineViewController()

@property (nonatomic , readonly) float rightmostPointOnTrack;
@property (nonatomic , readonly) float leftmostPointOnTrack;

-(void) createGestureRecognizers;

@end

@implementation TimelineViewController

@synthesize dataSource;
@synthesize leftmostPointOnTrack;
@synthesize rightmostPointOnTrack;

- (id)init{
    self = [super init];
    if (self) {
		
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.userInteractionEnabled = YES;
		// Initialization code here.
		_timeLineView = [[SecondLineView alloc] initWithFrame:CGRectMake(0, 10, 200, 20)];
		[self addSubview:_timeLineView];
		[_timeLineView setDataSource:dataSource];
		
		_thumbOne = [[SliderThumbView alloc] init];
		[_thumbOne setCenter:(CGPoint){5, 10}];
		[_timeLineView addSubview:_thumbOne];
		
		[self createGestureRecognizers];
		_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    }
    return self;
}
- (void)tick:(NSTimer*)timer{
	//	NSLog(@"%f:%f", dataSource.duration, dataSource.playableDuration);
	if (!dataSource || _thumbOne.canFollowTime == NO) return;
	if (dataSource.duration == dataSource.currentPlaybackTime) [timer invalidate];
	[_thumbOne setCenter:CGPointMake(self.frame.size.width / dataSource.duration * dataSource.currentPlaybackTime, self.frame.size.height / 2)];
 	
}
- (void)setDataSource:(MPMoviePlayerController *)dataS{
	dataSource = dataS;
	
	[_timeLineView setDataSource:dataSource];
	if (!dataSource && [_timer isValid]) {
		[_timer invalidate];
		_timer = nil;
	}
}

-(void) createGestureRecognizers{
	UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	[_thumbOne addGestureRecognizer:pgr];
	[pgr release];
	 
}
-(void) handlePan:(UIPanGestureRecognizer *)recognizer{
	SliderThumbView *sender = (SliderThumbView *)recognizer.view;
	NSLog(@"%d", recognizer.state);
	if (recognizer.state == UIGestureRecognizerStateChanged)
		{
		
		sender.canFollowTime = NO;
        CGPoint translation = [recognizer translationInView:self]; 
        CGFloat newXPoint = sender.center.x + translation.x; 
		CGPoint p = {newXPoint, 10};
		if (!CGRectContainsPoint(_timeLineView.frame, p))  return; 
		sender.center = p;
        [recognizer setTranslation:CGPointZero inView:self];
	 
		}
	if (recognizer.state == UIGestureRecognizerStateEnded)
		{
		
        CGPoint translation = [recognizer translationInView:self]; 
        CGFloat newXPoint = sender.center.x + translation.x; 
		CGPoint p = {newXPoint, 10};
		if (!CGRectContainsPoint(_timeLineView.frame, p)) return; 
		dataSource.currentPlaybackTime =   dataSource.duration * newXPoint / _timeLineView.frame.size.width;
		NSLog(@"%f:%f %f", _timeLineView.frame.size.width, dataSource.duration,  dataSource.duration * newXPoint / _timeLineView.frame.size.width);
		sender.center = p;
        [recognizer setTranslation:CGPointZero inView:self];
		sender.canFollowTime = YES;
		}
	if (recognizer.state == UIGestureRecognizerStateCancelled)
		{
		sender.canFollowTime = YES;
		}
}
-(float) leftmostPointOnTrack{
	return leftmostPointOnTrack =  self.frame.origin.x;
}
-(float) rightmostPointOnTrack{
	return self.frame.origin.x + self.frame.size.width;
}



@end
