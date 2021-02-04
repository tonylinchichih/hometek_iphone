//
//  UserInfo.swift
//  Hometek
//
//  Created by Lai Lee on 11/08/2017.
//  Copyright © 2017 Lai Lee. All rights reserved.
//

import Foundation

class UserInfo {
    var address1:String = ""
    var address2:String = ""
    var address3:String = ""
    var sipIp:String = ""
    
    var deviceInfo: UserInfo?
    private static var mInstance:UserInfo?
    static func sharedInstance() -> UserInfo {
        if mInstance == nil {
            mInstance = UserInfo()
        }
        return mInstance!
    }

    init() {
        address1 = getString(forKey: "addr1", def: "")
        address2 = getString(forKey: "addr2", def: "")
        address3 = getString(forKey: "addr3", def: "")
        sipIp = getString(forKey: "sipIp", def: "")
    }
    
    func getInt(forKey: String, def: Int) -> Int {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: forKey) == nil {
            //  Doesn't exist
            return def
        } else {
            return preferences.integer(forKey: forKey)
        }
    }
    
    func getString(forKey: String, def: String) -> String {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: forKey) == nil {
            //  Doesn't exist
            return def
        } else {
            return preferences.string(forKey: forKey)!
        }
    }
    
    func getBool(forKey: String, def: Bool) -> Bool {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: forKey) == nil {
            //  Doesn't exist
            return def
        } else {
            return preferences.bool(forKey: forKey)
        }
    }
    
    func save() {
        let preferences = UserDefaults.standard
        preferences.set(address1, forKey: "addr1")
        preferences.set(address2, forKey: "addr2")
        preferences.set(address3, forKey: "addr3")
        preferences.set(sipIp, forKey: "sipIp")
        preferences.synchronize()
    }
}
