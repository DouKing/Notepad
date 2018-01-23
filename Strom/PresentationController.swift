//
// Notepad
// PresentationController.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/22.
// 

import UIKit

open class PresentationController: UIPresentationController {

  public private(set) lazy var backgroundView: UIView = {
    let bgView = UIView()
    bgView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
    bgView.alpha = 0
    bgView.addGestureRecognizer(tapGesture)
    return bgView
  }()

  public var cancelAction: (() -> Swift.Void)?

  public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    defaultTintColor = presentingViewController?.view.tintColor
  }

  override open func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()
    containerView?.addSubview(backgroundView)
    presentingViewController.transitionCoordinator?.animate(alongsideTransition: {(context) in
      self.backgroundView.alpha = 1
      self.presentingViewController.view.tintColor = .gray
    }, completion: nil)
  }

  override open func presentationTransitionDidEnd(_ completed: Bool) {
    presentingViewController.viewDidDisappear(true)
    if !completed {
      clear()
    }
  }

  override open func dismissalTransitionWillBegin() {
    presentingViewController.viewWillAppear(true)
    presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (context) in
      self.backgroundView.alpha = 0
      self.presentingViewController.view.tintColor = self.defaultTintColor
      }, completion: nil)
  }

  override open func dismissalTransitionDidEnd(_ completed: Bool) {
    if completed {
      presentingViewController.viewDidAppear(true)
      clear()
    }
  }

  override open func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    backgroundView.frame = containerView?.bounds ?? .zero
    presentedView?.frame = frameOfPresentedViewInContainerView
  }

  //MARK: Private

  private var defaultTintColor: UIColor!

  private lazy var tapGesture: UITapGestureRecognizer = {
    let tap = UITapGestureRecognizer(target: self, action: #selector(_handleTapAction(_:)))
    return tap
  }()

  private func clear() -> Void {
    backgroundView.removeFromSuperview()
    presentingViewController.view.tintColor = defaultTintColor
  }

  @objc func _handleTapAction(_ gesture: UITapGestureRecognizer) -> Void {
    if let cancel = cancelAction {
      cancel()
    }
  }
}
