//
//  Task.swift
//  A4
//
//  Created by muyan on 4/29/25.
//
import Foundation

struct Task: Codable {
    var id: Int?
    var title: String
    var subtitle: String?
    var priority: Int
    var date: String
    var dayIndex: Int
    var projectId: String

    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, priority, date
        case dayIndex = "day_index"
        case projectId = "project_id"
    }
}
