//
//  TextFieldCell.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 1/1/19.
//  Copyright © 2019 Keith Hunter. All rights reserved.
//

import UIKit

@objc protocol TextFieldCellDelegate: NSObjectProtocol {
    
    @objc optional func textFieldCellTextDidChange(_ cell: TextFieldCell)
    @objc optional func textFieldCellShouldBeginEditing(_ cell: TextFieldCell) -> Bool
    @objc optional func textFieldCellDidBeginEditing(_ cell: TextFieldCell)
    @objc optional func textFieldCellShouldEndEditing(_ cell: TextFieldCell) -> Bool
    @objc optional func textFieldCellDidEndEditing(_ cell: TextFieldCell)
    @objc optional func textFieldCellDidEndEditing(_ cell: TextFieldCell, reason: UITextField.DidEndEditingReason)
    @objc optional func textFieldCell(_ cell: TextFieldCell, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func textFieldCellShouldClear(_ cell: TextFieldCell) -> Bool
    @objc optional func textFieldCellShouldReturn(_ cell: TextFieldCell) -> Bool
    
}

final class TextFieldCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: TextFieldCellDelegate?
    private var textFieldObserver: NSObjectProtocol?
    
    
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
        if let observer = textFieldObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
        textField.placeholder = nil
    }
    
    private func setupSubviews() {
        textFieldObserver = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { _ in
            self.delegate?.textFieldCellTextDidChange?(self)
        }
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            textField.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldCellShouldBeginEditing?(self) ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldCellDidBeginEditing?(self)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldCellShouldEndEditing?(self) ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldCellDidEndEditing?(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate?.textFieldCellDidEndEditing?(self, reason: reason)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textFieldCell?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return delegate?.textFieldCellShouldClear?(self) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldCellShouldReturn?(self) ?? true
    }
    
    
    // MARK: - Views
    
    private(set) lazy var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .decimalPad
        field.delegate = self
        return field
    }()
    
}
