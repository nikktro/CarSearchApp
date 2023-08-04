//
//  CarViewController.swift
//  CarSearchApp
//
//  Created by Nikolay Trofimov on 03.08.2023.
//

import UIKit

typealias TableViewProtocols = UITableViewDelegate & UITableViewDataSource

class CarViewController: UIViewController {

  private var tableView: UITableView!
  private var cars = CarModel.getCarList().shuffled()
  private var priceAscending = true

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupTableViewDelegateAndDataSource()
  }

}

private extension CarViewController {

  func setup() {
    setupUI()
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
    present(UINavigationController(rootViewController:AddCarViewController(vcTitle: "Add Car")), animated: true)
  }

  @objc func sortTapped() {
    priceAscending ? cars.sort { $0.price < $1.price } : cars.sort { $0.price > $1.price }
    priceAscending.toggle()
    tableView.reloadData()
  }

}

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
