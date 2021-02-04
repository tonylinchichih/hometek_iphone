//
//  MyUtils.h
//  linphone
//
//  Created by Lai Lee on 2020/7/6.
//

#ifndef MyUtils_h
#define MyUtils_h

extern bool _isUserTapped;

@interface MyUtils : NSObject{
}

+ (void)createAccount:(NSString*)username displayName: (NSString*) displayName domain: (NSString*) domain pwd: (NSString*) pwd ip: (NSString*) ip;
+ (void)removeAccount;
+ (NSString*)getDisplayName;
+ (NSString*)getSipAddress;
+ (LinphoneRegistrationState)getSipState;
+ (NSString*)foo2;
+ (void)goToLP;
+ (void)changeCurrentViewDialerView;
+ (void)changeCurrentViewHT;
+ (NSString*)imageForState:(LinphoneRegistrationState)state;
+ (bool)isUserTapped;
+ (void)enableSip: (bool) is_enabled;
+ (bool)isSipEnabled;
+ (void)resetMissedCallsCount;
@end

#endif /* MyUtils_h */
