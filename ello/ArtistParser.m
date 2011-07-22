//
//  ArtistParser.m
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ArtistParser.h"

#import "Artist.h"

@implementation ArtistParser

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
	if ([elementName isEqualToString:@"artist"]) {
		_state = kArtist; 
		_currentArtist = [Artist new];
		[_content addObject:_currentArtist];
	}else if([elementName isEqualToString:@"id"]){
		_state = kArtistID;
	}else if([elementName isEqualToString:@"name"]){
		_state = kArtistName;
	}else if([elementName isEqualToString:@"image"]){
		_state = kArtistImage;
	}
	 
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	NSString* tmp = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSLog(tmp);
	if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
		return;	
	}
	 
	switch ((int)_state) {
		case kArtist:
			break;
			case kArtistID:
			_currentArtist.artistID = [string intValue];			
			break;
			case kArtistName:
			_currentArtist.artistName = string;
			break;
			case kArtistImage:
			_currentArtist.artistImage = [NSURL URLWithString:string];
			break;
	}
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
 
	if ([elementName isEqualToString:@"artist"]) {
		NSLog(@"%@\n\n\n", _currentArtist);
		[_currentArtist release];
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
