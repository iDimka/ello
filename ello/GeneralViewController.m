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
- (void)InesrtViewInCantainer;
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
    _galleryDataSource = [[NSMutableArray alloc] init];
    _ViewDataContainer = [[NSMutableArray alloc] init];
    
	[self fake];
	[self InesrtViewInCantainer];
    
	adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
	adView.frame = CGRectOffset(adView.frame, 0, -50);
	adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
	adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	adView.delegate=self;
	[self.view addSubview:adView]; 
	[_scrollView setContentSize:CGSizeMake(320 * 3, 290)];
    [_scrollView setContentOffset:CGPointMake(320, 0) animated:NO];
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	_slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(slideshow:) userInfo:nil repeats:YES];
    
	[_pageControl setNumberOfPages:[_galleryDataSource count]];

}
- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	
	if ([_slideshowTimer isValid])
		{
        [_slideshowTimer invalidate];
		} 
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
    if ([_slideshowTimer isValid])
    {
        [_slideshowTimer invalidate];
    } 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(slideshow:) userInfo:nil repeats:YES]; 
        if ([_scrollView contentOffset].x == 320) return;
    
    if (([_scrollView contentOffset].x == 0) )
    {
        if ([_pageControl currentPage] == 0) {
            [_pageControl setCurrentPage:[_galleryDataSource count]];
        }
        else {
            [_pageControl setCurrentPage:[_pageControl currentPage]-1];   
        }
        [self SlideToLeft];
    }
    else
    {
        if ([_pageControl currentPage] == [_galleryDataSource count] - 1) {
            [_pageControl setCurrentPage:0];            
        }
        else 
        {
            [_pageControl setCurrentPage:[_pageControl currentPage]+1];   
        }
        [self SlideToRight];
    }
    
} 


- (void)slideshow:(NSTimer*)timer{
    if ([_pageControl currentPage] < [_galleryDataSource count]-1)
    {
        if (1) {
            [_pageControl setCurrentPage:[_pageControl currentPage]+1];   
            [UIView animateWithDuration:0.6 animations:^(void) {
                [_scrollView setContentOffset:CGPointMake([_scrollView contentOffset].x +320, 0) animated:0];
            } completion:^(BOOL finished) {
                [self SlideToRight];
            }];
        }
    } else {
        [_pageControl setCurrentPage:0];
        [UIView animateWithDuration:1 animations:^(void) {
            [_scrollView setContentOffset:CGPointMake([_scrollView contentOffset].x +320, 0) animated:0];
        } completion:^(BOOL finished) {
            [self SlideToRight];
        }];
    }  
    
}
-(void)InesrtViewInCantainer{
    for (int ind = 0; ind < 3; ind++) 
    {
	    UIImageView* tmp = [[UIImageView alloc] initWithFrame:CGRectMake(ind * 320, 0, 320, 290)];
        [tmp setBackgroundColor:[UIColor redColor]] ;//] colorWithRed:(float)(arc4random() % 100 /100) green:(float)(arc4random() % 100 /100) blue:(float)(arc4random() % 100 /100) alpha:1]];
        if (ind == 0) {
            [tmp setImage:[_galleryDataSource objectAtIndex:[_galleryDataSource count]-1]];
        }
        else if (ind == 1){
            [tmp setImage:[_galleryDataSource objectAtIndex:0]];
        }
        else if (ind == 2){
            [tmp setImage:[_galleryDataSource objectAtIndex:1]];
        }
		[_ViewDataContainer addObject:tmp];
        [_scrollView addSubview:tmp];
		[tmp release];
	}  
}


- (void)fake{
	for (int ind = 0; ind < 12; ind++) 
    {
        NSString* imageName = [NSString stringWithFormat:@"photo%i.png", ind % 3 + 1];
		[_galleryDataSource addObject:[UIImage imageNamed:imageName]];
        
	}
}
- (void)search{
	SearchViewController *detailViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil]; 
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

-(void) SlideToLeft{    
    int leftPage;
    int rightPage;
    
    leftPage = ([_pageControl currentPage]-1);
    if (leftPage == -1) leftPage = [_galleryDataSource count] -1;
    
    rightPage = ([_pageControl currentPage]+1);
    if (rightPage==[_galleryDataSource count]) {
        rightPage = 0;
    }

    [_pageControl setCurrentPage:_pageControl.currentPage % [_galleryDataSource count]];
    
    UIImageView* tmp;
    [_scrollView setContentOffset:CGPointMake(320, 0)  animated:NO];
    [_ViewDataContainer exchangeObjectAtIndex:0 withObjectAtIndex:1];
    
    tmp = [_ViewDataContainer objectAtIndex:0];
    [tmp setFrame:CGRectMake(0, 0, 320, 290)];
    [tmp setImage:[_galleryDataSource objectAtIndex:leftPage]];
    
    tmp = [_ViewDataContainer objectAtIndex:1];  
    [tmp setFrame:CGRectMake(320, 0, 320, 290)];
    [tmp setImage:[_galleryDataSource objectAtIndex:_pageControl.currentPage]];
    
    tmp = [_ViewDataContainer objectAtIndex:2];
    [tmp setImage:[_galleryDataSource objectAtIndex:rightPage]];
    [tmp setFrame:CGRectMake(640, 0, 320, 290)];
    
}

-(void) SlideToRight{
    int leftPage;
    int rightPage;
    
    leftPage = ([_pageControl currentPage]-1);
    if (leftPage == -1) leftPage = [_galleryDataSource count] -1;
    
    rightPage = ([_pageControl currentPage]+1);
    if (rightPage==[_galleryDataSource count]) {
        rightPage = 0;
    }
    
    [_pageControl setCurrentPage:_pageControl.currentPage % [_galleryDataSource count]];
    UIImageView* tmp;
    [_scrollView setContentOffset:CGPointMake(320, 0)  animated:NO];
    [_ViewDataContainer exchangeObjectAtIndex:1 withObjectAtIndex:2];
    
    tmp = [_ViewDataContainer objectAtIndex:0];
    [tmp setFrame:CGRectMake(0, 0, 320, 290)];
    [tmp setImage:[_galleryDataSource objectAtIndex:leftPage]];
    
    tmp = [_ViewDataContainer objectAtIndex:2];
    [tmp setFrame:CGRectMake(320, 0, 320, 290)];
    [tmp setImage:[_galleryDataSource objectAtIndex:_pageControl.currentPage]];
    
    tmp = [_ViewDataContainer objectAtIndex:1];  
    [tmp setFrame:CGRectMake(640, 0, 320, 290)];
    [tmp setImage:[_galleryDataSource objectAtIndex:rightPage]];
    
}



- (void)dealloc{
    [super dealloc];
}

@end
