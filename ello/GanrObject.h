//
//  GanrObject.h
//  ello
//
//  Created by Dmitry Sazanovich on 28/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GanrObject : NSObject {
        NSString*		_title;
        NSString*		_ganrName;
        NSNumber*		_ganrCount;
        NSURL*			_ganrURL;
}
    @property(nonatomic, copy)NSString*		title;
    @property(nonatomic, copy)NSString*		ganrName;
    @property(nonatomic, assign)NSNumber*	ganrCount;
    @property(nonatomic, retain)NSURL*		ganrURL;

@end
