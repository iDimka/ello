//
//  SubscriptionsViewController.h
//  ello
//
//  Created by Dmitry Sazanovich on 12/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubscriptionsViewController : UIViewController {
    IBOutlet UITextField* _emailField;
}

@property(nonatomic, retain)UITextField* emailField;

- (IBAction)seubcribe;
- (IBAction)seubcribeFB;
- (IBAction)seubcribeTw;
- (IBAction)seubcribeVK;

@end
