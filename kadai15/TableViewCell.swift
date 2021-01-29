//
//  TableViewCell.swift
//  kadai15
//
//  Created by 坂本龍哉 on 2021/01/26.
//

import UIKit

final class TableViewCell: UITableViewCell {
    static let reuseIdentifier = "Cell1"
    @IBOutlet private weak var checkImage: UIImageView!
    @IBOutlet private weak var memoLabel: UILabel!
    private static let imageview = UIImage(named: "check")

    func configure(fruit: Fruit) {
        checkImage.image = fruit.isChecked ? TableViewCell.imageview : nil
        memoLabel.text = fruit.name
    }
}
