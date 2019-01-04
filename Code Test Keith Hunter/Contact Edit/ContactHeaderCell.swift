//
//  ContactHeaderCell.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/26/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

@objc protocol ContactHeaderCellDelegate: NSObjectProtocol {
    
    @objc optional func contactHeaderCellDidSelectProfileImage(_ cell: ContactHeaderCell)
    @objc optional func contactHeaderCellTextDidChange(_ cell: ContactHeaderCell)
    @objc optional func contactHeaderCellShouldBeginEditing(_ cell: ContactHeaderCell) -> Bool
    @objc optional func contactHeaderCellDidBeginEditing(_ cell: ContactHeaderCell)
    @objc optional func contactHeaderCellShouldEndEditing(_ cell: ContactHeaderCell) -> Bool
    @objc optional func contactHeaderCellDidEndEditing(_ cell: ContactHeaderCell)
    @objc optional func contactHeaderCellDidEndEditing(_ cell: ContactHeaderCell, reason: UITextField.DidEndEditingReason)
    @objc optional func contactHeaderCell(_ cell: ContactHeaderCell, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func contactHeaderCellShouldClear(_ cell: ContactHeaderCell) -> Bool
    @objc optional func contactHeaderCell(_ cell: ContactHeaderCell, textFieldShouldReturn textField: UITextField) -> Bool
    
}

final class ContactHeaderCell: UITableViewCell, UITextFieldDelegate {
    
    struct Attributes {
        static let estimatedHeight: CGFloat = profileImageViewHeight + (2 * padding)
        fileprivate static let profileImageViewHeight: CGFloat = 100
        fileprivate static let padding: CGFloat = 20
    }
    
    weak var delegate: ContactHeaderCellDelegate?
    private var firstNameObserver: NSObjectProtocol?
    private var lastNameObserver: NSObjectProtocol?
    private var dateOfBirthObserver: NSObjectProtocol?
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    deinit {
        if let observer = firstNameObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = lastNameObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = dateOfBirthObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    
    // MARK: - Setup
    
    private func setupSubviews() {
        firstNameObserver = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: firstNameTextField, queue: .main) { _ in
            self.delegate?.contactHeaderCellTextDidChange?(self)
        }
        lastNameObserver = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: lastNameTextField, queue: .main) { _ in
            self.delegate?.contactHeaderCellTextDidChange?(self)
        }
        dateOfBirthObserver = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: dateOfBirthTextField, queue: .main) { _ in
            self.delegate?.contactHeaderCellTextDidChange?(self)
        }
        
        setupProfileImageView()
        
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(dateOfBirthTextField)
        
        let aboveLabelGuide = UILayoutGuide()
        let belowLabelGuide = UILayoutGuide()
        contentView.addLayoutGuide(aboveLabelGuide)
        contentView.addLayoutGuide(belowLabelGuide)
        
        NSLayoutConstraint.activate([
            aboveLabelGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            belowLabelGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            aboveLabelGuide.heightAnchor.constraint(equalTo: belowLabelGuide.heightAnchor),
            aboveLabelGuide.heightAnchor.constraint(greaterThanOrEqualToConstant: Attributes.padding),
            
            firstNameTextField.topAnchor.constraint(equalTo: aboveLabelGuide.bottomAnchor),
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 2),
            dateOfBirthTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 2),
            dateOfBirthTextField.bottomAnchor.constraint(equalTo: belowLabelGuide.topAnchor),
            
            firstNameTextField.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            lastNameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Attributes.padding),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Attributes.padding),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Attributes.padding),
        ])
    }
    
    private func setupProfileImageView() {
        contentView.addSubview(profileImageView)
        profileImageView.addSubview(cameraIconView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Attributes.padding),
            profileImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: Attributes.padding),
            profileImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Attributes.padding),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: Attributes.profileImageViewHeight),
            profileImageView.heightAnchor.constraint(equalToConstant: Attributes.profileImageViewHeight),
            
            cameraIconView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            cameraIconView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            cameraIconView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            cameraIconView.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 0.33),
        ])
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImagePressed)))
    }
    
    @objc private func profileImagePressed() {
        delegate?.contactHeaderCellDidSelectProfileImage?(self)
    }
    
    
    // MARK - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        firstNameTextField.text = nil
        lastNameTextField.text = nil
        dateOfBirthTextField.text = nil
        cameraIconView.isHidden = true
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.contactHeaderCellShouldBeginEditing?(self) ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.contactHeaderCellDidBeginEditing?(self)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return delegate?.contactHeaderCellShouldEndEditing?(self) ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.contactHeaderCellDidEndEditing?(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate?.contactHeaderCellDidEndEditing?(self, reason: reason)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.contactHeaderCell?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return delegate?.contactHeaderCellShouldClear?(self) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.contactHeaderCell?(self, textFieldShouldReturn: textField) ?? true
    }
    
    
    // MARK: - Views
    
    private(set) lazy var cameraIconView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "camera"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = tintColor
        imageView.tintColor = .white
        imageView.isHidden = true
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true
        
        imageView.layer.cornerRadius = Attributes.profileImageViewHeight / 2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        return imageView
    }()
    
    private(set) lazy var firstNameTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = NSLocalizedString("First Name", comment: "")
        field.delegate = self
        return field
    }()
    
    private(set) lazy var lastNameTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = NSLocalizedString("Last Name", comment: "")
        field.delegate = self
        return field
    }()
    
    private(set) lazy var dateOfBirthTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .darkGray
        field.placeholder = NSLocalizedString("MM/DD/YYYY", comment: "")
        field.delegate = self
        return field
    }()
    
}
