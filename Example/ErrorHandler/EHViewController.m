//
//  EHViewController.m
//  ErrorHandler
//
//  Created by John Jones on 11/29/2015.
//  Copyright (c) 2015 John Jones. All rights reserved.
//

#import "EHViewController.h"
#import "ErrorHandler.h"

@interface EHViewController ()

@end

@implementation EHViewController

- (IBAction)causeError:(id)sender {
    NSError* error = [[NSError alloc] initWithDomain:@"test" code:123 userInfo:@{NSLocalizedDescriptionKey: @"test description"}];
    [[ErrorHandler defaultHandler] logError:error];
    NSLog(@"Error Logged");
}

- (IBAction)causeException:(id)sender {
    @try {
        [NSException raise:@"Test Exception" format:@"Test Reason"];
    }
    @catch (NSException *exception) {
        [[ErrorHandler defaultHandler] logException:exception];
        NSLog(@"Exception Logged");
    }
}
@end
