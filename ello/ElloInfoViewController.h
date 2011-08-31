//
//  ElloInfoViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 23/08/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElloInfoViewController : UIViewController

@property(nonatomic, retain)IBOutlet UIWebView*	webView;

- (IBAction)fbFeed:(id)sender;
- (IBAction)followMe:(id)sender;

@end
