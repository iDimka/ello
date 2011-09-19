//
//  PrerollViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 18/09/2011.
//  Copyright (c) 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PreviewViewController.h"

@interface PrerollViewController : PreviewViewController{
	NSInvocationOperation*		_previewItiter;
	PreviewViewController*		_previewViewController;
}

@property(nonatomic, assign)id prerollDelegate;

+ (BOOL)hasPreroll;

@end
