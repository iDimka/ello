//
//  main.m
//  ello
//
//  Created by Dmitry Sazanovich on 07/07/2011.
//  Copyright 2011 iDimka. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	
//	NSArray *langOrder = [NSArray arrayWithObjects:@"ru", nil];
//	[[NSUserDefaults standardUserDefaults] setObject:langOrder forKey:@"AppleLanguages"];
	
	int retVal = UIApplicationMain(argc, argv, nil, @"elloAppDelegate");
	[pool release];
	return retVal;
}
