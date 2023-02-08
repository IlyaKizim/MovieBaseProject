//
//  MainViewController.swift
//  MyProjectMovie
//
//  Created by Яна Угай on 10.01.2023.
//

import UIKit

enum Section: Int {
    
    case PopularMovies = 0
    case TopRateMovie
    case UpComingMovies
    case PlayingNowMoview
    case TVshow
}

class MainViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifire)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        let headerView = HeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        tableView.tableHeaderView = headerView
        return tableView
    }()
    
   private let mainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationNavBar ()
        setUpView()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        mainViewModel.getData()
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpView() {
        addSubView()
        configureConstrains()
    }
    
    private func addSubView() {
        view.addSubview(tableView)
    }
    
    private func configureConstrains() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configurationNavBar () {
        var image = UIImage(named: "logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
    }
}

// MARK: Extension for Delegate and DataSource.

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        mainViewModel.titleForHeaderSection[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = UIFont(name: "Helvetica Neue", size: 18)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.contentView.backgroundColor = .black
        header.textLabel?.text = header.textLabel?.text?.capitilizeFirstLetter()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        mainViewModel.titleForHeaderSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(mainViewModel.heightForRowAt())
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(mainViewModel.heightForHeaderInSection())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifire , for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        switch indexPath.section {
        case Section.PopularMovies.rawValue:
            mainViewModel.getPopularMovie(cell: cell)
         
        case Section.TopRateMovie.rawValue:
            mainViewModel.getTopRateMovie(cell: cell)
            
        case Section.UpComingMovies.rawValue:
            mainViewModel.getUpcomingMovie(cell: cell)
            
        case Section.PlayingNowMoview.rawValue:
            mainViewModel.getPlayingNowMoview(cell: cell)
            
        case Section.TVshow.rawValue:
            mainViewModel.getTVshow(cell: cell)
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    //MARK: ScrollView BarButtonItem and BackToTopView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= view.safeAreaInsets.top + 40 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .done, target: self, action: nil)
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Главная", style: .done, target: self, action: #selector(back))
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if scrollView.contentOffset.y == view.safeAreaInsets.top {
            var image = UIImage(named: "logo")
            image = image?.withRenderingMode(.alwaysOriginal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        }
    }
    
    @objc private func back() {
        tableView.scrollToTop()
    }
}
extension UIScrollView {
    
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
extension MainViewController: CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCellDelegate(cell: CollectionViewTableViewCell, viewModel: Title) {
        let vc = MovieDetailsViewControllers()
        vc.setUp(with: viewModel)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
