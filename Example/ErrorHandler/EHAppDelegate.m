//
//  EHAppDelegate.m
//  ErrorHandler
//
//  Created by John Jones on 11/29/2015.
//  Copyright (c) 2015 John Jones. All rights reserved.
//

#import "EHAppDelegate.h"
#import "ErrorHandler.h"

@implementation EHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[ErrorHandler defaultHandler] setSubmissionURL:[NSURL URLWithString:@"http://127.0.0.1:8000/log"]];
    [[ErrorHandler defaultHandler] setAccessKey:@"1234567890"];
    return YES;
}

@end
