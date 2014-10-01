// A0ViewController.m
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

#import "A0ViewController.h"

#import "A0UserProfileViewController.h"
#import <Auth0.iOS/Auth0.h>
#import <libextobjc/EXTScope.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

@interface A0ViewController ()

@property (strong, nonatomic) A0UserProfile *authInfo;
@property (strong, nonatomic) UICKeyChainStore *store;

@end

@implementation A0ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    A0TwitterAuthenticator *twitter = [A0TwitterAuthenticator newAuthenticatorWithKey:@""
                                                                            andSecret:@""];
    A0FacebookAuthenticator *facebook = [A0FacebookAuthenticator newAuthenticatorWithDefaultPermissions];
    [[A0IdentityProviderAuthenticator sharedInstance] registerAuthenticationProviders:@[
                                                                                        twitter,
                                                                                        facebook,
                                                                                        ]];


    self.store = [UICKeyChainStore keyChainStoreWithService:@"Auth0"];
    @weakify(self);
    NSString* refreshToken = [self.store stringForKey: @"refresh_token"];
    if (refreshToken) {
        [[A0APIClient sharedClient] delegationWithRefreshToken:refreshToken parameters:nil success:^(A0Token *token) {
            @strongify(self);
            [self.store setString:token.idToken forKey:@"id_token"];
            [self.store synchronize];
            [self loadSessionInfoWithToken:[[A0Token alloc] initWithAccessToken:token.accessToken idToken:token.idToken tokenType:token.tokenType refreshToken:refreshToken]];
        } failure:^(NSError *error) {
            @strongify(self);
            [self.store removeAllItems];
            [self.store synchronize];
            [self clearSessionInfo];
        }];
    }
}

- (void)signIn:(id)sender {
    [self clearSession:nil];
    A0AuthenticationViewController *controller = [[A0AuthenticationViewController alloc] init];
    @weakify(self);
    controller.closable = YES;
    controller.loginAfterSignUp = YES;
    controller.usesEmail = YES;
    controller.onAuthenticationBlock = ^(A0UserProfile *profile, A0Token *token) {
        NSLog(@"SUCCESS %@", profile);
        @strongify(self);
        self.authInfo = profile;
        [self.store setString:token.idToken forKey:@"id_token"];
        [self.store setString:token.refreshToken forKey:@"refresh_token"];
        [self.store setData:[NSKeyedArchiver archivedDataWithRootObject:profile] forKey:@"profile"];
        [self.store synchronize];
        [self loadSessionInfoWithToken:token];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)showProfileInfo:(id)sender {
    [self performSegueWithIdentifier:@"ShowInfo" sender:self];
}

- (IBAction)refreshSession:(id)sender {
    @weakify(self);
    NSString* refreshToken = [self.store stringForKey: @"refresh_token"];
    [[A0APIClient sharedClient] delegationWithRefreshToken:refreshToken parameters:nil success:^(A0Token *token) {
        @strongify(self);
        [self.store setString:token.idToken forKey:@"id_token"];
        [self.store synchronize];
        [self loadSessionInfoWithToken:[[A0Token alloc] initWithAccessToken:token.accessToken idToken:token.idToken tokenType:token.tokenType refreshToken:refreshToken]];
    } failure:^(NSError *error) {
        @strongify(self);
        [self.store removeAllItems];
        [self.store synchronize];
        [self clearSessionInfo];
    }];
}

- (IBAction)clearSession:(id)sender {
    [self.store removeAllItems];
    [self.store synchronize];
    [self clearSessionInfo];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowInfo"]) {
        A0UserProfileViewController *controller = segue.destinationViewController;
        controller.authInfo = self.authInfo;
    }
}

- (void)clearSessionInfo {
    self.signInButton.enabled = YES;
    self.refreshButton.enabled = NO;
    self.showProfileButton.enabled = NO;
    self.idTokenLabel.text = nil;
    self.expiresLabel.text = nil;
    self.refreshTokenLabel.text = nil;
    self.welcomeLabel.text = @"No Session found";
}

- (void)loadSessionInfoWithToken:(A0Token *)token {
    A0UserProfile *profile = [NSKeyedUnarchiver unarchiveObjectWithData:[self.store dataForKey:@"profile"]];;
    self.authInfo = profile;
    self.refreshButton.enabled = YES;
    self.showProfileButton.enabled = YES;
    self.idTokenLabel.text = token.idToken;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.expiresLabel.text = [formatter stringFromDate:token.expiresAt];
    self.refreshTokenLabel.text = token.refreshToken;
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@!", profile.name];
    self.signInButton.enabled = NO;
}

@end
