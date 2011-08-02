//
//  GanrObject.h
//  ello
//
//  Created by Dmitry Sazanovich on 28/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Genre : NSObject { 
        NSString*		_genreName;
        NSNumber*		_genreID;
//        NSURL*			_ganrURL;
}

    @property(nonatomic, copy)NSString*		genreName;
    @property(nonatomic, assign)NSNumber*	genreID;
//    @property(nonatomic, retain)NSURL*		ganrURL;

@end
