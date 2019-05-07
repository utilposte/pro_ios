//
//  UIPageControl+Extension.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 12/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation
import UIKit

extension UIPageControl {

    func customPageControl(dotFillColor: UIColor, dotBorderColor: UIColor, dotBorderWidth: CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                //dotView.layer.cornerRadius = dotView.frame.size.height / 2
            } else {
                dotView.backgroundColor = .clear
                //dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }

}
extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + self.frame.size.width) / self.frame.width)
    }
}
