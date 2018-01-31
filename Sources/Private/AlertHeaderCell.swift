//
// Notepad
// AlertHeaderCell.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/30.
// 

import UIKit

let alertTitleInsert: CGFloat = 15

class AlertHeaderCell: UICollectionViewCell {

  @IBOutlet weak var titleLabel: UILabel!

  class func height(with content: NSAttributedString?, maxWidth: CGFloat) -> CGFloat {
    guard let text = content else { return 0 }
    let bounds = text.boundingRect(with: CGSize(width: maxWidth - alertTitleInsert * 2, height: .greatestFiniteMagnitude),
                                   options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine],
                                   context: nil)
    return max(bounds.size.height + 30, 60)
  }

}
