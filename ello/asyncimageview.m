
#import "AsyncImageView.h"



@implementation AsyncImageView

@synthesize delegate;

- (void)dealloc {
	
	[data release];  
	data=nil;
	
	[connection cancel]; 
	[connection release];
	[data release]; 
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
		{
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
		[_indicator setCenter:self.center];
		[self addSubview:_indicator];
		data = [[NSMutableData alloc] init]; 
    }
    return self;
}

- (void)loadImageFromURL:(NSURL*)url {
	if (connection!=nil)
		{
		[connection release]; 
		connection = nil;
		} 
	
	[_indicator startAnimating];
	
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	[data appendData:incrementalData]; 
}


- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
	[connection release];
	connection=nil; 
	
	[_indicator stopAnimating];  
	self.image = [UIImage imageWithData:data]; 
	self.contentMode = UIViewContentModeScaleAspectFit;
	self.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight); 
	[self setNeedsLayout];
	
	if ([delegate respondsToSelector:@selector(imageDidLoad:)]) 
		{
		[delegate imageDidLoad:self.image];
		}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"error async image is%@", error);
}


@end
