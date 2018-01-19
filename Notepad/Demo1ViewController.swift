//
// Notepad
// ViewController.swift
// Created by DouKing (https://github.com/DouKing) on 2017/12/8.
// 

import UIKit
import WCDBSwift

class Sample: WCDBSwift.TableCodable {
    var identifier: Int? = nil
    var description: String? = nil

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Sample
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case description
    }
}

let document = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
let path = URL(fileURLWithPath: document).appendingPathComponent("test.db").path
let tableName = "sample"
let dataBase = Database(withPath: path)

class Demo1ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var objects: [Sample]?

    override func viewDidLoad() {
        super.viewDidLoad()
        try? dataBase.create(table: tableName, of: Sample.self)
        _reload()
    }

    private func _reload() {
        do {
            objects = try dataBase.getObjects(on: [Sample.Properties.identifier, Sample.Properties.description], fromTable: tableName)
        } catch {
            print("get objects error")
        }
        tableView.reloadData()
    }
    
    @IBAction func _tap(_ sender: Any) {
        //insert
        let sample = Sample()
        sample.identifier = 2
        let df = DateFormatter()
        df.dateFormat = "dd HH mm ss"
        sample.description = df.string(from: Date())
        do {
            try dataBase.insert(objects: [sample], intoTable: tableName)
        } catch let error {
            print("insert error: \(error)")
        }

        _reload()
    }
}

extension Demo1ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WCDB", for: indexPath)
        guard let samples = objects else { return cell }
        let sample = samples[indexPath.row]
        cell.textLabel?.text = sample.description
        return cell
    }
}

