//
//  Day.swift
//  A4
//
//  Created by muyan on 4/29/25.
//
import Foundation
import UIKit

struct Day: Identifiable {
    let id = UUID()
    let date: Date
    var tasks: [Task]
}
