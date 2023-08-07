//
//  CarViewController.swift
//  CarSearchApp
//
//  Created by Nikolay Trofimov on 03.08.2023.
//

import UIKit

typealias TableViewProtocols = UITableViewDelegate & UITableViewDataSource

protocol AddCarViewControllerDelegate {
  func appendTable(with car: Car)
  func reloadRow(with indexPath: IndexPath)
}

class CarViewController: UIViewController {

  private var tableView: UITableView!
  private var cars: [Car] = []
  private var filteredCars: [Car] = []
  private var priceAscending = true
  private let searchController = UISearchController()

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    fetchData()
  }

}

private extension CarViewController {

  func setup() {
    setupUI()
    setupTableViewDelegateAndDataSource()
  }

  func setupUI() {
    setupTableView()
    setupNavigationBar()
    setupSearchController()
  }

  func setupTableView() {
    tableView = UITableView(frame: self.view.frame)
    view.addSubview(tableView)
    tableView.register(UINib(nibName: "CarTableViewCell", bundle: nil), forCellReuseIdentifier: "auto")
    tableView.rowHeight = 130.0
  }

  func setupNavigationBar() {
    navigationItem.hidesBackButton = true
    title = "Cars"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.tintColor = UIColor.orange

    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    let sort = UIBarButtonItem(title: "Price sort", style: .plain, target: self, action: #selector(sortTapped))
    navigationItem.rightBarButtonItems = [add, sort]
  }

  func setupSearchController() {
    searchController.loadViewIfNeeded()
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Brand"
    searchController.searchBar.enablesReturnKeyAutomatically = false
    searchController.searchBar.returnKeyType = UIReturnKeyType.done

    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false

    searchController.searchBar.scopeButtonTitles = ["All"]
    searchController.delegate = self
  }

  func setupTableViewDelegateAndDataSource() {
    tableView.delegate = self
    tableView.dataSource = self
  }

  @objc func addTapped() {
    let addCarVC = CarDetailsViewController(vcTitle: "Add Car")
    addCarVC.delegate = self
    present(UINavigationController(rootViewController: addCarVC), animated: true)
  }

  @objc func sortTapped() {
    priceAscending ? cars.sort { $0.price < $1.price } : cars.sort { $0.price > $1.price }
    priceAscending.toggle()
    tableView.reloadData()
  }

  func fetchData() {
    StorageManager.shared.fetchData { result in
      switch result {
      case .success(let cars):
        self.cars = cars
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

}

// MARK: - UITableViewDataSource
extension CarViewController: TableViewProtocols {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    searchController.isActive ? filteredCars.count : cars.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "auto", for: indexPath) as! CarTableViewCell

    if searchController.isActive {
      cell.configure(with: filteredCars[indexPath.row])
    } else {
      cell.configure(with: cars[indexPath.row])
    }

    return cell
  }
}

// MARK: - UITableViewDelegate
extension CarViewController {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let car: Car
    if searchController.isActive {
      car = filteredCars[indexPath.row]
    } else {
      car = cars[indexPath.row]
    }

    let carDetailsVC = CarDetailsViewController(vcTitle: "Edit Car", car: car, rowSelected: indexPath)
    carDetailsVC.delegate = self
    present(UINavigationController(rootViewController: carDetailsVC), animated: true)
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      if searchController.isActive {
        let car = filteredCars[indexPath.row]
        if let index = cars.firstIndex(of: car) {
          StorageManager.shared.delete(cars[index])
          cars.remove(at: index)
        }
        filteredCars.remove(at: indexPath.row)
      } else {
        StorageManager.shared.delete(filteredCars[indexPath.row])
        cars.remove(at: indexPath.row)
      }
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}

// MARK: - AddCarViewControllerDelegate
extension CarViewController: AddCarViewControllerDelegate {
  func appendTable(with car: Car) {
    cars.append(car)
    self.tableView.insertRows(
        at: [IndexPath(row: self.cars.count - 1, section: 0)],
        with: .automatic
    )
  }

  func reloadRow(with indexPath: IndexPath) {
    self.tableView.reloadRows(at: [indexPath], with: .automatic)
  }
}

// MARK: - SearchBar
extension CarViewController: UISearchResultsUpdating, UISearchControllerDelegate {

  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    guard let scopeButton = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] else { return }
    guard let searchText = searchBar.text else { return }
    filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
  }

  func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All") {
    guard let searchBarText = searchController.searchBar.text else { return }

    filteredCars = cars.filter { car in
      let scopeMatch = (scopeButton == "All" || car.model?.lowercased() == scopeButton.lowercased())
      
      if searchBarText != "" {
        guard let searchTextMatch = car.brand?.lowercased().contains(searchText.lowercased()) else { return scopeMatch }
        return scopeMatch && searchTextMatch
      } else {
        searchController.searchBar.scopeButtonTitles = ["All"]
        return scopeMatch
      }
    }
    searchController.searchBar.scopeButtonTitles = getModels(for: searchBarText)
    tableView.reloadData()
  }

  func getModels(for request: String) -> [String] {
    var results: [String] = ["All"]
    cars.forEach { car in
      if let model = car.model, let brand = car.brand {
        if !results.contains(model) && (brand.lowercased().contains(request.lowercased()) || request == "") {
          results.append(model)
        }
      }
    }
    return results
  }

}
