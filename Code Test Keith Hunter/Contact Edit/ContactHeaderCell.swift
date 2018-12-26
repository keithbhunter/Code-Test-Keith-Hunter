//
//  ContactHeaderCell.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 12/26/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

final class ContactHeaderCell: UITableViewCell {
    
    struct Attributes {
        static let estimatedHeight: CGFloat = profileImageViewHeight + (2 * padding)
        fileprivate static let profileImageViewHeight: CGFloat = 100
        fileprivate static let padding: CGFloat = 20
    }
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    
    // MARK: - Setup
    
    private func setupSubviews() {
        setupProfileImageView()
        
        contentView.addSubview(firstNameLabel)
        contentView.addSubview(lastNameLabel)
        contentView.addSubview(dateOfBirthLabel)
        
        let aboveLabelGuide = UILayoutGuide()
        let belowLabelGuide = UILayoutGuide()
        contentView.addLayoutGuide(aboveLabelGuide)
        contentView.addLayoutGuide(belowLabelGuide)
        
        NSLayoutConstraint.activate([
            aboveLabelGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            belowLabelGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            aboveLabelGuide.heightAnchor.constraint(equalTo: belowLabelGuide.heightAnchor),
            aboveLabelGuide.heightAnchor.constraint(greaterThanOrEqualToConstant: Attributes.padding),
            
            firstNameLabel.topAnchor.constraint(equalTo: aboveLabelGuide.bottomAnchor),
            lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 2),
            dateOfBirthLabel.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 2),
            dateOfBirthLabel.bottomAnchor.constraint(equalTo: belowLabelGuide.topAnchor),
            
            firstNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            lastNameLabel.leadingAnchor.constraint(equalTo: firstNameLabel.leadingAnchor),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: firstNameLabel.leadingAnchor),
            
            firstNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Attributes.padding),
            lastNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Attributes.padding),
            dateOfBirthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Attributes.padding),
        ])
    }
    
    private func setupProfileImageView() {
        contentView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Attributes.padding),
            profileImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: Attributes.padding),
            profileImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Attributes.padding),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: Attributes.profileImageViewHeight),
            profileImageView.heightAnchor.constraint(equalToConstant: Attributes.profileImageViewHeight),
        ])
    }
    
    
    // MARK - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        firstNameLabel.text = nil
        lastNameLabel.text = nil
        dateOfBirthLabel.text = nil
    }
    
    
    // MARK: - Views
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .black
        
        imageView.layer.cornerRadius = Attributes.profileImageViewHeight / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1//UIScreen.main.pixelWidth
        
        return imageView
    }()
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
}
