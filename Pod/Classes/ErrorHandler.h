//
//  ErrorHandler.h
//  Pods
//
//  Created by John Jones on 11/29/15.
//
//

#import <Foundation/Foundation.h>

@interface ErrorHandler : NSObject

+ (instancetype)defaultHandler;

@property (nonatomic) BOOL printErrors;

- (void)setAccessKey:(NSString*)key;
- (void)setSubmissionURL:(NSURL*)url;
- (void)logError:(NSError*)error;
- (void)logException:(NSException*)exception;

@end
