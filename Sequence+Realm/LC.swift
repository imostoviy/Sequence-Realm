//
//  LC.swift
//  Sequence+Realm
//
//  Created by Ihor Mostoviy on 04.02.2020.
//  Copyright © 2020 Ihor Mostoviy. All rights reserved.
//

import Foundation

final class LogicController {

    private func tryDecode() {
        let data = Bundle(for: type(of: self))
            .path(forResource: "output", ofType: "json")
            .flatMap { try? Data(contentsOf: URL(fileURLWithPath: $0), options: .mappedIfSafe) }!

    }
}