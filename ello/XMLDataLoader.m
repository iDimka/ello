//
//  Loader.m
//  InTheSnow
//
//  Created by di on 7/30/09.
//  Copyright 2009 INTELLECTSOFT. All rights reserved.
//  
#import <CFNetwork/CFNetwork.h>

#import "XMLDataLoader.h"


@implementation XMLDataLoader

@synthesize proccessError = _proccessError; 
@synthesize canShowError = _bCanShowError;
@synthesize request = _request;
@synthesize successCode;
@synthesize response;
@synthesize parser;
@synthesize backReceiver;
@synthesize feedConnection = _feedConnection;
@synthesize data;
                 
- (id) initWithGETStringURL:(NSString*)GETString{ 
	self = [super init];
	if (self != nil) { 
		self.successCode = 200;
		 
		NSMutableURLRequest *request_ = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GETString] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:120];					   
		self.feedConnection = [[[NSURLConnection alloc] initWithRequest:request_ delegate:self startImmediately:YES] autorelease];
		 
		self.request = request_ ;
		
	}
	return self;
}
- (void)startRequestWithPOSTString:(NSString *)postString url:(NSURL*)url{
	
	self.request = [NSMutableURLRequest requestWithURL:url];
	[_request setHTTPMethod:@"POST"];
	[_request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]]; 
	 
	_feedConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES]; 
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)_response {
	self.data = [NSMutableData data]; 
	self.response  = [_response copy];  
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data_ {
    [self.data appendData:data_];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self handleError:error];
	[self.backReceiver didFailWithError:error];  
 }
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {  
	[connection cancel];
	if (successCode != [response statusCode]) 
	{ 
		[backReceiver noSuccessCode:self.response withData:self.data];
		return;
	} 
	if ([parser respondsToSelector:@selector(connectionDidFinishLoadingData:)]) 
	{
		[parser connectionDidFinishLoadingData:self.data];
	} 
	
	[parser performSelector:@selector(parseData:) withObject:data]; 
}

- (void)handleError:(NSError *)error {	
//	[[error localizedDescription] __log];
	if (_bCanShowError) 
	{
		NSString *errorMessage = [NSString stringWithFormat:@"%@", [error localizedDescription]];								  
		errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@"Error" withString:@" "];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorMessage  message:[[_request URL] absoluteString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	} 
}

- (void) dealloc{  	
	[_request release];
	[parser release];
	[backReceiver release];
	[response release]; 
	[data release];
	[super dealloc];
}

@end
