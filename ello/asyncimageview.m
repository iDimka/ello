//
//  AsyncImageView.m
//  Postcard
//
//  Created by markj on 2/18/09.
//  Copyright 2009 Mark Johnson. You have permission to copy parts of this code into your own projects for any use.
//  www.markj.net
//

#import "AsyncImageView.h"

  

@implementation AsyncImageView

@synthesize delegate;

- (void)dealloc {
	[connection cancel]; //in case the URL is still downloading
	[connection release];
	[data release]; 
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
		[_indicator setCenter:self.center];
		[self addSubview:_indicator];
//		[_indicator release];
    }
    return self;
}

- (void)loadImageFromURL:(NSURL*)url {
	if (connection!=nil) { [connection release]; } //in case we are downloading a 2nd image
	if (data!=nil) { [data release]; }
	
	[_indicator startAnimating];
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
	//TODO error handling, what if connection is nil?
}


//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] init]; } 
	[data appendData:incrementalData]; 
}

//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image 
	[connection release];
	connection=nil; 
	
		[_indicator stopAnimating];  
	self.image = [UIImage imageWithData:data]; 
	self.contentMode = UIViewContentModeScaleAspectFit;
	self.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight); 
	[self setNeedsLayout];

	[data release];  
	data=nil;
	
	if ([delegate respondsToSelector:@selector(imageDidLoad:)]) {
		[delegate imageDidLoad:self.image];
	}
}
 

@end
