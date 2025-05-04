//
//  TaskStackView.swift
//  A4
//
//  Created by muyan on 4/29/25.
//
import UIKit

protocol TaskStackViewDelegate: AnyObject {
    func didSelectTask(_ task: Task)
    func didTapAddTaskOverlay(_ overlay: AddTaskOverlayView)
}

class TaskStackView: UIView, UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate {

    weak var delegate: TaskStackViewDelegate?

    private var tasks: [Task] = []

    private let tableView = UITableView()
    private let dateLabel = UILabel()
    private let weekdayLabel = UILabel()
    private let stackContainer = UIView()
    private let topGradient = CAGradientLayer()
    private let bottomGradient = CAGradientLayer()
    private let addButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddButton()
        setupLabels()
        setupTableView()
        setupGradient()
        setupGradient()
        layoutContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabels() {
        dateLabel.text = "04/22"
        dateLabel.font = UIFont.systemFont(ofSize: 64, weight: .bold)
        dateLabel.textAlignment = .center
        dateLabel.textColor = Theme.themeRed
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        weekdayLabel.text = "TUE"
        weekdayLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        weekdayLabel.textAlignment = .center
        weekdayLabel.textColor = .darkGray
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(dateLabel)
        addSubview(weekdayLabel)
    }

    private func setupAddButton() {
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(Theme.themeRed, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        addButton.backgroundColor = .white
        addButton.layer.cornerRadius = 40
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.1
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowRadius = 4
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addButton)

        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }

    @objc private func addTapped() {
        let overlay = AddTaskOverlayView()
        delegate?.didTapAddTaskOverlay(overlay)
    }

    func addTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.priority < task.priority }) {
            tasks.insert(task, at: index)
        } else {
            tasks.append(task)
        }
        tableView.reloadData()
    }


    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)

        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.clipsToBounds = true
        stackContainer.addSubview(tableView)
        addSubview(stackContainer)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackContainer.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: stackContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: stackContainer.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: stackContainer.trailingAnchor, constant: -16)
        ])
    }

    private func setupGradient() {
        topGradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        topGradient.frame = CGRect(x: 0, y: 0, width: stackContainer.bounds.width, height: 20)
        stackContainer.layer.addSublayer(topGradient)

        bottomGradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        bottomGradient.frame = CGRect(x: 0, y: stackContainer.bounds.height - 20, width: stackContainer.bounds.width, height: 20)
        stackContainer.layer.addSublayer(bottomGradient)
    }

    private func layoutContent() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            weekdayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            weekdayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - 350),
            stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
            addButton.widthAnchor.constraint(equalToConstant: 80),
            addButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        bringSubviewToFront(stackContainer)
        bringSubviewToFront(addButton)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        cell.configure(task: task, rank: indexPath.row)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.contentView.backgroundColor = .clear
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = .left
        cell.addGestureRecognizer(swipeGesture)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let task = tasks[indexPath.row]
        let itemProvider = NSItemProvider(object: task.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = task
        return [dragItem]
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }

        for item in coordinator.items {
            guard let sourceIndexPath = item.sourceIndexPath,
                  let task = item.dragItem.localObject as? Task else { continue }

            tableView.performBatchUpdates({
                tasks.remove(at: sourceIndexPath.row)
                tasks.insert(task, at: destinationIndexPath.row)
                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            }, completion: { _ in
                self.updateAllPriorities()
            })
        }

    }
    
    private func updateAllPriorities() {
        for (index, task) in tasks.enumerated() {
            var updatedTask = task
            let newPriority = tasks.count - index
            if updatedTask.priority != newPriority {
                updatedTask.priority = newPriority
                tasks[index] = updatedTask
                NetworkManager.shared.updateTaskPriority(updatedTask)
            }
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.items.count == 1
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        delegate?.didSelectTask(task)
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            cell.animateSelection()
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform(scaleX: 1.03, y: 1.05)
            }
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity
            }
        }
    }
    
    func setDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")

        formatter.dateFormat = "MM/dd"
        dateLabel.text = formatter.string(from: date)

        formatter.dateFormat = "EEE"
        weekdayLabel.text = formatter.string(from: date).uppercased()
    }
    
    func setTasks(_ tasks: [Task]) {
        self.tasks = tasks.sorted { $0.priority > $1.priority }
        tableView.reloadData()

        if !self.tasks.isEmpty {
            let topIndex = IndexPath(row: 0, section: 0)
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: topIndex, at: .top, animated: true)
            }
        }
    }

    
    private func adjustPriorityAround(index: Int) {
        guard index < tasks.count else { return }

        let oldTask = tasks[index]
        var updatedTask = oldTask

        let above = index > 0 ? tasks[index - 1] : nil
        let below = index + 1 < tasks.count ? tasks[index + 1] : nil

        var newPriority = oldTask.priority

        if let above = above, above.priority > oldTask.priority {
            newPriority = above.priority
        }
        else if let below = below, below.priority < oldTask.priority {
            newPriority = below.priority
        }

        if let above = above, above.priority == newPriority {
            newPriority = above.priority
        }

        if newPriority != oldTask.priority {
            updatedTask.priority = newPriority
            tasks[index] = updatedTask
            NetworkManager.shared.updateTaskPriority(updatedTask)
        }
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        topGradient.frame = CGRect(x: 0, y: 0, width: stackContainer.bounds.width, height: 20)
        bottomGradient.frame = CGRect(x: 0, y: stackContainer.bounds.height - 20, width: stackContainer.bounds.width, height: 20)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard let cell = gesture.view as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }

        let task = tasks[indexPath.row]
        
        if let taskId = task.id {
            NetworkManager.shared.deleteTask(taskId: taskId)
        }

        UIView.animate(withDuration: 0.3, animations: {
            cell.transform = CGAffineTransform(translationX: -cell.frame.width, y: 0)
            cell.alpha = 0
        }, completion: { _ in
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        })
    }

}

private extension UIView {
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}

