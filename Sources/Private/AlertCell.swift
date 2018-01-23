//
// Notepad
// AlertCell.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/22.
// 

import UIKit

extension AlertAction {
  var font: UIFont {
    if !isEnable {
      return UIFont.systemFont(ofSize: 14)
    }

    switch style {
    case .default:
      return UIFont.systemFont(ofSize: 14)
    case .cancel: fallthrough
    case .destructive:
      return UIFont.boldSystemFont(ofSize: 14)
    }
  }

  var titleColor: UIColor {
    if !isEnable {
      return .gray
    }

    switch style {
    case .default:
      return #colorLiteral(red: 0.1019607843, green: 0.09803921569, blue: 0.1176470588, alpha: 1)
    case .cancel:
      return #colorLiteral(red: 0.1019607843, green: 0.09803921569, blue: 0.1176470588, alpha: 1)
    case .destructive:
      return #colorLiteral(red: 0.9137254902, green: 0.231372549, blue: 0.2235294118, alpha: 1)
    }
  }
}

class AlertCell: UICollectionViewCell {

  @IBOutlet weak var textLabel: UILabel!
  var action: AlertAction?

  override init(frame: CGRect) {
    super.init(frame: frame)
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = .red
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
  }

  func setup(action: AlertAction) {
    self.action = action
    textLabel.text = action.title
    textLabel.textColor = action.titleColor
    textLabel.font = action.font
  }

}
