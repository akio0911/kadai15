//
//  AddViewController.swift
//  kadai15
//
//  Created by 坂本龍哉 on 2021/01/26.
//

import UIKit

final class AddViewController: UIViewController {
    @IBOutlet weak private var addText: UITextField!
    private(set) var fruitAdd: Fruit?

    @IBAction private func saveButton(_ sender: Any) {
        fruitAdd = Fruit(name: addText.text ?? "", isChecked: false)
        performSegue(withIdentifier: "exit", sender: nil)
    }
}
