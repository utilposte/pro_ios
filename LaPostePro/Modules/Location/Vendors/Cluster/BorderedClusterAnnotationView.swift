//
//  BorderedClusterAnnotationView.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 26/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import MapKit

class BorderedClusterAnnotationView: ClusterAnnotationView {
    let border: UIColor
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, style: ClusterAnnotationStyle, borderColor: UIColor) {
        self.border = borderColor
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier, style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        
        switch style {
        case .image:
            layer.borderWidth = 0
        case .color:
            layer.borderColor = border.cgColor
            layer.borderWidth = 2
        }
    }
}
