// A0KeyUploader.h
//
// Copyright (c) 2014 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

@class A0UserAPIClient;

NS_ASSUME_NONNULL_BEGIN

@interface A0KeyUploader : NSObject

@property (copy, nonatomic) NSString *deviceName;

- (instancetype)initWithDomainURL:(NSURL *)domainURL
                         clientId:(NSString *)clientId
                    authorization:(NSString *)authorization
                           client:(A0UserAPIClient *)client;

- (void)uploadKey:(NSData *)key forUserWithIdentifier:(NSString *)identifier callback:(void(^)(NSError *error))callback;

+ (NSString *)authorizationWithUsername:(NSString *)username
                               password:(NSString *)password
                         connectionName:(NSString *)connectionName;
@end

NS_ASSUME_NONNULL_END