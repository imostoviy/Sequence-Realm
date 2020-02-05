//
//  LazyDecodingSequence.swift
//  Sequence+Realm
//
//  Created by Ihor Mostoviy on 04.02.2020.
//  Copyright © 2020 Ihor Mostoviy. All rights reserved.
//

import Foundation

struct LazyDecodingSequence<T>: Sequence, Decodable where T: Decodable {
    typealias Element = T
    let arrayOfElements: UnkeyedDecodingContainer

    init(from decoder: Decoder) throws {
        arrayOfElements = try decoder.unkeyedContainer()
        //arrayOfElements = try container.nestedUnkeyedContainer()
    }

    func makeIterator() -> LazyDecodingSequenceIterator<Element> {
        return LazyDecodingSequenceIterator<Element>(arrayOfElements)
    }
}

struct LazyDecodingSequenceIterator<T>: IteratorProtocol where T: Decodable {
    typealias Element = T
    var container: UnkeyedDecodingContainer

    init (_ container: UnkeyedDecodingContainer) {
        self.container = container
    }

    mutating func next() -> T? {
        if container.isAtEnd { return nil }
        return try? container.decode(T.self)
    }
}

struct Json: Decodable {
    let title: String
    let description: String
    let tags: [Tag]
}

struct Tag: Decodable {
    let id: String
    let name: String
}
