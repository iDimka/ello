//
//  PSFBLoginDialog.m
//  ello
//
//  Created by Dmitry Sazanovich on 24/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "PSFBLoginDialog.h"
 

@implementation PSFBLoginDialog

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

// overridden to check against our *own* URLs
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
	NSURL* url = request.URL;
//	GTMLoggerInfo(@"url: %@", [url absoluteString]);
	
	if ([[url absoluteString] rangeOfString:@"login"].location == NSNotFound) {
		[self dialogDidSucceed:url];
		return NO;
	}else {
		return YES;
	}
}

@end
