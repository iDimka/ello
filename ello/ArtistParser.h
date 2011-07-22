//
//  ArtistParser.h
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>
 
#import "XMLDataLoader.h"

@class ArtistParser;

@protocol ArtistDelegate <NSObject>

- (void)parser:(ArtistParser*)parser xmlDidParsed:(NSArray*)content;
- (void)parser:(ArtistParser*)parser xmlDidError:(NSError*)error;

@end

@class Artist;

typedef enum  {
	kArtist,
	kArtistID,
	kArtistName,
	kArtistImage
}ArtistState ;

@interface ArtistParser : NSObject <ISParser, ISBackReport, NSXMLParserDelegate> {
    NSMutableArray*		_content;
	ArtistState			_state;
	Artist*				_currentArtist; 
}

@property(nonatomic, retain)NSMutableArray*		content; 
@property(nonatomic, assign)id<ArtistDelegate>	delegate;

- (void)loadURL:(NSURL*)url;

@end
