//
// Notepad
// AlertController.swift
// Created by DouKing (https://github.com/DouKing) on 2018/1/19.
// 

import UIKit

public typealias AlertActionHandler = ((AlertAction) -> Swift.Void)
private typealias AlertActionChangeHandler = ((AlertAction) -> Swift.Void)

public enum AlertControllerStyle : Int {
  case actionSheet
  case alert
}

public enum AlertActionStyle : Int {
  case `default`
  case cancel
  case destructive
}

//MARK: - AlertAction -

open class AlertAction: NSObject {

  private(set) public var title: String?
  private(set) public var style: AlertActionStyle = .default
  private(set) public var handler: AlertActionHandler?

  open var isEnable: Bool = true {
    didSet {
      if let change = enableChangeHandler {
        change(self)
      }
    }
  }

  public convenience init(title: String?, style: AlertActionStyle, handler: AlertActionHandler? = nil) {
    self.init()
    self.style = style
    self.title = title
    self.handler = handler
  }

  fileprivate var enableChangeHandler: AlertActionChangeHandler?
}

//MARK: - AlertController -

open class AlertController: UIViewController {
  private(set) var actions: [AlertAction] = []
  private(set) var style: AlertControllerStyle = .alert
  open var message: String?

  convenience init(title: String?, message: String?, style: AlertControllerStyle) {
    self.init(nibName: nil, bundle: nil)
    self.title = title
    self.message = message
    self.style = style
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    transitioningDelegate = self
    modalPresentationStyle = .custom
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(effectView)
    view.addSubview(collectionView)
    preferredContentSize = CGSize(width: totalWidth(), height: totalHeight())
  }

  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    effectView.frame = view.bounds
    collectionView.frame = view.bounds
  }

  func add(action: AlertAction) {
    action.enableChangeHandler = {[unowned self] action in
      self.collectionView.reloadData()
    }
    actions.append(action)
  }

  //MARK: - Private

  private let actionHeight: CGFloat = 44
  private let seperatorHeight: CGFloat = 1 / UIScreen.main.scale

  private lazy var effectView: UIVisualEffectView = {
    let v = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    return v
  }()

  private lazy var collectionView: UICollectionView = {
    let fl = UICollectionViewFlowLayout()
    fl.minimumLineSpacing = seperatorHeight
    fl.minimumInteritemSpacing = seperatorHeight
    let cv = UICollectionView(frame: .zero, collectionViewLayout: fl)
    cv.delegate = self
    cv.dataSource = self
    cv.backgroundColor = .clear
    cv.register(UINib(nibName: CellNibName.AlertCell.rawValue, bundle: nil),
                forCellWithReuseIdentifier: CellIdentifier.alertCell.rawValue)
    return cv
  }()

  private func shouldSplitAction() -> Bool {
    guard actions.count == 2, style == .alert else {
      return false
    }
    return true
  }

  private func totalHeight() -> CGFloat {
    var height: CGFloat = 0
    if shouldSplitAction() {
      height += actionHeight
    } else {
      height += CGFloat(actions.count) * actionHeight + CGFloat(actions.count - 1) * seperatorHeight
    }
    return height
  }

  private func totalWidth() -> CGFloat {
    switch style {
    case .alert:
      return 270
    default:
      return view.bounds.width - 30
    }
  }
}

extension AlertController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return actions.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.alertCell.rawValue, for: indexPath) as! AlertCell
    cell.setup(action: actions[indexPath.item])
    return cell
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let action = actions[indexPath.item]
    if let handler = action.handler {
      handler(action)
    }
    presentingViewController?.dismiss(animated: true, completion: nil)

    collectionView.deselectItem(at: indexPath, animated: true)
  }

  public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    let action = actions[indexPath.item]
    return action.isEnable
  }

  public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    let action = actions[indexPath.item]
    return action.isEnable
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var width = preferredContentSize.width
    if shouldSplitAction() {
      width = preferredContentSize.width / 2 - seperatorHeight
    }
    return CGSize(width: width, height: actionHeight)
  }
  
}

extension AlertController: UIViewControllerTransitioningDelegate {
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch style {
    case .actionSheet:
      return ActionSheetAnimatedTransition(transitionStyle: .present)
    case .alert:
      return AlertAnimatedTransition(transitionStyle: .present)
    }
  }

  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch style {
    case .actionSheet:
      return ActionSheetAnimatedTransition(transitionStyle: .dismiss)
    case .alert:
      return AlertAnimatedTransition(transitionStyle: .dismiss)
    }
  }

  public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let p = AlertPresentationController(presentedViewController: presented, presenting: presenting)
    return p
  }
}
