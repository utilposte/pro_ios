//
//  Regex+Extension.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 26/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class Regex {
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            Logger.shared.debug("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
