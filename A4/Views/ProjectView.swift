import UIKit

protocol ProjectViewDelegate: AnyObject {
    func didSelectProject(_ project: ProjectModel)
    func didTapAddProject()
    func didTapJoinButton()
    func didTapBackToAddProject()
}


class ProjectView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: ProjectViewDelegate?
    private var projects: [ProjectModel] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Projects"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = Theme.themeRed
        return label
    }()

    private var collectionView: UICollectionView!
    private let itemSize = CGSize(width: 120, height: 160)
    private let itemsPerRow: CGFloat = 3

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupCollectionView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: "ProjectCell")
        collectionView.register(AddCell.self, forCellWithReuseIdentifier: "AddCell")
    }

    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(collectionView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    func insertProject(_ projectModel: ProjectModel) {
        self.projects.insert(projectModel, at: 0)
        collectionView.reloadData()
    }


    func updateProjects(_ models: [ProjectModel]) {
        self.projects = models
        collectionView.reloadData()
    }


    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < projects.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
            let project = projects[indexPath.item]
            cell.configure(name: project.name, id: project.shortId, color: project.color)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as! AddCell
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == projects.count {
            delegate?.didTapAddProject()
        } else {
            delegate?.didSelectProject(projects[indexPath.item])
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalWidth = collectionView.bounds.width
        let totalCellWidth = itemSize.width * itemsPerRow
        let spacing = (totalWidth - totalCellWidth) / (itemsPerRow + 1)
        return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }
}
