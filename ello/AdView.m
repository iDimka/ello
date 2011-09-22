//
//  AdView.m
//  eBuddy
//
//  Created by Dmitry Sazanovich on 05/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "AdView.h"


@implementation AdView

@synthesize name;
@synthesize bannerID;
@synthesize bannerImage;
@synthesize url;
@synthesize viewCount;
@synthesize action;

@synthesize adURL = o_adURL;
@synthesize addelegate = o_bannerDelegate;

+ (id)showInView:(UIView*)view withDelegate:(id)delegate{
	AdView* adView = [[AdView alloc] initWithDelegate:delegate];
	[view addSubview:adView];
 
	return [adView autorelease];
}
 
- (id)initWithDelegate:(id)delegate{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 50)];
    if (self) {
		
		o_bannerDelegate = delegate;
		self.userInteractionEnabled = YES;
		
		UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPin:)];
		[tapRecognizer setNumberOfTapsRequired:1];
		[self addGestureRecognizer:tapRecognizer];
		
		[self setBackgroundColor:[UIColor greenColor]];
		o_reloadTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reload:) userInfo:nil repeats:YES];
		 
    } 
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
		
		UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPin:)];
		[tapRecognizer setNumberOfTapsRequired:1];
		[self addGestureRecognizer:tapRecognizer];
    }
    return self;
} 

- (void)addPin:(UIGestureRecognizer *)gestureRecognizer{ 
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:action]];	
}
- (void)reload:(NSTimer*)timer{ 
	
	[UIView transitionWithView:self duration:.5 options:arc4random() % 4 << 20  animations:^(void) { } completion:^(BOOL finished) { }];
		
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	[super connectionDidFinishLoading:theConnection];
	
	if ([o_bannerDelegate respondsToSelector:@selector(bannerViewDidLoadAd:)]) 
		{
		[o_bannerDelegate bannerViewDidLoadAd:self];
		} 
	
}
- (void)setDelegate:(id)sender{
	o_bannerDelegate = sender;
}
- (void)setUrl:(NSString*)s{
	if (s != url) {
		[url release];
		url = [s retain];
		self.adURL = [NSURL URLWithString:url];
	}
}

- (void)loadAdvert{
	
	[self loadImageFromURL:o_adURL];
}

- (void)dealloc{
	[o_adURL release];
	
    [super dealloc];
}

@end
