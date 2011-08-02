//
//  GenreViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 01/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Genre.h"
#import "ClipsViewController.h"

@interface GenreViewController : ClipsViewController{
	Genre*		_genre;
}

- (id)initWithGenre:(Genre*)genre;

@end
