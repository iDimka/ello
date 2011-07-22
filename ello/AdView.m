//
//  AdView.m
//  eBuddy
//
//  Created by Dmitry Sazanovich on 05/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "AdView.h"


@implementation AdView

@synthesize adURL = o_adURL;
@synthesize delegate = o_bannerDelegate;

+ (id)showInView:(UIView*)view withDelegate:(id)delegate{
	AdView* adView = [[AdView alloc] initWithDelegate:delegate];
	[view addSubview:adView];
	
	if ([adView.delegate respondsToSelector:@selector(bannerViewDidLoadAd:)]) 
		{
		[adView.delegate bannerViewDidLoadAd:adView];
		} 
	
	return adView;
}
 
- (id)initWithDelegate:(id)delegate{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 50)];
    if (self) {
		
		o_bannerDelegate = delegate;
		[self setBackgroundColor:[UIColor greenColor]];
		 
    }
	
	o_reloadTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reload:) userInfo:nil repeats:YES];
	
    return self;
}

- (void)reload:(NSTimer*)timer{ 
	
	[UIView transitionWithView:self duration:.5 options:arc4random() % 4 << 20  animations:^(void) { } completion:^(BOOL finished) { }];
		
}
 
- (void)dealloc{
	[o_adURL release];
	
    [super dealloc];
}

@end
