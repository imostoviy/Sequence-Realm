//
//  ViewController.swift
//  Sequence+Realm
//
//  Created by Ihor Mostoviy on 04.02.2020.
//  Copyright © 2020 Ihor Mostoviy. All rights reserved.
//

import UIKit
import RealmSwift

final class ViewController: UIViewController {
    private var notificationToken: NotificationToken?
    private let realm = try! Realm()
    private var articles: Results<Article>?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }

    deinit {
        notificationToken?.invalidate()
    }

    private func refresh() {
        DispatchQueue(label: "Background").async {
            let data = Bundle(for: type(of: self))
//                .path(forResource: "output", ofType: "json")
                .path(forResource: "testRealm", ofType: "json")
                .flatMap { try? Data(contentsOf: URL(fileURLWithPath: $0), options: .mappedIfSafe) }!

            let sequence = try! JSONDecoder().decode(LazyDecodingSequence<Json>.self, from: data)

            let realm = try! Realm()
            sequence.forEach {
                let tags = $0.tags.map {
                    TagRealm(value: [$0.id, $0.name])
                }
                let article = Article()
                article.title = $0.title
                article.articleDescription = $0.description
                article.tags.append(objectsIn: tags)

                try! realm.write {
                    realm.add(article, update: .modified)
                }
            }
        }
    }

    private func fetch() {
        articles = realm.objects(Article.self)
        if articles?.count == 0 {
            refresh()
        }

        notificationToken = articles?.observe { [weak self, tableView] changes in
            switch changes {
            case .initial:
                tableView?.reloadData()
            case let .update(_, deletions: deletions, insertions: insertions, modifications: modifications):
                tableView?.beginUpdates()
                tableView?.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView?.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView?.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView?.endUpdates()
            case let .error(error):
                let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                alert.addAction(.init(title: "Ok", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }

    private func createNewArticle() {
        let article = Article()
        article.title = .random(length: 7)
        article.articleDescription = .random(length: 10)
        article.isFavourite = false
        article.tags.append(objectsIn: (0...(0...5).randomElement()!).map { _ in
            TagRealm(value: [UUID().uuidString, .random(length: 3)])
        })

        DispatchQueue(label: "background").async {
            let backgroundRealm = try! Realm()
            try! backgroundRealm.write {
                backgroundRealm.add(article)
            }
        }
    }

    private func backgroundUpdate(_ row: Int) {
        guard let articles = articles else { return }
        let articleRef = ThreadSafeReference(to: articles[row])
        DispatchQueue(label: "background").async {
            guard let backgroundRealm = try? Realm(),
                let article = backgroundRealm.resolve(articleRef) else { return }
            try! backgroundRealm.write {
                article.isFavourite.toggle()
            }
        }
    }

    @IBAction func addButtonTouchedUp(_ sender: Any) {
        let alert = UIAlertController(title: "add new", message: "will add random article", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.createNewArticle()
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as? TableViewCell,
            let articles = articles else {
            return .init()
        }
        cell.setup(title: articles[indexPath.row].title,
                   description: articles[indexPath.row].articleDescription,
                   tags: articles[indexPath.row].tags.map { $0.name }.reduce("", { $0 + " " + $1 }),
                   isFavourite: articles[indexPath.row].isFavourite,
                   authorName: articles[indexPath.row].author?.name)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        backgroundUpdate(indexPath.row)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Detail") as? DetailViewController, let articles = articles else {
            return nil
        }

        viewController.reference = ThreadSafeReference(to: articles[indexPath.row])

        return .init(actions: [.init(style: .normal,
                                     title: "Author",
                                     handler: { [weak self] _, _, _ in
            self?.navigationController?.pushViewController(viewController, animated: true)
        })])
    }
}
