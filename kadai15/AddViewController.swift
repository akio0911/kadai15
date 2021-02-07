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
    var change: Fruit?

    override func viewDidLoad() {
        super.viewDidLoad()
        addText.text = change?.name ?? ""
    }

    @IBAction private func saveButton(_ sender: Any) {
        if change == nil {
            fruitAdd = Fruit(name: addText.text ?? "", isChecked: false)  // 構造体の定義を使用して
            performSegue(withIdentifier: "exit", sender: nil)
        } else {
            change?.name = addText.text ?? ""
            performSegue(withIdentifier: "change", sender: nil)
        }
    }
}
