//
//  ClipsParser.m
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ClipsParser.h"

#import "Clip.h"

@implementation ClipsParser

@synthesize delegate;
@synthesize content= _content;

- (id)init {
    self = [super init];
    if (self) {
        _content = [[NSMutableArray alloc] init];
		_state = -1;
		
		
    }
    return self;
} 

- (void)loadURL:(NSURL*)url{
	self.content = nil;
	_content = [[NSMutableArray alloc] init];
	XMLDataLoader* parser = [[XMLDataLoader alloc] initWithGETStringURL:[url absoluteString]];
	[parser setParser:self];
	[parser setBackReceiver:self];
	[parser release];
}

#pragma -
#pragma XMLDataParser Delegate

- (void)didFailWithError:(NSError*)error{
	
}
- (void)noSuccessCode:(NSHTTPURLResponse*)httpResponse withData:(NSData*)data{
	
}
- (void)connectionDidFinishLoadingData:(NSData*)data{
	
}
- (void)parseData:(NSData*)data{
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	if ([elementName isEqualToString:@"clip"]) {
		_state = kClipStateClip; 
		_currentClip = [Clip new];
		[_content addObject:_currentClip];
	}else if([elementName isEqualToString:@"id"]){
		_state = kClipStateID;
	}else if([elementName isEqualToString:@"artistName"]){
		_state = kClipStateArtistName;
	}else if([elementName isEqualToString:@"genre"]){
		_state = kClipStateGanre;
	}else if([elementName isEqualToString:@"genreName"]){
		_state = kClipStateGanreName;
	}else if([elementName isEqualToString:@"viewCount"]){
		_state = kClipStateViewCount;
	}else if([elementName isEqualToString:@"name"]){
		_state = kClipStateName;
	}else if([elementName isEqualToString:@"image"]){
		_state = kClipStateThumbImageURL;
	}else if([elementName isEqualToString:@"video"]){
		_state = kClipStateVideoURL;
	}
	
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	NSString* tmp = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSLog(tmp);
	if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
		return;	
	}
	
	switch ((int)_state) { 
		case kArtistID:
			_currentClip.clipID = [string intValue];			
			break;
		case kClipStateArtistName:
			_currentClip.artistName = string;
			break;
		case kClipStateGanre:
			_currentClip.clipGanre = [string intValue];
			break;
		case kClipStateGanreName:
			_currentClip.clipGanreName = string;
			break;
		case kClipStateViewCount:
			_currentClip.viewCount = [string intValue];
			break;
		case kClipStateName:
			_currentClip.clipName = string;
			break;
		case kClipStateThumbImageURL:
			_currentClip.clipImageURL = [NSURL URLWithString:string];
			break;
		case kClipStateVideoURL:
			_currentClip.clipVideoURL = [NSURL URLWithString:string];
			break;
	}
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"clip"]) {
		NSLog(@"%@\n\n\n", _currentClip);
		[_currentClip release];
	}
	_state = -1;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//	NSLog(@"parsed: %@", _content);
	
	[self.delegate parser:self xmlDidParsed:_content];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	[self.delegate parser:self xmlDidError:parseError];
	self.content = nil;
}

- (void)dealloc {
    
	[_content release];
	
    [super dealloc];
}

@end

