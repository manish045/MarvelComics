//
//  SDStateView.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//


import Foundation
import UIKit
public enum SDStateViewState {
    case dataAvailable
    case loading(message: String)
    case withImage(image: String?, title: String?, message: String)
    case withButton(errorImage: String?, title: String?, message: String, buttonTitle: String,
        buttonConfig: (UIButton) -> Void, retryAction: () -> Void)
    case unknown
}

@IBDesignable
public class SDStateView: UIView {
    
    @IBInspectable
    public var stateViewCenterPositionOffset: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            setUp()
        }
    }
    
    @IBInspectable
    public var spinnerColor: UIColor = UIColor.white {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var stateViewTitleColor: UIColor = UIColor.white {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var stateViewSubtitleColor: UIColor = UIColor.white {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var buttonColor: UIColor = UIColor.white {
        didSet {
            setUp()
        }
    }
    
    @IBInspectable
    public var stateLabelTitleFontFamily: String = "HelveticaNeue-Bold" {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var stateLabelSubtitleFontFamily: String = "HelveticaNeue-Light" {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var retryButtonFontFamily: String = "HelveticaNeue-Regular" {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var stateLabelTitleFontSize: CGFloat = 20.0 {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var stateLabelSubtitleFontSize: CGFloat = 16.0 {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var buttonFontSize: CGFloat = 16.0 {
        didSet {
            setUp()
        }
    }
    
    @IBInspectable
    public var buttonSize: CGSize = CGSize(width: 200.0, height: 44.0) {
        didSet {
            setUp()
        }
    }
    
    // MARK: Spacing
    @IBInspectable
    public var titleStackSpacing: CGFloat = 8.0 {
        didSet {
            setUp()
        }
    }
    @IBInspectable
    public var imageTitleStackSpacing: CGFloat = 16.0 {
        didSet {
            setUp()
        }
    }
    
    var originalSeparatorStyle =  UITableViewCell.SeparatorStyle.singleLine
    var spinnerView = UIActivityIndicatorView(style: .gray)
    
    var dataStateTitleLabel = UILabel.autolayoutView()
    var dataStateSubtitleLabel = UILabel.autolayoutView()
    
    var stateImageView = UIImageView.autolayoutView()
    var stateContainerImageView = UIView.autolayoutView()

    var stackView: UIStackView =  UIStackView.autolayoutView()
    var titleStackView: UIStackView =  UIStackView.autolayoutView()
    
    var actionButton = UIButton.autolayoutView()
    
    var buttonAction: (() -> Void)?
    
    public var currentState: SDStateViewState = .unknown
//    var style: SDStateTheme!{
//        didSet {
//            if let style = style {
//                self.stateViewTitleColor = style.titleTheme.color
//                self.stateLabelTitleFontSize = CGFloat(style.titleTheme.font.size.rawValue)
//                self.stateLabelTitleFontFamily = style.titleTheme.font.get().familyName
//
//                self.stateViewSubtitleColor = style.subtitleTheme.color
//                self.stateLabelSubtitleFontSize = CGFloat(style.subtitleTheme.font.size.rawValue)
//                self.stateLabelSubtitleFontFamily = style.subtitleTheme.font.get().familyName
//
//                self.buttonColor = style.retryTheme.color
//                self.buttonFontSize = CGFloat(style.retryTheme.font.size.rawValue)
//                self.retryButtonFontFamily = style.retryTheme.font.get().familyName
//
//                self.spinnerColor = style.loaderColor
//                self.stateImageView.tintColor = style.tintImage
//
//            }
//        }
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        defer {
//            self.style = .main
        }
        setUp()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        setUp()
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        switch self.currentState {
        case .loading(let message):
            self.dataStateSubtitleLabel.text = message
        default:
            ()
        }
        setUp()
        
    }
    // MARK: - Custom Setup
    private func setUp() {
        
        // Loading state
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.color = spinnerColor
        spinnerView.hidesWhenStopped = true
        
        dataStateTitleLabel.textColor = stateViewTitleColor
        dataStateTitleLabel.numberOfLines = 0
        dataStateTitleLabel.textAlignment = .center
        dataStateTitleLabel.lineBreakMode = .byWordWrapping
        dataStateTitleLabel._setWidth(width: UIScreen.main.bounds.width * 0.80)
        dataStateTitleLabel.font = UIFont(name: stateLabelTitleFontFamily, size: stateLabelTitleFontSize)
        
        dataStateSubtitleLabel.textColor = stateViewSubtitleColor
        dataStateSubtitleLabel.numberOfLines = 0
        dataStateSubtitleLabel.textAlignment = .center
        dataStateSubtitleLabel.lineBreakMode = .byWordWrapping
        dataStateSubtitleLabel._setWidth(width: UIScreen.main.bounds.width * 0.80)
        dataStateSubtitleLabel.font = UIFont(name: stateLabelSubtitleFontFamily, size: stateLabelSubtitleFontSize)
        
        titleStackView.axis  = .vertical
        titleStackView.distribution  = .equalSpacing
        titleStackView.alignment = .center
        titleStackView.spacing = titleStackSpacing
        titleStackView.addArrangedSubview(dataStateTitleLabel)
        titleStackView.addArrangedSubview(dataStateSubtitleLabel)
        
        actionButton.titleLabel?.font = UIFont(name: retryButtonFontFamily, size: buttonFontSize)
        actionButton.setTitleColor(buttonColor, for: .normal)
        actionButton.setNeedsLayout()
        actionButton._setSize(size: CGSize(width: buttonSize.width, height: buttonSize.height))
        actionButton.layer.cornerRadius = 5.0
        actionButton.layer.borderWidth = 1.0
        actionButton.layer.borderColor = buttonColor.cgColor
        actionButton.addTarget(self, action: #selector(self.retryButtonTapped(_:)), for: .touchUpInside)
        
        
        stackView.axis  = .vertical
        stackView.distribution  = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = imageTitleStackSpacing
        
        
        stateContainerImageView.addSubview(self.stateImageView)

        stackView.addArrangedSubview(spinnerView)
        stackView.addArrangedSubview(stateContainerImageView)
        stackView.addArrangedSubview(titleStackView)
        
        stackView.addArrangedSubview(actionButton)
        addSubview(stackView)
        
        
        

        
        let superStack = stackView.superview
        let constraint1 = stackView.constraintFor(attribute: .left, relatedBy: .greaterThanOrEqual, toView: superStack, toAttribute: .left, multiplier: 1, constraint: 0)
        superStack?.addConstraint(constraint1)

        let constraint2 = stackView.constraintFor(attribute: .right, relatedBy: .greaterThanOrEqual, toView: superStack, toAttribute: .right, multiplier: 1, constraint: 0)
        superStack?.addConstraint(constraint2)
//
        let constraint3 = stackView.constraintFor(attribute: .top, relatedBy: .greaterThanOrEqual, toView: superStack, toAttribute: .top, multiplier: 1, constraint: 0)
        superStack?.addConstraint(constraint3)
//
//       let constraint4 =  stackView.constraintFor(attribute: .bottom, relatedBy: .greaterThanOrEqual, toView: superStack, toAttribute: .bottom, multiplier: 1, constraint: 0)
//        superStack?.addConstraint(constraint4)

//        stateContainerImageView.backgroundColor = .red
        stateImageView.contentMode = .scaleAspectFit
        stateImageView._setCenterAlignWith(view: stateContainerImageView, offset: .zero)
        stateImageView._setTop(topPadding: 0)
        stateImageView._setBottom(bottomPadding: 0)
        
        stateContainerImageView.alpha = 0.7
//        self.backgroundColor = .green
        let widthConst = stateImageView.constraintFor(attribute: .width, relatedBy: .equal, toView: stateContainerImageView, toAttribute: .width, multiplier: 0.5, constraint: 0)
        stateContainerImageView.addConstraint(widthConst)
        let ratioConst = stateImageView.constraintFor(attribute: .width, relatedBy: .equal, toView: stateImageView, toAttribute: .height, multiplier: 1, constraint: 0)
        stateImageView.addConstraint(ratioConst)

//        stateImageView.backgroundColor = .blue

        
        //Constraints
        stackView._setCenterAlignWith(view: self, offset: stateViewCenterPositionOffset)
        
        if case SDStateViewState.withButton(_, _, _, _, _, _) = currentState {
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
    }
    
    // Mark: - Deinit
    deinit {
        // Deinitialization code goes here
    }
    
    public func setState(_ state: SDStateViewState) {
        self.currentState =  state
//        reloadData()
        switch state {
            
        case .dataAvailable:
            configureForShowinData()
        case .loading(let message):
            configureForLoadingData(message: message)
        case .withImage(let image, let title, let message):
            configureWith(imageFile: image, title: title, message: message)
        case .withButton(let errorImage, let title, let message, let buttonTitle,
                         let buttonConfig, let buttonAction):
            configWithButton(image: errorImage, title: title, message: message,
                             buttonTitle: buttonTitle,
                             buttonConfig: buttonConfig,
                             buttonTapAction: buttonAction)
        case .unknown:
            ()
        }
        self.setNeedsLayout()
    }
    
    @objc func retryButtonTapped( _ sender: UIButton) {
        guard let action = self.buttonAction else {
            print("Retry Action not Found")
            return
        }
        action()
    }
    
    private func configureForLoadingData(message: String) {
        
        stateImageView.isHidden = true
        stateContainerImageView.isHidden = true
        stackView.isHidden = false
        
        spinnerView.isHidden = false
        dataStateTitleLabel.isHidden = true
        actionButton.isHidden = true
        
        spinnerView.startAnimating()
        dataStateSubtitleLabel.text = message
    }
    
    private func configureWith(imageFile: String?, title: String?, message: String) {
        
        // Image View
        if let imageFile = imageFile {
            stateImageView.isHidden = false
            stateContainerImageView.isHidden = false
            stateImageView.image = UIImage(named: imageFile)
        } else {
            stateImageView.isHidden  = true
            stateContainerImageView.isHidden = true
        }
        
        // Title Label
        if let title = title {
            dataStateTitleLabel.isHidden = false
            dataStateTitleLabel.text = title
        } else {
            dataStateTitleLabel.isHidden = true
        }
        
        actionButton.isHidden = true
        spinnerView.isHidden = true
        stackView.isHidden = false
        
        spinnerView.stopAnimating()
        
        dataStateSubtitleLabel.isHidden = false
        dataStateSubtitleLabel.text = message
    }
    
    private func configWithButton(image: String?, title: String?, message: String,
                                  buttonTitle: String,
                                  buttonConfig: (UIButton) ->Void,
                                  buttonTapAction: @escaping () -> Void) {
        
        configureWith(imageFile: image, title: title, message: message)
        buttonConfig(actionButton)
        actionButton.isHidden = false
        buttonAction = buttonTapAction
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    private func configureForShowinData() {
        stackView.isHidden = true
    }
}
