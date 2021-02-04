//
//  extension.swift
//  linphone
//
//  Created by lai lee on 2021/2/2.
//

import Foundation

extension NSString  {
    var isNumber: Bool {
        return length > 0 && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted).location == NSNotFound
    }
}
