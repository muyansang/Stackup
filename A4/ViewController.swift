import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var allRecipes = Recipe.dummyData
    private var filteredRecipes: [Recipe] = []
    
    private let filters = ["All", "Beginner", "Intermediate", "Advanced"]
    private var selectedFilterIndex = 0

    private var headerView: UIView!
    private var titleLabel: UILabel!
    private var filterCollectionView: UICollectionView!
    private var recipeCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupHeaderView()
        setupFilterCollectionView()
        setupRecipeCollectionView()
        setupConstraints()

        fetchRecipes()
    }
    
    private func fetchRecipes() {
        NetworkManager.shared.fetchRecipes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let recipes):
                self.allRecipes = recipes
                self.filteredRecipes = recipes
                DispatchQueue.main.async {
                    self.recipeCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching recipes: \(error)")
            }
        }
    }
    
    // MARK: - Setup Views
    private func setupHeaderView() {
        headerView = UIView()
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel = UILabel()
        titleLabel.text = "ChefOS"
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
    }
    
    private func setupFilterCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterCollectionView.backgroundColor = .systemBackground
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        view.addSubview(filterCollectionView)
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupRecipeCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16

        recipeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        recipeCollectionView.backgroundColor = .systemBackground
        recipeCollectionView.alwaysBounceVertical = true
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        recipeCollectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        view.addSubview(recipeCollectionView)
        recipeCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header View
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            // Filter Collection View
            filterCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            // Recipe Collection View
            recipeCollectionView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 16),
            recipeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recipeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recipeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Collection View Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return filters.count
        } else if collectionView == recipeCollectionView {
            return filteredRecipes.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else {
                return UICollectionViewCell()
            }
            let isSelected = (indexPath.item == selectedFilterIndex)
            cell.configure(with: filters[indexPath.item], isSelected: isSelected)
            return cell
        } else if collectionView == recipeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as? RecipeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: filteredRecipes[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            selectedFilterIndex = indexPath.item
            
            let selected = filters[selectedFilterIndex]
            if selected == "All" {
                filteredRecipes = allRecipes
            } else {
                filteredRecipes = allRecipes.filter {
                    $0.difficulty.lowercased() == selected.lowercased()
                }
            }

            filterCollectionView.reloadData()
            recipeCollectionView.reloadData()
        } else if collectionView == recipeCollectionView {
            let selectedRecipe = filteredRecipes[indexPath.item]
            let detailVC = DetailViewController(recipe: selectedRecipe)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == filterCollectionView {
            return CGSize(width: 100, height: 32)
        } else if collectionView == recipeCollectionView {
            let screenWidth = view.frame.width - 32
            let width = (screenWidth - 16) / 2
            return CGSize(width: width, height: 220)
        }
        return .zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeCollectionView.reloadData()
    }
}
