//
//  GeneralViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 08/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "GeneralViewController.h"

#import "PreviewViewController.h"
#import "SlideshowImageView.h"
#import "Clip.h"
#import "Clips.h"
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
	
	//http://themedibook.com/ello/services/service.php?service=clip&action=getIndexClips
	
	
    _ViewDataContainer = [[NSMutableArray alloc] init];
	
	_dataSource = [[NSMutableArray alloc] init];
    
//	[self fake];

    
	adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
	adView.frame = CGRectOffset(adView.frame, 0, -50);
	adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
	adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	adView.delegate=self;
	[self.view addSubview:adView]; 
	[_scrollView setContentSize:CGSizeMake(320 * 3, 290)];
    [_scrollView setContentOffset:CGPointMake(320, 0) animated:NO];
	
 	[RKObjectManager objectManagerWithBaseURL:@"http://themedibook.com/ello/services"];
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Clip class]];
    [mapping mapKeyPathsToAttributes:
     @"clip.id",		@"clipID",
	 @"clip.artistId",	@"artistId",
	 @"clip.artistName",@"artistName",
  	 @"clip.genreId",	@"clipGanre",
  	 @"clip.genreName",	@"clipGanreName",
  	 @"clip.viewCount",	@"viewCount",
	 @"clip.name",		@"clipName",
	 @"clip.image",		@"clipImageURL",
 	 @"clip.video",		@"clipVideoURL",
  	 @"clip.label",		@"label", 
     nil];
	

	
	_clipsMapping = [[RKObjectMapping mappingForClass:[Clips class]] retain];
	[_clipsMapping mapKeyPathsToAttributes:
	 @"status", @"status",
	 nil];
	RKObjectRelationshipMapping* rel = [RKObjectRelationshipMapping mappingFromKeyPath:@"clips" toKeyPath:@"clips" objectMapping:mapping];
	[_clipsMapping addRelationshipMapping:rel];
	
	[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=clip&action=getIndexClips" objectMapping:_clipsMapping delegate:self]; 
	
	[_scrollView setUserInteractionEnabled:YES];
	
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	_slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(slideshow:) userInfo:nil repeats:YES];
    
	[_pageControl setNumberOfPages:[_dataSource count]];
	
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
            [_pageControl setCurrentPage:[_dataSource count]];
        }
        else {
            [_pageControl setCurrentPage:[_pageControl currentPage]-1];   
        }
        [self SlideToLeft];
		}
    else
		{
        if ([_pageControl currentPage] == [_dataSource count] - 1) {
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
    if ([_pageControl currentPage] < [_dataSource count]-1)
		{
        
		[_pageControl setCurrentPage:[_pageControl currentPage]+1];   
		[UIView animateWithDuration:0.6 animations:^(void) {
			[_scrollView setContentOffset:CGPointMake([_scrollView contentOffset].x +320, 0) animated:0];
		} completion:^(BOOL finished) {
			[self SlideToRight]; 

		}];
		
		} else 
			{
			[_pageControl setCurrentPage:0];
			[UIView animateWithDuration:1 animations:^(void) {
				[_scrollView setContentOffset:CGPointMake([_scrollView contentOffset].x +320, 0) animated:0];
			} completion:^(BOOL finished) {
				[self SlideToRight];
			}];
			

			}  
    
}
- (void)InesrtViewInCantainer{
    for (int ind = 0; ind < 3; ind++) 
		{
	    SlideshowImageView* tmp = [[SlideshowImageView alloc] initWithFrame:CGRectMake(ind * 320, 0, 320, 290)];
		tmp.delegate = self;
		[tmp setUserInteractionEnabled:YES];
        [tmp setBackgroundColor:[UIColor clearColor]] ;//] colorWithRed:(float)(arc4random() % 100 /100) green:(float)(arc4random() % 100 /100) blue:(float)(arc4random() % 100 /100) alpha:1]];
        if (ind == 0) {
            [tmp setImage:[[_dataSource objectAtIndex:[_dataSource count]-1] thumb]];
        }
        else if (ind == 1){
            [tmp setImage:[[_dataSource objectAtIndex:0] thumb]];
        }
        else if (ind == 2){
            [tmp setImage:[[_dataSource objectAtIndex:1] thumb]];
        }
		[_ViewDataContainer addObject:tmp];
        [_scrollView addSubview:tmp];
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, tmp.frame.size.height - 20, 100, 20)];
		[lbl setBackgroundColor:[UIColor blueColor]];
		[lbl setTag:777];
		[tmp addSubview:lbl];
		[lbl setHidden:YES];
		[lbl release];
		
		[tmp release];
		}  
}
- (void)touchedInView:(UIView*)view{
	Clip* clip = [_dataSource objectAtIndex:_pageControl.currentPage]; 
	PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithNibName:@"PreviewViewController" bundle:nil];
	detailViewController.clip = clip;
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

- (void)fake{
	for (int ind = 0; ind < 12; ind++) 
		{
        NSString* imageName = [NSString stringWithFormat:@"photo%i.png", ind % 3 + 1];
		[_dataSource addObject:[UIImage imageNamed:imageName]];
        
		}
}
- (void)search{
	SearchViewController *detailViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil]; 
	[detailViewController setMode:kClip];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

-(void) SlideToLeft{    
    int leftPage;
    int rightPage;
    
    leftPage = ([_pageControl currentPage]-1);
    if (leftPage == -1) leftPage = [_dataSource count] -1;
    
    rightPage = ([_pageControl currentPage]+1);
    if (rightPage==[_dataSource count]) {
        rightPage = 0;
    }
	
    [_pageControl setCurrentPage:_pageControl.currentPage % [_dataSource count]];
    
    UIImageView* tmp;
    [_scrollView setContentOffset:CGPointMake(320, 0)  animated:NO];
    [_ViewDataContainer exchangeObjectAtIndex:0 withObjectAtIndex:1];
    
    tmp = [_ViewDataContainer objectAtIndex:0];
    [tmp setFrame:CGRectMake(0, 0, 320, 290)];
    [tmp setImage:[[_dataSource objectAtIndex:leftPage] thumb]];
    
    tmp = [_ViewDataContainer objectAtIndex:1];  
    [tmp setFrame:CGRectMake(320, 0, 320, 290)];
    [tmp setImage:[[_dataSource objectAtIndex:_pageControl.currentPage] thumb]];
    
    tmp = [_ViewDataContainer objectAtIndex:2];
    [tmp setImage:[[_dataSource objectAtIndex:rightPage] thumb]];
    [tmp setFrame:CGRectMake(640, 0, 320, 290)];
	
	_artistName1Label.text = [[_dataSource objectAtIndex:_pageControl.currentPage] clipName];
    
}
-(void) SlideToRight{
    int leftPage;
    int rightPage;
    
    leftPage = ([_pageControl currentPage]-1);
    if (leftPage == -1) leftPage = [_dataSource count] -1;
    
    rightPage = ([_pageControl currentPage]+1);
    if (rightPage==[_dataSource count]) {
        rightPage = 0;
    }
    
    [_pageControl setCurrentPage:_pageControl.currentPage % [_dataSource count]];
    UIImageView* tmp;
    [_scrollView setContentOffset:CGPointMake(320, 0)  animated:NO];
    [_ViewDataContainer exchangeObjectAtIndex:1 withObjectAtIndex:2];
    
    tmp = [_ViewDataContainer objectAtIndex:0];
    [tmp setFrame:CGRectMake(0, 0, 320, 290)];
    [tmp setImage:[[_dataSource objectAtIndex:leftPage] thumb]];
    
    tmp = [_ViewDataContainer objectAtIndex:2];
    [tmp setFrame:CGRectMake(320, 0, 320, 290)];
    [tmp setImage:[[_dataSource objectAtIndex:_pageControl.currentPage] thumb]];
    
    tmp = [_ViewDataContainer objectAtIndex:1];  
    [tmp setFrame:CGRectMake(640, 0, 320, 290)];
    [tmp setImage:[[_dataSource objectAtIndex:rightPage] thumb]];
	
	
	[[_ViewDataContainer objectAtIndex:0] setImage:[[_dataSource objectAtIndex:leftPage] thumb]];
	if ([[[_dataSource objectAtIndex:leftPage] label] length]){
		[(UILabel*)[[_ViewDataContainer objectAtIndex:0] viewWithTag:777] setText:[(Clip*)[_dataSource objectAtIndex:leftPage] label]];
		[(UILabel*)[[_ViewDataContainer objectAtIndex:0] viewWithTag:777] setHidden:NO]; 
	}else [(UILabel*)[[_ViewDataContainer objectAtIndex:0] viewWithTag:777] setHidden:YES]; 
	
	[[_ViewDataContainer objectAtIndex:1] setImage:[[_dataSource objectAtIndex:rightPage] thumb]];
	if ([[[_dataSource objectAtIndex:rightPage] label] length]){
		[(UILabel*)[[_ViewDataContainer objectAtIndex:1] viewWithTag:777] setText:[[_dataSource objectAtIndex:rightPage] label]];
		[(UILabel*)[[_ViewDataContainer objectAtIndex:1] viewWithTag:777] setHidden:NO]; 
	}else [(UILabel*)[[_ViewDataContainer objectAtIndex:1] viewWithTag:777] setHidden:YES]; 
		
	[[_ViewDataContainer objectAtIndex:2] setImage:[[_dataSource objectAtIndex:_pageControl.currentPage] thumb]];
	if ([[[_dataSource objectAtIndex:_pageControl.currentPage] label] length]){
		[(UILabel*)[[_ViewDataContainer objectAtIndex:2] viewWithTag:777] setText:[[_dataSource objectAtIndex:_pageControl.currentPage] label]];
		[(UILabel*)[[_ViewDataContainer objectAtIndex:2] viewWithTag:777] setHidden:NO]; 
	}else [(UILabel*)[[_ViewDataContainer objectAtIndex:2] viewWithTag:777] setHidden:YES]; 
		
	
	_artistName1Label.text = [[_dataSource objectAtIndex:_pageControl.currentPage] clipName];
    
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[_dataSource removeAllObjects];
	[_dataSource addObjectsFromArray:[[objects objectAtIndex:0] clips]];
	//	[self hideDimView];
		[self InesrtViewInCantainer];
	[[[UIApplication sharedApplication] delegate] performSelector:@selector(show)];
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}


- (void)dealloc{
    [super dealloc];
}

@end
