//
//  RootViewController.h
//  Oracle
//
//  Created by Dmitry Sazanovich on 09/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class _DimView;

@interface RootViewController : UIViewController {
    _DimView*	o_dimView;
}

- (void)setHiddenTabbar:(BOOL)flag;
- (UIBarButtonItem *) barButtonItemWithSel:(SEL)selector target:(id)target image:(UIImage*)image;
- (UIBarButtonItem *) barButtonItemWithSel:(SEL)selector target:(id)target image:(UIImage*)image title:(NSString*)title;
- (void)hideDimView;
- (void)showDimView;
@end

