//
//  ClipInfoViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 13/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView;

@interface ClipInfoViewController : UIViewController{
	IBOutlet UILabel*	_mainArtist;
	IBOutlet UILabel*	_dirrector;
	IBOutlet UILabel*	_producer;
	IBOutlet UILabel*	_ganre;
	IBOutlet UILabel*	_label;
	IBOutlet UILabel*	_songName;
	IBOutlet UILabel*	_artist;
	IBOutlet UILabel*	_viewCount;
	
	IBOutlet AsyncImageView*	_photo;
}



@end
