//
// Notepad
// AlertPresentationController.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/22.
// 

import UIKit
import Strom

class AlertPresentationController: Strom.PresentationController {

  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = containerView else {
      return .zero
    }
    let size = presentedViewController.preferredContentSize
    let x = (containerView.bounds.width - size.width) / 2.0
    let y = (containerView.bounds.height - size.height) / 2.0
    return CGRect(origin: CGPoint(x: x, y: y), size: size)
  }

  override var presentedView: UIView? {
    let v = presentedViewController.view
    v?.layer.cornerRadius = 15
    v?.layer.masksToBounds = true
    return v
  }
}
