//
//  GeneralViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 08/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "GeneralViewController.h"

#import "SearchViewController.h"


#define leftFrame CGRectMake(0, 0, 320, 290)
#define centrFrame CGRectMake(320, 0, 320, 290)
#define rightFrame CGRectMake(640, 0, 320, 290)

@interface GeneralViewController()

@property(nonatomic, retain)UIImageView* leftImage;
@property(nonatomic, retain)UIImageView* rightImage;
@property(nonatomic, retain)UIImageView* centerImage;

- (void)slideshow:(NSTimer*)timer;
- (void)fake;
@end

@interface GeneralViewController ()

-(void) SlideToRight;
-(void) SlideToLeft;
@end

@implementation GeneralViewController

@synthesize leftImage;
@synthesize centerImage;
@synthesize rightImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle 

- (void)viewDidLoad{
    [super viewDidLoad];
	
    //	self.banner = [[AdView showInView:self.view withDelegate:self] retain]; 
	
//	adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
//	adView.frame = CGRectOffset(adView.frame, 0, -50);
//	adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
//	adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
//	adView.delegate=self;
//	[self.view addSubview:adView];
	
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
//	_slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(slideshow:) userInfo:nil repeats:YES];
	_galleryDataSource = [[NSMutableArray alloc] init];
	
	[self fake];
	[_pageControl setNumberOfPages:[_galleryDataSource count]];
	
	[_scrollView setContentSize:CGSizeMake(320 * 3, 290)];
	
	[_leftImage setFrame:CGRectMake(0, 0, 320, 290)];
	[_centerImage setFrame:CGRectMake(320, 0, 320, 290)];
	[_rightImage setFrame:CGRectMake(640, 0, 320, 290)];
    
//    self.leftImage = _leftImage;
//    self.centerImage = _centerImage;
//    self.rightImage = _rightImage;
    //    _tmpInt = -1;
}

#pragma mark -
#pragma mark ADBannerViewDelegate Protocol

- (void)bannerViewDidLoadAd:(ADBannerView *)bannerr{ 
	if (!bannerIsVisible)
    {
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL]; 
		bannerr.frame = CGRectMake(0, 317, 320, 50);
		[UIView commitAnimations];
		bannerIsVisible = YES;
		
    }
}
- (void)hideBanner: (ADBannerView *) bannerr  {
	
	if (bannerIsVisible)
    {
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL]; 
		bannerr.frame = CGRectMake(0, -50, 320, 50);
		[UIView commitAnimations];
		bannerIsVisible = NO;
    }
	
}
- (void)bannerView:(ADBannerView *)bannerr didFailToReceiveAdWithError:(NSError *)error{
	
	[self hideBanner:bannerr];
	
}

#pragma -
#pragma UIScrolViewDelgate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;{
//    if ([_slideshowTimer isValid])
//    {
//        [_slideshowTimer invalidate];
//    } 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    _slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(slideshow:) userInfo:nil repeats:YES]; 
    _prevPosition = _position;
    _position = ([_scrollView contentOffset].x/320); 
    
    if (_prevPosition > _prevPosition )
    {
        [self SlideToLeft];    
        [_pageControl setCurrentPage:[_pageControl currentPage]-1];
    }
    else
    {
        [self SlideToRight];
        [_pageControl setCurrentPage:[_pageControl currentPage]+1];
    }
	
}

- (void)fake{
	for (int ind = 0; ind < 10; ind++) 
    {
		UIImageView* tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"photo%i.png", ind % 3]]];
		[_galleryDataSource addObject:tmp];
		[tmp release];
	}
}
- (void)slideshow:(NSTimer*)timer{
//    if ([_pageControl currentPage] < [_galleryDataSource count]-1) {
//        if (_prevPosition <= _position) {
//            [_pageControl setCurrentPage:[_scrollView contentOffset].x/320+1];
//            [_scrollView setContentOffset:CGPointMake([_scrollView contentOffset].x +320, 0) animated:YES];
//            [self SlideToRight];
//        } else _position = _prevPosition;
//    } else {
//        [_scrollView setContentOffset:CGPointMake(0, 0)];
//        [_pageControl setCurrentPage:0];
//        [self slideshow:timer];
//        
//    }  
	
    
    //    if (([_scrollView contentOffset].x / 320) < [_galleryDataSource count]-1) 
    //
    //    {
    //		
    //		if (_tmpInt <= _position)  {
    //            
    //            [_pageControl setCurrentPage:[_scrollView contentOffset].x / 320 + 1];
    //            
    //            [_scrollView setContentOffset:CGPointMake([_scrollView contentOffset].x + 320, 0)  animated:YES];
    //        } else _position= _tmpInt;   
    //    }else{
    //        [_scrollView setContentOffset:CGPointMake(0, 0)];
    //        [_pageControl setCurrentPage:0];
    //        [self slideshow:timer];
    //        
    //    }
    
} 
- (void)search{
	SearchViewController *detailViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil]; 
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}
- (void) SlideToLeft{
    if ((_leftImage.frame.origin.x > _centerImage.frame.origin.x) && (_leftImage.frame.origin.x > _rightImage.frame.origin.x))
    {  if (_rightImage.frame.origin.x < _centerImage.frame.origin.x)
    {  
        [_leftImage setFrame:centrFrame];
        [_centerImage setFrame:leftFrame];
    }
    else 
    {
        [_leftImage setFrame:centrFrame];
        [_rightImage setFrame:leftFrame];
    };
    }
    else if (((_rightImage.frame.origin.x > _centerImage.frame.origin.x) && (_rightImage.frame.origin.x > _leftImage.frame.origin.x)))
    { 
        if (_leftImage.frame.origin.x < _centerImage.frame.origin.x)
        {  
            [_rightImage setFrame:centrFrame];
            [_centerImage setFrame:leftFrame];
        }
        else 
        {
            [_rightImage setFrame:centrFrame];
            [_leftImage setFrame:leftFrame];
        };
    }
    else if (((_centerImage.frame.origin.x > _rightImage.frame.origin.x) && (_centerImage.frame.origin.x > _leftImage.frame.origin.x)))
    {
        if (_leftImage.frame.origin.x < _rightImage.frame.origin.x)
        {  
            [_centerImage setFrame:centrFrame];
            [_rightImage setFrame:leftFrame];
        }
        else 
        {
            [_centerImage setFrame:centrFrame];
            [_leftImage setFrame:leftFrame];
        };
    };    
}

- (void) SlideToRight{

    self.rightImage = self.centerImage;
    
    self.centerImage = _rightImage;
    
    
//    if (CGRectEqualToRect(_leftImage.frame, centrFrame)) {
//        _leftImage.frame = leftFrame;
//        switch ((int)_centerImage.frame.origin.x) {
//            case 0:
//                __centerImage.frame = centrFrame;
//                break;
//                case 320:
//        }
//    }
    
//    if ((_leftImage.frame.origin.x > _centerImage.frame.origin.x) && (_leftImage.frame.origin.x > _rightImage.frame.origin.x))
//    {  if (_rightImage.frame.origin.x < _centerImage.frame.origin.x)
//    {  
//        [_rightImage setFrame:centrFrame];
//        [_centerImage setFrame:rightFrame];
//    }
//    else 
//    {
//        [_rightImage setFrame:rightFrame];
//        [_centerImage setFrame:centrFrame];
//    };
//    }
//    else if (((_rightImage.frame.origin.x > _centerImage.frame.origin.x) && (_rightImage.frame.origin.x > _leftImage.frame.origin.x)))
//    { 
//        if (_leftImage.frame.origin.x < _centerImage.frame.origin.x)
//        {  
//            [_leftImage setFrame:centrFrame];
//            [_centerImage setFrame:rightFrame];
//        }
//        else 
//        {
//            [_leftImage setFrame:rightFrame];
//            [_centerImage setFrame:centrFrame];
//        };
//    }
//    else if (((_centerImage.frame.origin.x > _rightImage.frame.origin.x) && (_centerImage.frame.origin.x > _leftImage.frame.origin.x)))
//    {
//        if (_leftImage.frame.origin.x < _rightImage.frame.origin.x)
//        {  
//            [_leftImage setFrame:centrFrame];
//            [_centerImage setFrame:rightFrame];
//        }
//        else 
//        {
//            [_leftImage setFrame:rightFrame];
//            [_centerImage setFrame:centrFrame];
//        };
//    };
}



- (void)dealloc{
    [super dealloc];
}

@end
