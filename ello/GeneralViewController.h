//
//  GeneralViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 08/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <iAd/iAd.h>
 
@interface GeneralViewController : UIViewController <UIScrollViewDelegate, ADBannerViewDelegate>{
	IBOutlet	UIScrollView*	_scrollView;
	IBOutlet	UIImageView*	_banner;
//	IBOutlet	UIImageView*	_centerImage;
//	IBOutlet	UIImageView*	_leftImage;
//	IBOutlet	UIImageView*	_rightImage;
	IBOutlet	UIPageControl*	_pageControl;
    IBOutlet    UILabel*        _artistName1Label;
    IBOutlet    UILabel*        _artistName2Label;
	
	NSTimer*					_slideshowTimer;
	NSInteger					_position;
	NSInteger					_prevPosition;	
	BOOL						o_bannerIsVisible; 
	NSMutableArray*             _ViewDataContainer;
	NSMutableArray*				_galleryDataSource;
	
	ADBannerView				*adView;
	BOOL bannerIsVisible;
 
}

- (IBAction)search;


@end
