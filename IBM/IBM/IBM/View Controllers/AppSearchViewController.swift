//
//  AppSearchViewController.swift
//  IBM
//
//  Created by Adam Israfil on 8/31/21.
//

import UIKit

class AppSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, FilterViewDelegate {
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        self.appResultTableView.register(AppListTableViewCell.self, forCellReuseIdentifier: tableViewCellReuseIdentifier)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: FilterView
    
    func didPressBackButton(_ filterView: FilterView) {
        filterView.isHidden = true
    }
    
    func didPressFilterButton(genreFilter: GenresFilters, priceFilter: AppPriceFilter) {
        var filterSearchResults = unfilteredAppListTableCellData
        
        if genreFilter == .all && priceFilter == .all {
            filterSearchResults = unfilteredAppListTableCellData
        } else if genreFilter != .all && priceFilter == .all {
            filterSearchResults = filterGenre(filterSearchResults, genre: genreFilter)
        } else if genreFilter == .all && priceFilter != .all {
            filterSearchResults = filterPrice(filterSearchResults, price: priceFilter)
        } else if genreFilter != .all && priceFilter != .all {
            filterSearchResults = filterGenre(filterSearchResults, genre: genreFilter)
            filterSearchResults = filterPrice(filterSearchResults, price: priceFilter)
        }
        
        appListTableCellData = filterSearchResults
        appResultTableView.reloadData()
        
        filterView.isHidden = true
    }
    
    
    func didPressResetFilterButton() {
        appListTableCellData = unfilteredAppListTableCellData
        appResultTableView.reloadData()
        
        filterView.isHidden = true
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appListTableCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let appListTableCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseIdentifier,
                                                                   for: indexPath) as? AppListTableViewCell
        else {
            let appListTableCell = AppListTableViewCell(style: .default, reuseIdentifier: tableViewCellReuseIdentifier)
            return appListTableCell
        }
        
        let appListCellData = appListTableCellData[indexPath.row]
        appListTableCell.populate(appListCellData)
        appListTableCell.selectionStyle = .none
        
        return appListTableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appListCellData = appListTableCellData[indexPath.row]
        
        didSelectApp(appListCellData)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundView = .none
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height * 0.2
    }
    
    // MARK: UISearchController
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchController.searchBar.text else { return }
        fillDataSource(searchTerm: searchBarText)
        
        searchController.isActive = false
        searchController.searchBar.placeholder = searchBarText
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            searchController.searchBar.showsBookmarkButton = false
        } else {
            searchController.searchBar.showsBookmarkButton = true
        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        filterView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        appListTableCellData.removeAll()
        unfilteredAppListTableCellData.removeAll()
        searchController.searchBar.placeholder = "Search for App"
        
        appResultTableView.reloadData()
    }
    
    // MARK: Private
    
    private var appListTableCellData = [iTunesAppModel]()
    private var unfilteredAppListTableCellData = [iTunesAppModel]()
    private let tableViewCellReuseIdentifier = "AppListTableViewCell"
    
    private func didSelectApp(_ app: iTunesAppModel) {
        self.navigationController?.pushViewController(AppInfoViewController(app), animated: true)
    }
    
    private func fillDataSource(searchTerm: String) {
        DispatchQueue.global(qos: .background).async {
            iTunesAPIManager().getSoftwareForSearchTerm(searchTerm: searchTerm) { resultArray, error in
                if let resultArray = resultArray {
                    self.appListTableCellData = resultArray
                    self.unfilteredAppListTableCellData = resultArray
                    
                    DispatchQueue.main.async {
                        self.appResultTableView.reloadData()
                    }
                } else if let error = error {
                    print(error)
                }
            }
        }
    }
    
    private func filterGenre(_ prefilter: [iTunesAppModel], genre: GenresFilters) -> [iTunesAppModel] {
        var filteredResult = prefilter
        
        filteredResult = filteredResult.filter({
            $0.primaryGenreName == genre.description
        })
        
        return filteredResult
    }
    
    private func filterPrice(_ prefilter: [iTunesAppModel], price: AppPriceFilter) -> [iTunesAppModel] {
        var filteredResult = prefilter
        
        if price == .free {
            filteredResult = filteredResult.filter({
                $0.formattedPrice == price.description
            })
        } else if price == .paid {
            filteredResult = filteredResult.filter({
                $0.price > 0.00
            })
        }
        
        return filteredResult
    }
    
    // MARK: Views
    
    private var searchController: UISearchController!
    private var appResultTableView: UITableView!
    private var filterView: FilterView!
    
    private func setupViews() {
        
        view.backgroundColor = #colorLiteral(red: 0.04631470889, green: 0, blue: 0.1507385969, alpha: 1)
        
        appResultTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        appResultTableView.dataSource = self
        appResultTableView.delegate = self
        appResultTableView.rowHeight = 60
        appResultTableView.allowsSelection = true
        appResultTableView.separatorStyle = .none
        appResultTableView.backgroundColor = .clear
        view.addSubview(appResultTableView)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search for App"
        searchController.searchBar.setImage(.actions, for: .bookmark, state: .normal)
        
        appResultTableView.tableHeaderView = searchController.searchBar
        
        let filterViewWidth = view.frame.width * 0.65
        let filterViewX = (view.frame.maxX - filterViewWidth) - 10
        let filterViewFrame = CGRect(x: filterViewX, y: view.frame.height * 0.12, width: filterViewWidth, height: filterViewWidth * 1.5)
        filterView = FilterView(frame: filterViewFrame)
        filterView.isHidden = true
        filterView.delegate = self
        view.addSubview(filterView)
    }
    
}

