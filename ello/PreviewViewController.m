//
//  PreviewViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PreviewViewController.h"

#import "Clip.h"
#import "asyncimageview.h"
#import "PlayerViewController.h"

@implementation PreviewViewController

@synthesize thumbView;
@synthesize artistName;
@synthesize clipName;
@synthesize viewCount;
@synthesize clip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.thumbView loadImageFromURL:[self.clip clipImageURL]];
	[self.artistName setText:self.clip.artistName];
	[self.clipName setText:self.clip.clipName];
	[self.viewCount setText:[NSString stringWithFormat:@"%d views", clip.viewCount]];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)play{
	
	NSString* path = [[NSBundle mainBundle] pathForResource:@"testVideo" ofType:@"3gp"];
	NSURL* videoUrl = [NSURL fileURLWithPath:path];
	 
	PlayerViewController* tmp = [[PlayerViewController alloc] initWithContentURL:clip.clipVideoURL];
	[self presentMoviePlayerViewControllerAnimated:tmp]; 
	[tmp release];
	
}

@end
