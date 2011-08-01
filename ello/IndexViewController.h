//
//  GeneralViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 08/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <iAd/iAd.h>
 
@interface IndexViewController : RootViewController <UIScrollViewDelegate, ADBannerViewDelegate, RKObjectLoaderDelegate>{
	IBOutlet	UIScrollView*	_scrollView;
	IBOutlet	UIImageView*	_banner; 
	IBOutlet	UIPageControl*	_pageControl;
    IBOutlet    UILabel*        _artistName1Label;
    IBOutlet    UILabel*        _clipNameLabel;
	
	NSTimer*					_slideshowTimer;
	NSInteger					_position;
	NSInteger					_prevPosition;	
	BOOL						o_bannerIsVisible; 
	NSMutableArray*             _ViewDataContainer;
	NSMutableArray*				_dataSource;
	
	ADBannerView				*adView;
	BOOL						bannerIsVisible;
	BOOL						_isDid;
	
	RKObjectMapping*			_clipsMapping;
}

- (IBAction)touchedInView:(UIView*)view;
- (IBAction)search;


@end
