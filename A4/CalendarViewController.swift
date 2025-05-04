//
//  CalendarViewController.swift
//  A4
//
//  Created by muyan on 5/1/25.
//
import UIKit

class CalendarViewController: UIViewController, CalendarViewDelegate {

    private let project: ProjectModel
    private var calendarView: CalendarView!

    init(project: ProjectModel) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        calendarView = CalendarView(project: project)
        calendarView.delegate = self
        
        self.view = calendarView
    }

    // MARK: - CalendarViewDelegate

    func didSelectDate(_ date: Date) {
        let vc = TaskStackViewController(date: date, projectId: project.shortId)
        navigationController?.pushViewController(vc, animated: true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

        let calendar = Calendar.current
        let startDate = project.startDate

        var allTasks: [Task] = []
        let group = DispatchGroup()

        for i in 0..<14 {
            guard let date = calendar.date(byAdding: .day, value: i, to: startDate) else { continue }
            group.enter()
            NetworkManager.shared.fetchTasks(for: project.shortId, date: date) { tasks in
                allTasks.append(contentsOf: tasks)
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.calendarView.updateTasks(allTasks)
        }
    }

}
