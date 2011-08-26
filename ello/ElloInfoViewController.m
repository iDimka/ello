//
//  ElloInfoViewController.m
//  ello
//
//  Created by Dmitry Sazanovich on 23/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ElloInfoViewController.h"


#import "SVWebViewController.h"
#import "PSFBLoginDialog.h"
#import "SHK.h"
#import "SHKTwitter.h"

@interface ElloInfoViewController()

@property(nonatomic, retain)UIWebView* likeWebView;

@end


@implementation ElloInfoViewController

@synthesize likeWebView;

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];

//	likeWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(10, 10, 150, 35)] autorelease];
	[self.view addSubview:likeWebView];
	
	
	NSString *likePage = @"http://google.com";
	NSString *likeFacebookUrl = @"http://www.facebook.com/plugins/like.php?href=%@&amp;layout=standard&amp;show_faces=false&amp;width=320&amp;action=like&amp;colorscheme=light&amp;height=35";
//	likePage = feedItem.link;
	[likeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:likeFacebookUrl, likePage]]]];
	likeWebView.opaque = NO;
	likeWebView.backgroundColor = [UIColor clearColor];
	likeWebView.delegate = self;
	
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType { 
	
	// if user has to log in, open a new (modal) window
	if ([[[request URL] absoluteString] rangeOfString:@"login.php"].location != NSNotFound) {
		
		PSFBLoginDialog *dialog = [[[PSFBLoginDialog alloc] init] autorelease];
		[dialog loadURL:[[request URL] absoluteString] method:@"GET" get:nil post:nil];
		dialog.delegate = self;
		[dialog show];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark Facebook Connect

- (void)dialogDidSucceed:(FBDialog*)dialog {
//	GTMLoggerInfo(@"succeded!");
	
	[likeWebView reload];
}

- (IBAction)fbFeed:(id)sender{
	SVWebViewController* w = [[SVWebViewController alloc] initWithAddress:@"http://m.facebook.com/ElloMusic?_rdr"];
	[self.navigationController presentModalViewController:w animated:YES];
	[w release];
}
- (IBAction)followMe:(id)sender{
//	SHKTwitter* tw = [[[SHKTwitter alloc] init] autorelease];
//	[tw followMe];
	SVWebViewController* w = [[SVWebViewController alloc] initWithAddress:@"http://mobile.twitter.com/ello"];
	[self.navigationController presentModalViewController:w animated:YES];
	[w release];
}



@end
