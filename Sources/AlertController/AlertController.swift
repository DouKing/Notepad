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
  private(set) var style: AlertControllerStyle = .alert
  open override var title: String? {
    didSet {
      configureTitle(title)
    }
  }
  open var message: String? {
    didSet {
      configureMessage(message)
    }
  }
  open var attributedMessage: NSAttributedString? {
    didSet {
      resetHeaderDataSource()
    }
  }
  open var attributedTitle: NSAttributedString? {
    didSet {
      resetHeaderDataSource()
    }
  }

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
    view.addSubview(contentView)
    contentView.addSubview(effectView)
    contentView.addSubview(collectionView)
    configureMessage(message)
    resetHeaderDataSource()
    resetDataSource()
    preferredContentSize = CGSize(width: totalWidth(), height: totalHeight())
  }

  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    contentView.frame = view.bounds
    effectView.frame = contentView.bounds
    collectionView.frame = contentView.bounds
  }

  private(set) var actions: [AlertAction] = []
  func addAction(_ action: AlertAction) {
    action.enableChangeHandler = {[unowned self] action in
      self.collectionView.reloadData()
    }
    actions.append(action)
  }

  private(set) var textFields: [UITextField]?
  func addTextField(configurationHandler: ((UITextField) -> Swift.Void)? = nil) {
    if textFields == nil {
      textFields = []
    }
    let textField = UITextField()
    if let cf = configurationHandler {
      cf(textField)
    }
    textFields!.append(textField)
  }

  //MARK: - Private Methods

  private let actionHeight: CGFloat = 44
  private let textFieldHeight: CGFloat = 44
  private let seperatorHeight: CGFloat = 1 / UIScreen.main.scale

  private lazy var contentView: UIView = {
    let v = UIView()
    v.layer.cornerRadius = 15
    v.clipsToBounds = true
    return v
  }()

  private lazy var effectView: UIVisualEffectView = {
    let v = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    return v
  }()

  private lazy var collectionView: UICollectionView = {
    let fl = UICollectionViewFlowLayout()
    fl.minimumLineSpacing = 0
    fl.minimumInteritemSpacing = 0
    let cv = UICollectionView(frame: .zero, collectionViewLayout: fl)
    cv.delegate = self
    cv.dataSource = self
    cv.backgroundColor = .clear
    cv.register(UINib(nibName: CellNibName.AlertCell.rawValue, bundle: nil),
                forCellWithReuseIdentifier: CellIdentifier.alertCell.rawValue)
    cv.register(UINib(nibName: CellNibName.AlertHeaderCell.rawValue, bundle: nil),
                forCellWithReuseIdentifier: CellIdentifier.alertHeaderCell.rawValue)
    return cv
  }()

  private func configureMessage(_ message: String?) {
    if message == nil {
      attributedMessage = nil
    } else {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 5
      paragraphStyle.alignment = .center
      let text = NSMutableAttributedString(string: message!, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
                                                                          NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.1019607843, green: 0.09803921569, blue: 0.1176470588, alpha: 1)])
      text.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
      attributedMessage = NSAttributedString(attributedString: text)
    }
  }

  private func configureTitle(_ title: String?) {
    if title == nil {
      attributedTitle = nil
    } else {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      let text = NSMutableAttributedString(string: title!, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20),
                                                                        NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.1019607843, green: 0.09803921569, blue: 0.1176470588, alpha: 1)])
      text.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
      attributedTitle = NSAttributedString(attributedString: text)
    }
  }

  private var attributedHeader: NSAttributedString? {
    let header: NSMutableAttributedString = NSMutableAttributedString(string: "")
    if let attributedTitle = self.attributedTitle {
      header.append(attributedTitle)
    }
    if let attributedMessage = self.attributedMessage {
      if header.length > 0 {
        header.append(NSAttributedString(string: "\n"))
      }
      header.append(attributedMessage)
    }
    if header.length > 0 {
      return NSAttributedString(attributedString: header)
    }
    return nil
  }

  private var headerDataSource: [NSAttributedString]?
  private func resetHeaderDataSource() {
    headerDataSource = []
    if let header = attributedHeader {
      headerDataSource?.append(header)
    }
    resetDataSource()
  }

  private var dataSource: [[AlertSection]] = []
  private func resetDataSource() {
    dataSource = []
    if let hds = headerDataSource {
      dataSource.append(hds)
    }
    if let textFields = self.textFields, textFields.count > 0 {
      dataSource.append(textFields)
    }
    if actions.count > 0 {
      dataSource.append(actions)
    }

    collectionView.reloadData()
  }

  private func shouldSplitAction() -> Bool {
    guard actions.count == 2, style == .alert else {
      return false
    }
    return true
  }

  private func totalHeight() -> CGFloat {
    var height: CGFloat = 0
    height += AlertHeaderCell.height(with: attributedHeader, maxWidth: preferredContentSize.width)

    if textFields != nil && textFields!.count > 0 {
      height += CGFloat(textFields!.count) * textFieldHeight
    }

    if actions.count > 0 {
      if shouldSplitAction() {
        height += actionHeight
      } else {
        height += CGFloat(actions.count) * actionHeight + CGFloat(actions.count - 1) * seperatorHeight
      }
      height += seperatorHeight
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
    return dataSource.count
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let section = dataSource[section]
    return section.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let section = dataSource[indexPath.section]
    let item = section[indexPath.item]
    switch item.type {
    case .header:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.alertHeaderCell.rawValue, for: indexPath) as! AlertHeaderCell
      cell.titleLabel.attributedText = item as? NSAttributedString
      return cell
    case .textField:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.alertCell.rawValue, for: indexPath) as! AlertCell
      return cell
    case .action:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.alertCell.rawValue, for: indexPath) as! AlertCell
      cell.setup(action: actions[indexPath.item])
      return cell
    }
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
    let section = dataSource[indexPath.section]
    let item = section[indexPath.item]
    guard item.type == .action else { return false }
    let action = item as! AlertAction
    return action.isEnable
  }

  public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return self.collectionView(collectionView, shouldSelectItemAt: indexPath)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let section = dataSource[indexPath.section]
    let item = section[indexPath.item]
    var width = preferredContentSize.width

    switch item.type {
    case .action:
      if shouldSplitAction() {
        width = preferredContentSize.width / 2 - seperatorHeight
      }
      return CGSize(width: width, height: actionHeight)
    case .header:
      return CGSize(width: width, height: AlertHeaderCell.height(with: item as? NSAttributedString, maxWidth: preferredContentSize.width))
    case .textField:
      return CGSize(width: width, height: textFieldHeight)
    }
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    let alertSection = dataSource[section]
    if let item = alertSection.first, item.type == .action {
      return seperatorHeight
    }
    return 0
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return seperatorHeight;
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let alertSection = dataSource[section]
    if let item = alertSection.first, item.type == .action {
      return UIEdgeInsets(top: seperatorHeight, left: 0, bottom: 0, right: 0)
    }
    return .zero
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

//MARK: - Private -

protocol AlertSection {
  var type: AlertSectionType { get }
}

enum AlertSectionType {
  case header
  case textField
  case action
}

extension NSAttributedString: AlertSection {
  var type: AlertSectionType {
    return .header
  }
}

extension UITextField: AlertSection {
  var type: AlertSectionType {
    return .textField
  }
}

extension AlertAction: AlertSection {
  var type: AlertSectionType {
    return .action
  }
}
