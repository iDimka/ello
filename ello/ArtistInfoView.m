//
//  ArtistInfoView.m
//  ello
//
//  Created by Dmitry Sazanovich on 13/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import "ArtistInfoView.h"

#import "Clip.h"
#import "asyncimageview.h"

@implementation ArtistInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configByClip:(Clip*)clip{
	_mainArtist.text = clip.artistName;
	_artist.text = clip.artistName;	
	_dirrector.text = clip.dirrector;
	_producer.text = clip.producer;
	_ganre.text = clip.clipGanreName;
	_label.text = clip.label;
	_songName.text = clip.clipName;
	_viewCount.text = [NSString stringWithFormat:@"%@ просмотров", clip.viewCount];
	[_photo setImage:clip.thumb];
	
}

- (IBAction)close:(id)sender{
	[self removeFromSuperview];
}

@end
