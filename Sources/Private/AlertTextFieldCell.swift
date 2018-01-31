//
// Notepad
// AlertTextFieldCell.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/30.
// 

import UIKit

class AlertTextFieldCell: UICollectionViewCell {

  var textField: UITextField? {
    didSet {
      oldValue?.removeFromSuperview()
      if let tf = textField {
        contentView.addSubview(tf)
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    textField?.frame = contentView.bounds.insetBy(dx: 15, dy: 1)
  }

}
