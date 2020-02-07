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

    let realm = try! Realm()
    var authors: Results<Author>?

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
    }

    @IBAction func doneButtonTouched(_ sender: Any) {
        authorTextField.resignFirstResponder()
    }
}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }


}
