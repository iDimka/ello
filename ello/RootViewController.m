#import "RootViewController.h"

#import <QuartzCore/QuartzCore.h>

typedef void (^CloseBlock)(NSString *inputString);

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kAnimationDuration 0.35

@interface _DimView : UIView {
    
    SEL onTapped;
    id _parent;
}
@end

@implementation _DimView

- (id)initWithParent:(id) parent onTappedSelector:(SEL) tappedSel{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    if (self) {
        // Initialization code
        _parent = parent;
        onTapped = tappedSel;
        self.backgroundColor = [UIColor darkGrayColor];
        self.alpha = 0.4;
		self.userInteractionEnabled = NO;
		
		UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[act setCenter:self.center];
		[self addSubview:act];
		[act startAnimating];
		[act release];
		
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [_parent performSelector:onTapped];
}
- (void)dealloc{
    [super dealloc];
}

@end

@implementation RootViewController
 
- (void)viewDidLoad{
    [super viewDidLoad];
	 
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
 
} 
 

- (UIBarButtonItem *) barButtonItemWithSel:(SEL)selector target:(id)target image:(UIImage*)image {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );    
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];    
	UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	return [actionButton autorelease];
}
- (UIBarButtonItem *) barButtonItemWithSel:(SEL)selector target:(id)target image:(UIImage*)image title:(NSString*)title{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
	button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height);    
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];    
	UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	return [actionButton autorelease];
}

- (void) setHiddenTabbar:(BOOL)flag{
	
	[[[__delegate tabBarController] tabBar] setHidden:YES];

}
- (void)showDimView{
	if (!o_dimView)
		{
		o_dimView = [[_DimView alloc] initWithParent:self onTappedSelector:nil];
		}
	[self.view addSubview:o_dimView];
}
- (void)hideDimView{ 
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromTop;
	[o_dimView.layer addAnimation:transition forKey:nil];
    o_dimView.frame = CGRectMake(0, -o_dimView.frame.size.height, 320, o_dimView.frame.size.height); 
    
    transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	o_dimView.alpha = 0.0;
	[o_dimView.layer addAnimation:transition forKey:nil];
    
    [o_dimView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.40]; 
}
 

@end
