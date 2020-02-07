//
//  Model.swift
//  Sequence+Realm
//
//  Created by Ihor Mostoviy on 07.02.2020.
//  Copyright © 2020 Ihor Mostoviy. All rights reserved.
//

import RealmSwift

class TagRealm: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
}

class Author: Object {
    @objc dynamic var name = ""
    let articles = LinkingObjects(fromType: Article.self, property: "author")
}

class Article: Object {
    @objc dynamic var title = ""
    @objc dynamic var articleDescription = ""
    @objc dynamic var isFavourite = false
    @objc dynamic var author: Author?
    let tags = List<TagRealm>()

    override static func primaryKey() -> String? {
        return "title"
    }
}
