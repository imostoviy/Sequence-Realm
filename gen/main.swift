//
//  main.swift
//  gen
//
//  Created by Ihor Mostoviy on 04.02.2020.
//  Copyright © 2020 Ihor Mostoviy. All rights reserved.
//

import Foundation

print("Hello, World!")

struct Json: Encodable {
    let title: String
    let description: String
    let tags: [Tag]
}

struct Tag: Encodable {
    let id: String
    let name: String
}

func random(length: Int32) -> String {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let randomCharacters = (0..<length).map { _ in characters.randomElement()! }
    return String(randomCharacters)
}

let jsons = (1...100000).map { _ in
    Json(title: random(length: 7),
         description: random(length: 30),
         tags: (0...5).map { _ in
            Tag(id: UUID().uuidString, name: random(length: 3))
         })
}

let data = try? JSONEncoder().encode(jsons)

FileManager().createFile(atPath: "output.json", contents: data)

print("done")
