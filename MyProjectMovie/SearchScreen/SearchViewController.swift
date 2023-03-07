//
//  SearchViewController.swift
//  MyProjectMovie
//
//  Created by Яна Угай on 10.01.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    private lazy var searhcViewModel = SearchViewModel()
    private lazy var cellDataSource: [People] = []
    
    private lazy var bgColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifire)
        tableView.register(CategotyTableViewCell.self, forCellReuseIdentifier: CategotyTableViewCell.identifire)
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.searchController = controller
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .black
        return tableView
    }()
    
    private lazy var controller: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsControllerViewController())
        controller.searchBar.placeholder = searhcViewModel.searchPlaceholder
        controller.searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1489986479, green: 0.1490316391, blue: 0.1489965916, alpha: 1)
        controller.searchBar.searchBarStyle = .minimal
        controller.searchResultsUpdater = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searhcViewModel.getData()
    }
    
    private func setUp() {
        addSubviews ()
        setConstraint()
    }
    
    private func addSubviews () {
        //MARK: без добавления вот этой хуйни(HeaderUIView) у меня не отображается searchcontroller(placeholder куда вводить поиск фильмов)
        let header = HeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 1))
        view.addSubview(header)
        view.addSubview(tableView)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindindViewModel() {
        searhcViewModel.cellDataSource.bind { [weak self] movies in
            guard let self = self, let movies = movies else {return}
            self.cellDataSource = movies
            self.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searhcViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        searhcViewModel.array[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.backgroundView = bgColorView
        header.textLabel?.text = header.textLabel?.text?.capitilizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.section {
        case 1: guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifire, for: indexPath) as? SearchTableViewCell else {
            return  UITableViewCell()
        }
        cell.configure(with: cellDataSource)
        cell.delegate = self
        return cell
        //MARK: сделал две одинаковые ячейки потому, что не нашел API где есть список актеров кто родился в выбранный день
        case 2: guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifire, for: indexPath) as? SearchTableViewCell else {
            return  UITableViewCell()
        }
        cell.configure(with: cellDataSource)
        cell.delegate = self
        return cell
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategotyTableViewCell.identifire, for: indexPath) as? CategotyTableViewCell else {
                return  UITableViewCell()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        searhcViewModel.array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(searhcViewModel.heightForRowAt(indexPath: indexPath))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(searhcViewModel.heightForHeaderInSection())
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    //MARK: здесь я тоже не знаю как правильно сделать как правильно вызывать функцию для получения данных, весь заранее не получится получить, потому что запрос в зависимости от запроса делается, поэтому сделал вот так
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsControllerViewController else { return }
        searhcViewModel.getSearch(with: query, resultController: resultController)
    }
}

extension SearchViewController: TableViewCellDelegate {
    func tableViewCellDelegate(cell: SearchTableViewCell, viewModel: People) {
        let vc = DetailActorsViewController()
        vc.setUps(with: viewModel)
        guard let id = viewModel.id else {return}
        searhcViewModel.getDetailAndMovieActors(with: String(id), vc: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
}
