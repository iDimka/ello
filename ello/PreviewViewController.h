//
//  PreviewViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Clip;
@class AsyncImageView;

@interface PreviewViewController : UIViewController {
    
}

@property(nonatomic, retain)IBOutlet AsyncImageView*	thumbView;
@property(nonatomic, retain)IBOutlet UILabel*		artistName;
@property(nonatomic, retain)IBOutlet UILabel*		clipName;
@property(nonatomic, retain)IBOutlet UILabel*		viewCount;
@property(nonatomic, retain)Clip*					clip;

- (IBAction)play;

@end
