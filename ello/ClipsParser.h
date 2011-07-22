//
//  ClipsParser.h
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	kClipStateNone = -1,
	kClipStateClip,
	kClipStateID,
	kClipStateArtistID,
	kClipStateArtistName,
	kClipStateGanre,
	kClipStateGanreName,
	kClipStateViewCount,
	kClipStateName,
	kClipStateThumbImageURL,
	kClipStateVideoURL
}ClipState;

@class Clip;
@class ClipsParser;

@protocol ClipsDelegate <NSObject>

- (void)parser:(ClipsParser*)parser xmlDidParsed:(NSArray*)content;
- (void)parser:(ClipsParser*)parser xmlDidError:(NSError*)error;

@end

@interface ClipsParser : NSObject <ISParser, ISBackReport, NSXMLParserDelegate> {
    NSMutableArray*		_content;
	ClipState			_state;
	Clip*				_currentClip;   
}

@property(nonatomic, retain)NSMutableArray*		content; 
@property(nonatomic, assign)id<ClipsDelegate>	delegate;

- (void)loadURL:(NSURL*)url;

@end
