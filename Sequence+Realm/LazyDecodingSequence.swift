//
//  LazyDecodingSequence.swift
//  Sequence+Realm
//
//  Created by Ihor Mostoviy on 04.02.2020.
//  Copyright © 2020 Ihor Mostoviy. All rights reserved.
//

import Foundation

struct LazyDecodingSequence<T>: Sequence {
    let element: T
}
