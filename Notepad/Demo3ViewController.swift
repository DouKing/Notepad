//
// Notepad
// Demo3ViewController.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/19.
// 

import UIKit
import RxSwift
import RxCocoa

class Demo3ViewController: UIViewController {

  @IBOutlet weak var unTextField: UITextField!
  @IBOutlet weak var pwdTextField: UITextField!

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    let text = unTextField.rx.value
    text.asControlProperty()
      .subscribe(onNext: { (string) in
        print("\(string ?? "")")
      })
      .disposed(by: disposeBag)
  }
}
