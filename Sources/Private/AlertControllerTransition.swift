//
// Notepad
// AlertTransition.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/22.
// 

import UIKit

enum TransitionStyle {
  case present
  case dismiss
}

class AlertControllerTransition: NSObject {
  var transitionStyle: TransitionStyle

  init(transitionStyle: TransitionStyle) {
    self.transitionStyle = transitionStyle
    super.init()
  }

  func present(using transitionContext: UIViewControllerContextTransitioning, with duration: TimeInterval) -> Void {}
  func dismiss(using transitionContext: UIViewControllerContextTransitioning, with duration: TimeInterval) -> Void {}
}

extension AlertControllerTransition: UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.25
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    switch transitionStyle {
    case .present:
      present(using: transitionContext, with: transitionDuration(using: transitionContext))
    case .dismiss:
      dismiss(using: transitionContext, with: transitionDuration(using: transitionContext))
    }
  }

}

//MARK: -

class AlertAnimatedTransition: AlertControllerTransition {
  override func present(using transitionContext: UIViewControllerContextTransitioning, with duration: TimeInterval) -> Void {
    let contrainer = transitionContext.containerView
    guard let toVC = transitionContext.viewController(forKey: .to),
      let toView = toVC.view else {
        transitionContext.completeTransition(true)
        return
    }
    toView.alpha = 0
    toView.frame = transitionContext.finalFrame(for: toVC)
    toView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    contrainer.addSubview(toView)

    UIView.animate(withDuration: duration,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 1,
                   options: .curveEaseInOut,
                   animations: {
                    toView.alpha = 1
                    toView.transform = CGAffineTransform.identity
    }) { (finished) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }

  override func dismiss(using transitionContext: UIViewControllerContextTransitioning, with duration: TimeInterval) -> Void {
    guard let fromVC = transitionContext.viewController(forKey: .from),
      let fromView = fromVC.view else {
        transitionContext.completeTransition(true)
        return
    }

    UIView.animate(withDuration: duration,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 1,
                   options: .curveEaseInOut,
                   animations: {
                    fromView.alpha = 0
    }) { (finished) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}

class ActionSheetAnimatedTransition: AlertControllerTransition {
  override func present(using transitionContext: UIViewControllerContextTransitioning, with duration: TimeInterval) {

  }

  override func dismiss(using transitionContext: UIViewControllerContextTransitioning, with duration: TimeInterval) {

  }
}
