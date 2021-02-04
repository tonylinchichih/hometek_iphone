//
//  MyUtils.m
//  linphone
//
//  Created by Lai Lee on 2020/7/6.
//

#import <Foundation/Foundation.h>
#import "MyUtils.h"
#import "PhoneMainView.h"

@implementation MyUtils

+ (void) createAccount:(NSString*)username displayName: (NSString*) displayName domain: (NSString*) domain pwd: (NSString*) pwd ip: (NSString*) ip{
    linphone_core_set_log_level(1);

    [self removeAccount];
    
    //create account
    LinphoneProxyConfig *config = linphone_core_create_proxy_config(LC);
    LinphoneAddress *addr = linphone_address_new(NULL);
    LinphoneAddress *tmpAddr = linphone_address_new([NSString stringWithFormat:@"sip:%@",domain].UTF8String);
    if (tmpAddr == nil) {
        NSLog(@"err");
        return;
    }
    
    linphone_address_set_username(addr, username.UTF8String);
    linphone_address_set_port(addr, linphone_address_get_port(tmpAddr));
    linphone_address_set_domain(addr, linphone_address_get_domain(tmpAddr));
    if (displayName && ![displayName isEqualToString:@""]) {
        linphone_address_set_display_name(addr, displayName.UTF8String);
    }
    linphone_proxy_config_set_identity_address(config, addr);
    linphone_proxy_config_set_push_notification_allowed(config, true);
    linphone_proxy_config_enable_avpf(config, true);
    
    // set transport
    linphone_proxy_config_set_route(
                                    config,
                                    [NSString stringWithFormat:@"%s;transport=%s", ip.UTF8String, "tcp"]
                                    .UTF8String);
    linphone_proxy_config_set_server_addr(
        config,
        [NSString stringWithFormat:@"%s;transport=%s", ip.UTF8String, "tcp"]
            .UTF8String);
    
    linphone_proxy_config_enable_publish(config, FALSE);
    linphone_proxy_config_enable_register(config, TRUE);
    
    LinphoneAuthInfo *info =
        linphone_auth_info_new(linphone_address_get_username(addr), // username
                               NULL,                                // user id
                               pwd.UTF8String,                        // passwd
                               NULL,                                // ha1
                               linphone_address_get_domain(addr),   // realm - assumed to be domain
                               linphone_address_get_domain(addr)    // domain
                               );
    linphone_core_add_auth_info(LC, info);
    linphone_address_unref(addr);
    linphone_address_unref(tmpAddr);

    if (config) {
        [[LinphoneManager instance] configurePushTokenForProxyConfig:config];
        if (linphone_core_add_proxy_config(LC, config) != -1) {
            linphone_core_set_default_proxy_config(LC, config);
        }
    }
    
    LinphoneVideoPolicy policy;
    policy.automatically_initiate = false;
    policy.automatically_accept = true;
    linphone_core_set_video_policy(LC, &policy);
    
    //timeout
    linphone_core_set_inc_timeout(LC, 60);
    
    linphone_core_enable_self_view(LC, FALSE);
}

+ (void) removeAccount {
    LinphoneProxyConfig *config = bctbx_list_nth_data(linphone_core_get_proxy_config_list(LC), 0);
    while (config) {
        const LinphoneAuthInfo *ai = linphone_proxy_config_find_auth_info(config);
        linphone_core_remove_proxy_config(LC, config);
        if (ai) {
            linphone_core_remove_auth_info(LC, ai);
        }
        config = bctbx_list_nth_data(linphone_core_get_proxy_config_list(LC), 0);
    }
}

+ (NSString*) getDisplayName {
    LinphoneProxyConfig *config = linphone_core_get_default_proxy_config(LC);
     NSString *message = nil;
     LinphoneGlobalState gstate = linphone_core_get_global_state(LC);

     if (gstate == LinphoneGlobalOn && !linphone_core_is_network_reachable(LC)) {
         message = NSLocalizedString(@"Network down", nil);
     } else if (gstate == LinphoneGlobalConfiguring) {
            message = NSLocalizedString(@"Fetching remote configuration", nil);
    } else if (config == NULL) {
        if (linphone_core_get_proxy_config_list(LC) != NULL) {
            message = NSLocalizedString(@"No default account", nil);
        } else {
            message = NSLocalizedString(@"No account configured", nil);
        }
    } else {
        const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(config);
        message = [FastAddressBook displayNameForAddress:addr];
    }
    return message;
}

+ (NSString*) getSipAddress {
    LinphoneProxyConfig *config = linphone_core_get_default_proxy_config(LC);
     NSString *message = nil;
     LinphoneGlobalState gstate = linphone_core_get_global_state(LC);

     if (gstate == LinphoneGlobalOn && !linphone_core_is_network_reachable(LC)) {
         message = NSLocalizedString(@"Network down", nil);
     } else if (gstate == LinphoneGlobalConfiguring) {
            message = NSLocalizedString(@"Fetching remote configuration", nil);
    } else if (config == NULL) {
        if (linphone_core_get_proxy_config_list(LC) != NULL) {
            message = NSLocalizedString(@"No default account", nil);
        } else {
            message = NSLocalizedString(@"No account configured", nil);
        }
    } else {
        const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(config);
        message = [NSString stringWithUTF8String:linphone_address_as_string_uri_only(addr)];
    }
    return message;
}

+ (LinphoneRegistrationState) getSipState {
    LinphoneProxyConfig *config = linphone_core_get_default_proxy_config(LC);

    LinphoneRegistrationState state = LinphoneRegistrationNone;
    LinphoneGlobalState gstate = linphone_core_get_global_state(LC);

        NSLog(@"haha gstate:%u", gstate);
         if (gstate == LinphoneGlobalOn && !linphone_core_is_network_reachable(LC)) {
         } else if (gstate == LinphoneGlobalConfiguring) {
        } else if (config == NULL) {
        } else {
            state = linphone_proxy_config_get_state(config);
        }
        return state;
}

+ (void) enableSip:(bool) is_enabled {
    LinphoneProxyConfig *proxyCfg = linphone_core_get_default_proxy_config(LC);
    if (proxyCfg == nil) return;
    linphone_proxy_config_enable_register(proxyCfg, is_enabled);
    linphone_proxy_config_done(proxyCfg);
}

+ (bool) isSipEnabled {
    LinphoneProxyConfig *proxyCfg = linphone_core_get_default_proxy_config(LC);
    if (proxyCfg == nil) return false;
    
    return linphone_proxy_config_register_enabled(proxyCfg);
}

+ (NSString*) foo2 {
    LinphoneProxyConfig *config = linphone_core_get_default_proxy_config(LC);

    LinphoneRegistrationState state = LinphoneRegistrationNone;
     NSString *message = nil;
     LinphoneGlobalState gstate = linphone_core_get_global_state(LC);

     if (gstate == LinphoneGlobalOn && !linphone_core_is_network_reachable(LC)) {
         message = NSLocalizedString(@"Network down", nil);
     } else if (gstate == LinphoneGlobalConfiguring) {
            message = NSLocalizedString(@"Fetching remote configuration", nil);
    } else if (config == NULL) {
        state = LinphoneRegistrationNone;
        if (linphone_core_get_proxy_config_list(LC) != NULL) {
            message = NSLocalizedString(@"No default account", nil);
        } else {
            message = NSLocalizedString(@"No account configured", nil);
        }
    } else {
        state = linphone_proxy_config_get_state(config);

        switch (state) {
            case LinphoneRegistrationOk:
                message = NSLocalizedString(@"Connected", nil);
                break;
            case LinphoneRegistrationNone:
            case LinphoneRegistrationCleared:
                message = NSLocalizedString(@"Not connected", nil);
                break;
            case LinphoneRegistrationFailed:
                message = NSLocalizedString(@"Connection failed", nil);
                break;
            case LinphoneRegistrationProgress:
                message = NSLocalizedString(@"Connection in progress", nil);
                break;
            default:
                break;
        }
    }
    return message;
}

- (void)proxyConfigUpdate:(LinphoneProxyConfig *)config {
    
}

+ (NSString *)imageForState:(LinphoneRegistrationState)state {
    switch (state) {
        case LinphoneRegistrationFailed:
            return @"led_error.png";
        case LinphoneRegistrationCleared:
        case LinphoneRegistrationNone:
            return @"led_disconnected.png";
        case LinphoneRegistrationProgress:
            return @"led_inprogress.png";
        case LinphoneRegistrationOk:
            return @"led_connected.png";
    }
}

+ (void) goToLP {
    [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
}

+ (void) resetMissedCallsCount {
    linphone_core_reset_missed_calls_count(LC);
}

+ (void) changeCurrentViewDialerView {
    [PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
}

+ (void) changeCurrentViewHT {
    [PhoneMainView.instance changeCurrentView:MainViewController.compositeViewDescription];
}

+ (bool) isUserTapped {
    if (_isUserTapped) {
        _isUserTapped = false;
        return true;
    }
    return false;
}

@end
