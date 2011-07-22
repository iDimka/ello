//
//  Clip.h
//  ello
//
//  Created by Dmitry Sazanovich on 15/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Clip : NSObject {
    
}

@property(nonatomic, assign)NSInteger	clipID;
@property(nonatomic, assign)NSInteger	artistID;
@property(nonatomic, copy)NSString*		artistName;
@property(nonatomic, assign)NSInteger	viewCount;
@property(nonatomic, assign)NSInteger	clipGanre;
@property(nonatomic, copy)NSString*		clipName;
@property(nonatomic, copy)NSString*		clipGanreName;
@property(nonatomic, copy)NSURL*		clipImageURL;
@property(nonatomic, copy)NSURL*		clipVideoURL;

@end
