//
//  Condition.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 12/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class Condition {
    var categoryName: String?
    var choices: [ConditionChoice]?

    init(categoryName: String?, choices: [ConditionChoice]?) {
        self.categoryName = categoryName ?? ""
        self.choices = choices ?? []
    }
}

class ConditionChoice {
    var choiceName: String?
    var isChecked: Bool = false

    init(choiceName: String?, isChecked: Bool) {
        self.choiceName = choiceName ?? ""
        self.isChecked = isChecked
    }
}

class CurrentFacet: Equatable {

    static func == (lhs: CurrentFacet, rhs: CurrentFacet) -> Bool {
        if lhs == rhs {
            return true
        }
        return false
    }

    static let shared = CurrentFacet()
    var conditions: [Condition] = []
    var conditionsSelected: [IndexPath] = []
    var filterValue: String = ""
    var queryFilter: String = ""
    var queryFilterTmp: String = ""

    deinit {
        self.conditions = []
    }

    internal func addElementToConditionsSelected(indexPath: IndexPath) -> Bool {
        self.conditionsSelected.append(indexPath)
        return true
    }

    internal func deleteElementToConditionsSelected(indexPath: IndexPath) -> Bool {
        if let conditionIndex = CurrentFacet.shared.conditionsSelected.index(of: indexPath) {
            self.conditionsSelected.remove(at: conditionIndex)
            return true
        } else {
            return false
        }
    }

    internal func deleteElementToConditionsSelectedAt(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        self.conditionsSelected.remove(at: indexPath.row)
    }

    internal func changeStateOfCondition(indexPath: IndexPath) {
        guard var choice = self.conditions[indexPath.section].choices else { return }
        choice[indexPath.row].isChecked = !choice[indexPath.row].isChecked
    }

    internal func createQuery() {
        self.clearQuery()
        self.clearQueryTmp()
        _ = self.conditions.map { condition in
            condition.choices?.map({ conditionChoice in
                if conditionChoice.isChecked == true {
                    self.queryFilterTmp += "\(condition.categoryName ?? ""):\(conditionChoice.choiceName ?? ""):"
                }
            })
        }
    }

    internal func clearAllFilters() {
        self.conditionsSelected.removeAll()
        self.conditions = self.conditions.map({ condition in
            var tmpConditionChoice = [ConditionChoice]()
            _ = condition.choices?.map({ conditionChoice in
                let myCondition = conditionChoice
                myCondition.isChecked = false
                myCondition.choiceName = conditionChoice.choiceName
                tmpConditionChoice.append(myCondition)
            })
            return Condition(categoryName: condition.categoryName, choices: tmpConditionChoice)
        })
    }

    internal func clearQuery() {
        self.queryFilter = ""
    }

    internal func clearQueryTmp() {
        self.queryFilterTmp = ""
    }

    internal func clearConditions() {
        self.conditions.removeAll()
    }

    internal func clearConditionsSelected() {
        self.conditionsSelected.removeAll()
    }
}
