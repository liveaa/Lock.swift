#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Auth0User.h"

@interface Auth0Client : NSObject
{
    Auth0User * _auth0User;
@private
    NSString * _clientId;
    NSString * _clientSecret;
    NSString * _subDomain;
    NSString * _scope;
}

@property (readonly) NSString *clientId;
@property (readonly) NSString *clientSecret;
@property (readonly) NSString *subDomain;
@property (readonly) NSString *scope;
@property (readonly) Auth0User *auth0User;

+ (Auth0Client *)auth0Client:(NSString *)subDomain clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;

+ (Auth0Client *)auth0Client:(NSString *)subDomain clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret scope:(NSString *)scope;

- (UIViewController *)getAuthenticator:(NSString *)connection scope:(NSString *)scope withCompletionHandler:(void (^)(BOOL authenticated))block;

- (void)loginAsync:(UIViewController*)controller withCompletionHandler:(void (^)(BOOL authenticated))block;

- (void)loginAsync:(UIViewController*)controller scope:(NSString *)scope withCompletionHandler:(void (^)(BOOL authenticated))block;

- (void)loginAsync:(UIViewController*)controller connection:(NSString *)connection withCompletionHandler:(void (^)(BOOL authenticated))block;

- (void)loginAsync:(UIViewController*)controller connection:(NSString *)connection scope:(NSString *)scope withCompletionHandler:(void (^)(BOOL authenticated))block;

- (void)loginAsync:(UIViewController*)controller connection:(NSString *)connection username:(NSString *)username password:(NSString *)password scope:(NSString *)scope withCompletionHandler:(void (^)(BOOL authenticated))block;

- (void)loginAsync:(UIViewController*)controller connection:(NSString *)connection username:(NSString *)username password:(NSString *)password withCompletionHandler:(void (^)(BOOL authenticated))block;

- (void)logout;

- (void)getUserInfo:(NSString *)accessToken withCompletionHandler:(void (^)(NSMutableDictionary* profile))block;

@end
