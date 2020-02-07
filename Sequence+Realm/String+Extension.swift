//
//  String+Extension.swift
//  Sequence+Realm
//
//  Created by Ihor Mostoviy on 07.02.2020.
//  Copyright © 2020 Ihor Mostoviy. All rights reserved.
//

import Foundation

extension String {
    static func random(length: Int32) -> Self {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomCharacters = (0..<length).map { _ in characters.randomElement()! }
        return String(randomCharacters)
    }
}
