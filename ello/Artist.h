//
//  Artist.h
//  ello
//
//  Created by Dmitry Sazanovich on 14/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Artist : NSObject {
    
}

@property(nonatomic, assign)NSInteger	artistID;
@property(nonatomic, copy)NSString*		artistName;
@property(nonatomic, copy)NSURL*		artistImage;

@end
