//
//  DetailViewController.swift
//  Sequence+Realm
//
//  Created by Ihor Mostoviy on 07.02.2020.
//  Copyright © 2020 Ihor Mostoviy. All rights reserved.
//

import UIKit
import RealmSwift

final class DetailViewController: UIViewController {

    private let realm = try! Realm()
    private var authors: Results<Author>?
    private var article: Article?

    var reference: ThreadSafeReference<Article>?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorPicker: UIPickerView!
    @IBOutlet private weak var authorTextField: UITextField!
    @IBOutlet private var toolBar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }

    private func fetch() {
        authors = realm.objects(Author.self)
        if authors?.count == 0 {
            randomAuthors()
        }

        guard let ref = reference else {
            return
        }
        article = realm.resolve(ref)

        titleLabel?.text = article?.title
        authorTextField.text = article?.author?.name

        setupTextField()
    }

    private func randomAuthors() {
        let authors = (0...9).map { _ in
            Author(value: [String.random(length: 5)])
        }
        try! realm.write {
            realm.add(authors)
        }
    }

    private func setupTextField() {
        authorTextField.inputView = authorPicker
        authorTextField.inputAccessoryView = toolBar
        authorPicker.delegate = self
        authorPicker.dataSource = self
    }

    @IBAction func doneButtonTouched(_ sender: Any) {
        authorTextField.resignFirstResponder()
        try! realm.write {
            article?.author = authors?[authorPicker.selectedRow(inComponent: 0)]
        }
        authorTextField.text = authors?[authorPicker.selectedRow(inComponent: 0)].name
    }
}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        authors?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        authors?[row].name
    }
}
