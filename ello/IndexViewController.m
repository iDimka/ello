//
//  GeneralViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 08/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "IndexViewController.h"

#import "AVPlayerDemoPlaybackViewController.h"
#import "PrerollViewController.h"
#import "AdView.h"
#import "AdViews.h"
#import "PreviewViewController.h"
#import "SlideshowImageView.h"
#import "Clip.h"
#import "Clips.h"
#import "SearchViewController.h"

#define timerInterval	3
#define leftFrame		CGRectMake(0, 0, 320, 250)
#define centrFrame		CGRectMake(320, 0, 320, 250)
#define rightFrame		CGRectMake(640, 0, 320, 250)

@interface IndexViewController()

@property(nonatomic, retain)UIImageView* leftImage;
@property(nonatomic, retain)UIImageView* rightImage;
@property(nonatomic, retain)UIImageView* centerImage;

- (void)slideshow:(NSTimer*)timer;
- (void)InesrtViewInCantainer;
- (void)fake;
@end

@interface IndexViewController ()

-(void) SlideToRight;
-(void) SlideToLeft;
@end

@implementation IndexViewController

@synthesize leftImage;
@synthesize centerImage;
@synthesize rightImage;
 
#pragma mark - View lifecycle 

- (void)viewDidLoad{
    [super viewDidLoad];
	
	//http://themedibook.com/ello/services/service.php?service=clip&action=getIndexClips
	
	
    _ViewDataContainer = [[NSMutableArray alloc] init];
	
	_dataSource = [[NSMutableArray alloc] init];
     
    

 
	[_scrollView setContentSize:CGSizeMake(320 * 3, 250)];
    [_scrollView setContentOffset:CGPointMake(320, 0) animated:NO];
	  
	[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=clip&action=getIndexClips" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"clips"] delegate:self];
	 
	[_scrollView setUserInteractionEnabled:YES];
	
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if (![_slideshowTimer isValid]) {
		_slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(slideshow:) userInfo:nil repeats:YES];
		
	}
	[_pageControl setNumberOfPages:[_dataSource count]];
	[[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/service.php?service=banner&action=getBanner" objectMapping:[[RKObjectManager sharedManager].mappingProvider objectMappingForKeyPath:@"banners"] delegate:self]; 
	
}
- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	
	if ([_slideshowTimer isValid])
		{
        [_slideshowTimer invalidate];
		_slideshowTimer = nil;
		} 
}

- (void)bannerViewDidLoadAd:(AdView *)banner{
	[banner setFrame:CGRectMake(0, 367 - 50, 320, 50)];
	[self.view addSubview:banner];
}
- (void)bannerViewDidError:(AdView *)banner{
	
}

#pragma -
#pragma UIScrolViewDelgate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;{
    if ([_slideshowTimer isValid])
		{
        [_slideshowTimer invalidate];
		_slideshowTimer = nil;
		} 
	_isDid = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(slideshow:) userInfo:nil repeats:YES]; 
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
	_isDid = YES;
    
} 

- (void)InesrtViewInCantainer{
    for (int ind = 0; ind < 3; ind++) 
		{
	    SlideshowImageView* tmp = [[SlideshowImageView alloc] initWithFrame:CGRectMake(ind * 320, 0, 320, 250)];
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
 
	NSURL* prerollURL = nil;
	if ((prerollURL = [AVPlayerDemoPlaybackViewController hasPreroll])) {
		
		Clip* clip = [_dataSource objectAtIndex:_pageControl.currentPage]; 
		AVPlayerDemoPlaybackViewController* tmp = [[AVPlayerDemoPlaybackViewController alloc] initWithClip:clip]; 
		[tmp setURL:prerollURL];
		[tmp setAvdelegate:self]; 
		[[__delegate window] addSubview:tmp.view]; 
 
	}
	else{
		Clip* clip = [_dataSource objectAtIndex:_pageControl.currentPage]; 
		PreviewViewController *detailViewController = [[PreviewViewController alloc] initWithClip:clip]; 
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
	
	
}
- (void)showClip:(NSInvocationOperation*)inv{
	PreviewViewController* tmp = (PreviewViewController*)[inv result]; 
	[self.navigationController pushViewController:tmp animated:NO];
	[tmp release];
	
}

- (void)fake{
	for (int ind = 0; ind < 12; ind++) 
		{
        NSString* imageName = [NSString stringWithFormat:@"photo%i.png", ind % 3 + 1];
		[_dataSource addObject:[UIImage imageNamed:imageName]];
        
		}
}
- (void)search{
	SearchViewController *detailViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil mode:kClip]; 
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
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
- (void)SlideToLeft{    
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
    [tmp setFrame:CGRectMake(0, 0, 320, 250)];
    [tmp setImage:[[_dataSource objectAtIndex:leftPage] thumb]];
    
    tmp = [_ViewDataContainer objectAtIndex:1];  
    [tmp setFrame:CGRectMake(320, 0, 320, 250)];
    [tmp setImage:[[_dataSource objectAtIndex:_pageControl.currentPage] thumb]];
    
    tmp = [_ViewDataContainer objectAtIndex:2];
    [tmp setImage:[[_dataSource objectAtIndex:rightPage] thumb]];
    [tmp setFrame:CGRectMake(640, 0, 320, 250)];
	
	_artistName1Label.text = [(Clip*)[_dataSource objectAtIndex:_pageControl.currentPage] artistName];
	_clipNameLabel.text = [(Clip*)[_dataSource objectAtIndex:_pageControl.currentPage] clipName];
    
}
- (void)SlideToRight{
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
    [tmp setFrame:CGRectMake(0, 0, 320, 250)];
    [tmp setImage:[[_dataSource objectAtIndex:leftPage] thumb]];
    
    tmp = [_ViewDataContainer objectAtIndex:2];
    [tmp setFrame:CGRectMake(320, 0, 320, 250)];
    [tmp setImage:[[_dataSource objectAtIndex:_pageControl.currentPage] thumb]];
    
    tmp = [_ViewDataContainer objectAtIndex:1];  
    [tmp setFrame:CGRectMake(640, 0, 320, 250)];
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
		
 
		_artistName1Label.text = [(Clip*)[_dataSource objectAtIndex:_pageControl.currentPage] artistName];
		_clipNameLabel.text = [(Clip*)[_dataSource objectAtIndex:_pageControl.currentPage] clipName];
 }

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
//	NSLog(@"l %@\n\n", objects);
	if ([[objects objectAtIndex:0] isKindOfClass:[AdViews class]]) {
		adView =  [[[[objects objectAtIndex:0] banners] objectAtIndex:0] retain];
		[[[[objects objectAtIndex:0] banners] objectAtIndex:0] setAddelegate:self];
		[[[[objects objectAtIndex:0] banners] objectAtIndex:0] loadAdvert];
		return;
	}
	[_dataSource addObjectsFromArray:[[objects objectAtIndex:0] clips]]; 
		[self InesrtViewInCantainer];
	[(Clips*)[objects objectAtIndex:0] loadAllImages:^(BOOL isOK) {
		if (isOK) { 
			[[[UIApplication sharedApplication] delegate] performSelector:@selector(show)];
			
			[self SlideToRight];

		}
	}];
	
	
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString* tmp = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	NSLog(@"ERROR %@", tmp);
	
}

- (void)dealloc{
    [super dealloc];
}

@end
