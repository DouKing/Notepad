//
// Notepad
// AlertPresentationController.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/22.
// 

import UIKit
import Strom

class AlertPresentationController: Strom.PresentationController {

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  var keyboardRect: CGRect = .zero

  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)),
                                           name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
  }

  override var frameOfPresentedViewInContainerView: CGRect {
    return presentedViewFrame()
  }

  //MARK: - Private

  private func presentedViewFrame() -> CGRect {
    guard let containerView = containerView else {
      return .zero
    }
    let maxHeight = containerView.bounds.height - keyboardRect.height
    let maxWidth = containerView.bounds.width
    var size = presentedViewController.preferredContentSize
    if size.height > maxHeight { size.height = maxHeight }
    if size.width > maxWidth { size.width = maxWidth }
    let x = (maxWidth - size.width) / 2.0
    let y = (maxHeight - size.height) / 2.0
    return CGRect(origin: CGPoint(x: x, y: y), size: size)
  }

  @objc func keyboardWillChangeFrame(_ note: Notification) {
    guard let userInfo = note.userInfo, let pv = presentedView else {
      return
    }
    let after = keyboardRect.equalTo(.zero) ? 0 : 0.3
    keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + after) {
      if pv.frame.integral.equalTo(self.presentedViewFrame().integral) {
        return
      }
      UIView.animate(withDuration: duration) {
        pv.transform = self.transformFromRect(from: pv.frame, toRect: self.presentedViewFrame())
      }
    }

  }

  func transformFromRect(from: CGRect, toRect to: CGRect) -> CGAffineTransform {
    let transform = CGAffineTransform(translationX: to.midX - from.midX, y: to.midY - from.midY)
    return transform.scaledBy(x: to.width / from.width, y: to.height / from.height)
  }
}
