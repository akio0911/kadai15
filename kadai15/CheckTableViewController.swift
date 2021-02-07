//
//  CheckTableViewController.swift
//  kadai15
//
//  Created by 坂本龍哉 on 2021/01/26.
//

import UIKit

final class CheckTableViewController: UITableViewController {
    private var fruits = [
        Fruit(name: "りんご", isChecked: true),
        Fruit(name: "ばなな", isChecked: false),
        Fruit(name: "みかん", isChecked: true),
        Fruit(name: "パイナップル", isChecked: false)
    ]

    private enum SegueIdentifier {
        static let detail = "detail"
    }

    private var changeIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCell.reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fruits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
        cell.configure(fruit: fruits[indexPath.row])  // configure()はnameとisCheckedを使って定義されているので、fruis[indexPath.row]を打ち込むだけ
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fruits[indexPath.row].isChecked.toggle()

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        changeIndex = indexPath.row
        performSegue(withIdentifier: TableViewCell.detailIdentifier, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.detail, let changeIndex = changeIndex {
            let nav = segue.destination as! UINavigationController
            let addVC = nav.topViewController as! AddViewController
            addVC.change = fruits[changeIndex]
        }
    }

    @IBAction private func cancel(segue: UIStoryboardSegue) {
    }

    @IBAction private func exit(segue: UIStoryboardSegue) {
        guard let addVC = segue.source as? AddViewController else { return }
        guard let fruit = addVC.fruitAdd else { return }
        fruits.append(fruit)
        tableView.reloadData()
    }

    @IBAction private func change(segue: UIStoryboardSegue) {
        guard let addVC = segue.source as? AddViewController else { return }
        guard let fruit = addVC.change else { return }
        guard let changeIndex = changeIndex else { return }
        fruits[changeIndex] = fruit
        tableView.reloadData()
    }
}
