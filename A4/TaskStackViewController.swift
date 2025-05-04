//
//  TaskStackViewController.swift
//  A4
//
//  Created by muyan on 5/1/25.
//

import UIKit

protocol TaskStackViewControllerDelegate: AnyObject {
    func taskStackViewControllerDidUpdateTasks(_ tasks: [Task])
}
class TaskStackViewController: UIViewController {

    private let date: Date
    private var taskStackView: TaskStackView!
    private let projectId: String
    private var tasks: [Task] = []

    
    weak var delegate: TaskStackViewControllerDelegate?


    init(date: Date, projectId: String) {
        self.date = date
        self.projectId = projectId
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        taskStackView = TaskStackView()
        taskStackView.setDate(date)
        taskStackView.delegate = self
        view = taskStackView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        NetworkManager.shared.fetchTasks(for: projectId, date: date) { [weak self] tasks in
            DispatchQueue.main.async {
                self?.tasks = tasks
                self?.taskStackView.setTasks(tasks)
                self?.taskStackView.setTasks(tasks)
            }
        }
    }

}

// MARK: - TaskStackViewDelegate
extension TaskStackViewController: TaskStackViewDelegate {
    func didSelectTask(_ task: Task) {
        // Future: push to task details?
    }

    func didTapAddTaskOverlay(_ overlay: AddTaskOverlayView) {
        overlay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlay)

        overlay.onSave = { [weak self, weak overlay] title, priority, description in
            overlay?.removeFromSuperview()
            guard let self = self else { return }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: self.date)


            guard let startDate = UserDefaults.standard.object(forKey: "startDate-\(self.projectId)") as? Date else {
                return
            }

            let dayIndex = Calendar.current.dateComponents([.day], from: startDate, to: self.date).day ?? 0

            let task = Task(
                title: title,
                subtitle: description,
                priority: priority,
                date: dateString,
                dayIndex: dayIndex,
                projectId: self.projectId
            )

            self.taskStackView.addTask(task)
            self.delegate?.taskStackViewControllerDidUpdateTasks(self.tasks)

            NetworkManager.shared.postTask(task) { success in}
        }


        overlay.onCancel = { [weak overlay] in
            overlay?.removeFromSuperview()
        }

        NSLayoutConstraint.activate([
            overlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            overlay.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
        ])
    }


}
