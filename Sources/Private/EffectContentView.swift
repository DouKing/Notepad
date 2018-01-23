//
// Notepad
// EffectContentView.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/23.
// 

import UIKit

class EffectContentView: UIView {
  let color = UIColor(white: 0.95, alpha: 0.7)

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = color
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = color
  }
}
