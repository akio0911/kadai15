//
//  CheckTableViewController.swift
//  kadai15
//
//  Created by 坂本龍哉 on 2021/01/26.
//

import UIKit

final class CheckTableViewController: UITableViewController {
    private let userDefaultsFruitsKey = "fruits"

    private var fruits = [
        Fruit(name: "りんご", isChecked: true),
        Fruit(name: "ばなな", isChecked: false),
        Fruit(name: "みかん", isChecked: true),
        Fruit(name: "パイナップル", isChecked: false)
    ]

    private enum SeagueIdentifier {
        static let detail = "detail"
    }

    private var changeIndex: Int?
//    private var changeIndex = 0   とりあえず0は避ける。何もない事はnilで表すように

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCell.reuseIdentifier)

        guard let fruits = loadFruits() else {
            fatalError("fruits is nil.")
        }

        self.fruits = fruits
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard saveFruits() else {
            fatalError("Failed to save.")
        }
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
        fruits[indexPath.row].isChecked.toggle()  // toggle()でBool値の反転を行う！
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        changeIndex = indexPath.row
        performSegue(withIdentifier: SeagueIdentifier.detail, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeagueIdentifier.detail, let changeIndex = changeIndex {  // changeIndexもInt?なのでここでオプショナルバインディングしておく
            let nav = segue.destination as! UINavigationController
            let addVC = nav.topViewController as! AddViewController
            addVC.change = fruits[changeIndex]
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fruits.remove(at: indexPath.row)
        }
        tableView.reloadData()
    }

    @IBAction private func cancel(segue: UIStoryboardSegue) {
    }

    @IBAction private func exit(segue: UIStoryboardSegue) {
        guard let addVC = segue.source as? AddViewController else {return}
        guard let fruit = addVC.fruitAdd else {return}
        fruits.append(fruit)
        tableView.reloadData()
    }

    @IBAction private func change(segue: UIStoryboardSegue) {
        guard let addVC = segue.source as? AddViewController else {return}
        guard let fruit = addVC.change else {return}
        guard let changeIndex = changeIndex else {return}  // ここでオプショナル型の値の存在を保証しておかないと、下で使用するときに！を使わなければいけなくなる
        fruits[changeIndex] = fruit
        tableView.reloadData()
    }

    private func saveFruits() -> Bool {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(fruits) else { return false }  // [Fruit]型をData型にエンコード
        UserDefaults.standard.set(data, forKey: "fruits")
        return true
    }

    private func loadFruits() -> [Fruit]? {
        let decoder = JSONDecoder()
        guard let fruitsData = UserDefaults.standard.data(forKey: userDefaultsFruitsKey),
              let fruit = try? decoder.decode([Fruit].self, from: fruitsData) else {
            return nil
        }
        return fruit
    }
}
