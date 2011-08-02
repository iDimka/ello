//
//  PreviewViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Playlist;
@class Clip;
@class AsyncImageView;
@class PlayerViewController;

@interface PreviewViewController : UIViewController {
    PlayerViewController*	_moviePlayer;
}

@property(nonatomic, retain)Playlist*	playlist;
@property(nonatomic, retain)IBOutlet UIActivityIndicatorView*	sun;
@property(nonatomic, retain)IBOutlet AsyncImageView*	thumbView;
@property(nonatomic, retain)IBOutlet UILabel*		artistName;
@property(nonatomic, retain)IBOutlet UILabel*		clipName;
@property(nonatomic, retain)IBOutlet UILabel*		viewCount;
@property(nonatomic, retain)Clip*					clip;

- (IBAction)push4play;

@end
