//
//  CalendarView.swift
//  A4
//
//  Created by muyan on 4/29/25.
//
import UIKit
import ObjectiveC

protocol CalendarViewDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

class CalendarView: UIView {
    public weak var delegate: CalendarViewDelegate?
    private let project: ProjectModel
    private let startDate: Date
    private var tasks: [Task] = []
    
    let pastelColors: [UIColor] = [
        UIColor(red: 153/255, green: 180/255, blue: 174/255, alpha: 1),
        UIColor(red: 191/255, green: 179/255, blue: 157/255, alpha: 1),
        UIColor(red: 210/255, green: 163/255, blue: 163/255, alpha: 1),
        UIColor(red: 201/255, green: 163/255, blue: 210/255, alpha: 1),
        UIColor(red: 182/255, green: 192/255, blue: 212/255, alpha: 1),
        UIColor(red: 168/255, green: 194/255, blue: 190/255, alpha: 1),
        UIColor(red: 170/255, green: 160/255, blue: 203/255, alpha: 1)
    ]


    init(project: ProjectModel) {
        self.project = project
        self.startDate = project.startDate
        super.init(frame: .zero)
        self.backgroundColor = .white
        setupViews()
        layoutViews()
        populateWeek(scrollView: thisWeekScroll, isThisWeek: true)
        populateWeek(scrollView: nextWeekScroll, isThisWeek: false)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var titleLabel: UILabel!

    private let quoteLabel: UILabel = {
        let label = UILabel()
        label.text = "\"Productivity is key to success\""
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()

    private let thisWeekLabel: UILabel = {
        let label = UILabel()
        label.text = "This Week"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = Theme.themeRed
        return label
    }()

    private let nextWeekLabel: UILabel = {
        let label = UILabel()
        label.text = "Next Week"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let thisWeekScroll = UIScrollView()
    private let nextWeekScroll = UIScrollView()
    private let bottomStack = UIView()
}

// MARK: - Setup & Layout
extension CalendarView {
    private func setupViews() {
        titleLabel = UILabel()
        titleLabel.text = project.name
        titleLabel.textColor = Theme.themeRed
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        [titleLabel, quoteLabel, thisWeekLabel, thisWeekScroll, nextWeekLabel, nextWeekScroll].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        thisWeekScroll.showsHorizontalScrollIndicator = false
        nextWeekScroll.showsHorizontalScrollIndicator = false

        addSubview(bottomStack)
        bottomStack.translatesAutoresizingMaskIntoConstraints = false

        [thisWeekLabel, thisWeekScroll, nextWeekLabel, nextWeekScroll].forEach {
            bottomStack.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func layoutViews() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            quoteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            quoteLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            bottomStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),

            nextWeekLabel.topAnchor.constraint(equalTo: thisWeekScroll.bottomAnchor, constant: 24),
            nextWeekLabel.leadingAnchor.constraint(equalTo: bottomStack.leadingAnchor, constant: 16),

            nextWeekScroll.topAnchor.constraint(equalTo: nextWeekLabel.bottomAnchor, constant: 8),
            nextWeekScroll.leadingAnchor.constraint(equalTo: bottomStack.leadingAnchor),
            nextWeekScroll.trailingAnchor.constraint(equalTo: bottomStack.trailingAnchor),
            nextWeekScroll.heightAnchor.constraint(equalToConstant: 191),

            thisWeekLabel.topAnchor.constraint(equalTo: bottomStack.topAnchor),
            thisWeekLabel.leadingAnchor.constraint(equalTo: bottomStack.leadingAnchor, constant: 16),

            thisWeekScroll.topAnchor.constraint(equalTo: thisWeekLabel.bottomAnchor, constant: 8),
            thisWeekScroll.leadingAnchor.constraint(equalTo: bottomStack.leadingAnchor),
            thisWeekScroll.trailingAnchor.constraint(equalTo: bottomStack.trailingAnchor),
            thisWeekScroll.heightAnchor.constraint(equalToConstant: 191),

            nextWeekScroll.bottomAnchor.constraint(equalTo: bottomStack.bottomAnchor)
        ])
    }
}

// MARK: - Week Population
extension CalendarView {
    private func populateWeek(scrollView: UIScrollView, isThisWeek: Bool) {
        let spacing: CGFloat = 12
        let cardWidth: CGFloat = 141
        let cardHeight: CGFloat = 191

        for i in 0..<7 {
            let fullDate = computeDateFrom(weekdayIndex: i, isThisWeek: isThisWeek)


            let taskCount = self.tasks.filter {
                let taskDate = dateFromString($0.date)
                return Calendar.current.isDate(taskDate, inSameDayAs: fullDate)
            }.count

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "EEE"
            let weekday = formatter.string(from: fullDate).uppercased()

            let card = makeCard(taskCount: taskCount, weekday: weekday, date: fullDate, isThisWeek: isThisWeek, index : i)

            card.frame = CGRect(x: CGFloat(i) * (cardWidth + spacing) + spacing,
                                y: 0,
                                width: cardWidth,
                                height: cardHeight)

            scrollView.addSubview(card)
        }

        scrollView.contentSize = CGSize(width: (cardWidth + spacing) * 7 + spacing, height: cardHeight)
    }


    private func makeCard(taskCount: Int, weekday: String, date: Date, isThisWeek: Bool, index: Int) -> UIView {
        let card = UIView()
        card.layer.cornerRadius = 12
        card.clipsToBounds = true
        
        if !isThisWeek {
            card.backgroundColor = UIColor(white: 0.85, alpha: 1)
        } else {
            card.backgroundColor = pastelColors[index % pastelColors.count]
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let dateString = formatter.string(from: date)

        let taskLabel = UILabel()
        taskLabel.text = "\(taskCount) Tasks"
        taskLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        taskLabel.textColor = .white

        let weekdayLabel = UILabel()
        weekdayLabel.text = weekday
        weekdayLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        weekdayLabel.textColor = .white

        let dateLabel = UILabel()
        dateLabel.text = dateString
        dateLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        dateLabel.textColor = .white

        [taskLabel, weekdayLabel, dateLabel].forEach {
            card.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            taskLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            taskLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),

            dateLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            dateLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),

            weekdayLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -4),
            weekdayLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        card.addGestureRecognizer(tapGesture)
        card.isUserInteractionEnabled = true

        objc_setAssociatedObject(card, &AssociatedKeys.dateKey, date, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return card
    }

    private struct AssociatedKeys {
        static var dateKey = "associated_date_key"
    }

    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
        guard let card = sender.view,
              let date = objc_getAssociatedObject(card, &AssociatedKeys.dateKey) as? Date else { return }
        delegate?.didSelectDate(date)
    }

    private func computeDateFrom(weekdayIndex: Int, isThisWeek: Bool) -> Date {
        let calendar = Calendar.current
        let offset = weekdayIndex + (isThisWeek ? 0 : 7)
        return calendar.date(byAdding: .day, value: offset, to: calendar.startOfDay(for: startDate))!
    }
    
    private func dateFromString(_ dateStr: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateStr) ?? Date()
    }
    
    func updateTasks(_ tasks: [Task]) {
        self.tasks = tasks

        thisWeekScroll.subviews.forEach { $0.removeFromSuperview() }
        nextWeekScroll.subviews.forEach { $0.removeFromSuperview() }

        populateWeek(scrollView: thisWeekScroll, isThisWeek: true)
        populateWeek(scrollView: nextWeekScroll, isThisWeek: false)
    }




}
