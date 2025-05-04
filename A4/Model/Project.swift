//
//  Project.swift
//  A4
//
//  Created by muyan on 5/1/25.
//
import UIKit
import Foundation

struct ProjectModel {
    let id: UUID
    let name: String
    let color: UIColor
    let shortId: String
    let startDate: Date
    var tasks: [Task]

    var taskCount: Int {
        return tasks.count
    }
}

