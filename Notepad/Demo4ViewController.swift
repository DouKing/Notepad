//
// Notepad
// Demo4ViewController.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/24.
// 

import UIKit

class Demo4ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func _alertAction() -> Void {
    let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "qqq", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "www", style: .destructive, handler: nil))
    let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
    ok.isEnabled = false
    alert.addAction(ok)

    alert.addTextField(configurationHandler: nil)
    alert.addTextField(configurationHandler: nil)

    present(alert, animated: true, completion: nil)
  }

  @IBAction func _cusAction() -> Void {
    let alert = AlertController(title: "title", message: "message", style: .alert)
    alert.addAction(AlertAction(title: "ok", style: .default))
    alert.addAction(AlertAction(title: "cancel", style: .cancel))
    alert.addAction(AlertAction(title: "oo", style: .destructive, handler: { action in
      print(action.title ?? "null")
    }))
    let aa = AlertAction(title: "aa", style: .default)
    aa.isEnable = false
    alert.addAction(aa)

    alert.addTextField()
    alert.addTextField()

    self.present(alert, animated: true, completion: nil)
  }
}
