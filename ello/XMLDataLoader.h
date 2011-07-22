//
//  Loader.h
//  InTheSnow
//
//  Created by di on 7/30/09.
//  Copyright 2009 INTELLECTSOFT. All rights reserved.
//

@protocol ISParser <NSObject>

- (void)parseData:(NSData*)data;

@optional

- (void)connectionDidFinishLoadingData:(NSData*)data;

@end

@protocol ISBackReport <NSObject>

@optional

- (void)didFailWithError:(NSError*)error;
- (void)noSuccessCode:(NSHTTPURLResponse*)httpResponse withData:(NSData*)data;

@end

@interface XMLDataLoader : NSObject { 
    NSURLConnection			*_feedConnection;
	NSMutableData			*data;
	NSHTTPURLResponse		*response;
	NSInteger				successCode;
	NSMutableURLRequest		*_request;
	
	NSObject<ISParser>		*parser;
	id<ISBackReport>		backReceiver; 
	
	BOOL					_bCanShowError;
	BOOL					_proccessError;
}

@property(nonatomic, assign, getter = isProccessError)	BOOL proccessError;
@property(nonatomic, assign, getter = isCanShowError)	BOOL canShowError;				

@property(nonatomic, assign)NSInteger			successCode; 

@property(nonatomic, retain) NSObject<ISParser> *parser;
@property(nonatomic, retain) id<ISBackReport> backReceiver;

@property(nonatomic, retain) NSURLRequest		*request;
@property(nonatomic, retain) NSHTTPURLResponse	*response;
@property(nonatomic, retain) NSURLConnection	*feedConnection;
@property(nonatomic, retain) NSMutableData		*data;
 
	//- (void)start;
- (void)handleError:(NSError *)error;
- (id)initWithGETStringURL:(NSString*)GETString;

@end
