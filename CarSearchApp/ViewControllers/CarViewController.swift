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
  private var priceAscending = true

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
    cars.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "auto", for: indexPath) as! CarTableViewCell
    cell.configure(with: cars[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CarViewController {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let car = cars[indexPath.row]

    let carDetailsVC = CarDetailsViewController(vcTitle: "Edit Car", car: car, rowSelected: indexPath)
    carDetailsVC.delegate = self
    present(UINavigationController(rootViewController: carDetailsVC), animated: true)
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      StorageManager.shared.delete(cars[indexPath.row])
      cars.remove(at: indexPath.row)
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

