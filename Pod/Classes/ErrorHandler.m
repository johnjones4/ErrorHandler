//
//  ErrorHandler.m
//  Pods
//
//  Created by John Jones on 11/29/15.
//
//

#import "ErrorHandler.h"
#import "AFNetworking.h"
#import "NSDictionary+JSON.h"

@interface ErrorHandler () {
    NSString* apiKey;
    NSURL* urlRoot;
}

- (void)_logWithType:(NSString*)type data:(NSDictionary*)data callerObject:(id)object;
- (void)_handleInternalError:(NSString*)message;
+ (NSDictionary*)_convertObject:(id)object properties:(NSArray*)properties;

@end

@implementation ErrorHandler

#pragma mark - Public Static

+ (instancetype)defaultHandler {
    static ErrorHandler* errorHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        errorHandler = [[ErrorHandler alloc] init];
    });
    return errorHandler;
}

#pragma mark - Public

- (id)init {
    if (self = [super init]) {
        self.printErrors = YES;
    }
    return self;
}

- (void)setAccessKey:(NSString*)key {
    apiKey = key;
}

- (void)setSubmissionURL:(NSURL*)url {
    urlRoot = url;
}

- (void)logError:(NSError*)error {
    [self _logWithType:@"error"
                  data:@{
                         @"code": @(error.code),
                         @"domain": error.domain
                         }
          callerObject:error];
    [self _handleInternalError:error.localizedDescription];
}

- (void)logException:(NSException*)exception {
    [self _logWithType:@"error"
                  data:@{
                         @"name": exception.name,
                         @"reason": exception.reason
                         }
          callerObject:exception];
    [self _handleInternalError:exception.reason];
}

#pragma mark - Private

- (void)_logWithType:(NSString*)type data:(NSDictionary*)data callerObject:(id)object {
    NSDictionary* sendData = [@{
                               @"type": type,
                               @"data": data,
                               @"apiKey": apiKey == nil ? @"" : apiKey,
                               @"userInfo": [object userInfo] == nil ? @{} : [object userInfo],
                               @"callStack": [NSThread callStackSymbols],
                               @"deviceInfo": [ErrorHandler _convertObject:[UIDevice currentDevice]
                                                                properties:@[@"name",@"systemName",@"systemVersion",@"model",@"localizedModel",@"identifierForVendor"]],
                               @"appInfo": [ErrorHandler _convertObject:[[NSBundle mainBundle] infoDictionary]
                                                             properties:@[@"CFBundleIdentifier",@"CFBundleShortVersionString",@"CFBundleVersion"]]
                               } validJSONDictionary];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlRoot.description
       parameters:sendData
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              if (self.printErrors) {
                  NSLog(@"Logged to server: %@",sendData);
              }
          }
          failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
              [self _handleInternalError:error.localizedDescription];
          }];
}

- (void)_handleInternalError:(NSString*)message {
    if (self.printErrors) {
        NSLog(@"%@",message);
    }
}

#pragma mark - Private Static

+ (NSDictionary*)_convertObject:(id)object properties:(NSArray*)properties {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    for(NSString* key in properties) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            dict[key] = object[key];
        } else {
            SEL selector = NSSelectorFromString(key);
            if ([object respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                dict[key] = [object performSelector:selector];
#pragma clang diagnostic pop
            }
        }
    }
    return dict;
}

@end
