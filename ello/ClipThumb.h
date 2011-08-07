//
//  ClipThumb.h
//  ello
//
//  Created by Dmitry Sazanovich on 07/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Clip;
@class AsyncImageView;

@protocol ClipThumbProtocol <NSObject>

- (void)selectClip:(Clip*)clip;

@end

@interface ClipThumb : UIView{
	AsyncImageView*		_thumb;
	UILabel*			_artistName;
	UILabel*			_songName;
	id<ClipThumbProtocol>_delegate;
}

@property(nonatomic, assign)id<ClipThumbProtocol> delegate;
@property(nonatomic, retain)Clip*	clip;

- (id)initWithFrame:(CGRect)frame clip:(Clip*)cl;

@end
