//
//  AdView.h
//  eBuddy
//
//  Created by Dmitry Sazanovich on 05/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "asyncimageview.h"

@class AdView;

@protocol AdViewDelegate <NSObject>

- (void)bannerViewDidLoadAd:(AdView *)banner;
- (void)bannerViewDidError:(AdView *)banner;

@end

@interface AdView : AsyncImageView {
    NSTimer*		o_reloadTimer;
	NSTimeInterval	o_repeatTime;
	NSURL*			o_adURL;
	UILabel*		o_textAdLabel;
	UIWebView*		o_htmlAdWebView;
	
	IBOutlet	id<AdViewDelegate>	o_bannerDelegate;
	
}

@property(nonatomic, retain)NSString*	bannerID;
@property(nonatomic, retain)NSString*	name;
@property(nonatomic, retain)NSString*	bannerImage;
@property(nonatomic, retain)NSString*	url;
@property(nonatomic, retain)NSString*	viewCount;
@property(nonatomic, retain)NSString*	action;

@property(nonatomic, assign)id<AdViewDelegate> addelegate;
@property(nonatomic, retain)NSURL*	adURL;

- (void)load;
- (id)initWithDelegate:(id)delegate;
+ (id)showInView:(UIView*)view withDelegate:(id)delegate;

@end
