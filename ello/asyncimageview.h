//
//  AsyncImageView.h
//  Postcard
//
//  Created by markj on 2/18/09.
//  Copyright 2009 Mark Johnson. You have permission to copy parts of this code into your own projects for any use.
//  www.markj.net
//

#import <UIKit/UIKit.h>

typedef void (^imageDidLoad) (UIImage* image);

@protocol AsyncImageViewProtocol <NSObject>

- (void)imageDidLoad:(UIImage*)image;

@end

@interface AsyncImageView : UIImageView {
	//could instead be a subclass of UIImageView instead of UIView, depending on what other features you want to 
	// to build into this class?

	NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data; //keep reference to the data so we can collect it as it downloads
	UIActivityIndicatorView*	_indicator;
	
	
}

@property(nonatomic, retain)imageDidLoad imageDidLoadBlock;
@property(nonatomic, assign)id<AsyncImageViewProtocol>	delegate;

- (void)loadImageFromURL:(NSURL*)url; 

@end
