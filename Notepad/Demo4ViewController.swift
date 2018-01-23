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
    let alert = UIAlertController(title: "title", message: "message", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
    let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
    ok.isEnabled = false
    alert.addAction(ok)
    present(alert, animated: true, completion: nil)
  }

  @IBAction func _cusAction() -> Void {
    let alert = AlertController()
    alert.add(action: AlertAction(title: "ok", style: .default))
    alert.add(action: AlertAction(title: "cancel", style: .cancel))
    alert.add(action: AlertAction(title: "oo", style: .destructive, handler: { action in
      print(action.title ?? "null")
    }))
    let aa = AlertAction(title: "aa", style: .default)
    aa.isEnable = false
    alert.add(action: aa)
    self.present(alert, animated: true, completion: nil)
  }
}
