//
//  AdView.h
//  eBuddy
//
//  Created by Dmitry Sazanovich on 05/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdView;

@protocol AdViewDelegate <NSObject>

- (void)bannerViewDidLoadAd:(AdView *)banner;
- (void)bannerViewDidError:(AdView *)banner;

@end

@interface AdView : UIImageView {
    NSTimer*		o_reloadTimer;
	NSTimeInterval	o_repeatTime;
	NSURL*			o_adURL;
	UILabel*		o_textAdLabel;
	UIWebView*		o_htmlAdWebView;
	
	IBOutlet	id<AdViewDelegate>	o_bannerDelegate;
}

@property(nonatomic, assign)id<AdViewDelegate> delegate;
@property(nonatomic, retain)NSURL*	adURL;

- (id)initWithDelegate:(id)delegate;
+ (id)showInView:(UIView*)view withDelegate:(id)delegate;

@end
