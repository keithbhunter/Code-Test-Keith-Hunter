//
//  MapCell.swift
//  Code Test Keith Hunter
//
//  Created by Keith Hunter on 1/1/19.
//  Copyright © 2019 Keith Hunter. All rights reserved.
//

import MapKit
import UIKit

final class MapCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        contentView.addSubview(map)
        NSLayoutConstraint.activate(map.constraints(equalTo: contentView))
    }
    
    let map: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.isUserInteractionEnabled = false
        return map
    }()
    
}
