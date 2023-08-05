//
//  AddCarViewController.swift
//  CarSearchApp
//
//  Created by Nikolay Trofimov on 04.08.2023.
//

import UIKit

class AddCarViewController: UIViewController{

  var vcTitle: String

  var delegate: AddCarViewControllerDelegate?

  private lazy var brandTextField: UITextField = {
    addTextField("Brand")
  }()

  private lazy var modelTextField: UITextField = {
    addTextField("Model")
  }()

  private lazy var bodyTextField: UITextField = {
    addTextField("Body")
  }()

  private lazy var engineTextField: UITextField = {
    addTextField("Engine")
  }()

  private lazy var transmissionTextField: UITextField = {
    addTextField("Transmission")
  }()

  private lazy var priceTextField: UITextField = {
    addTextField("Price")
  }()

  private lazy var saveButton: UIButton = {
    let buttonColor = UIColor(red: 42/255, green: 142/255, blue: 209/255, alpha: 1)
    return addButton(title: "Save", color: buttonColor, action: #selector(save))
  }()

  init(vcTitle: String) {
    self.vcTitle = vcTitle
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func addTextField(_ placeholder: String) -> UITextField{
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.borderStyle = .roundedRect
    return textField
  }

  private func addButton(title: String, color: UIColor, action: Selector) -> UIButton {
    let button = UIButton()
    button.backgroundColor = color
    button.setTitle("\(title)", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 4
    button.addTarget(self, action: action, for: .touchUpInside)
    return button
  }

}

private extension AddCarViewController {

  func setupUI() {
    view.backgroundColor = .white
    setupNavBar()
    setupSubviews()
    setConstraints()
  }

  func setupNavBar() {
    title = vcTitle
    let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    navigationItem.leftBarButtonItem = cancel
    navigationController?.navigationBar.tintColor = UIColor.orange
  }

  func setupSubviews() {
    addSubviews(brandTextField, modelTextField, bodyTextField, engineTextField, transmissionTextField, priceTextField, saveButton)
  }

  func setConstraints() {
    layoutConstraint(from: brandTextField, to: view, constraint: -view.bounds.height + 150)
    layoutConstraint(from: modelTextField, to: brandTextField, constraint: 40)
    layoutConstraint(from: bodyTextField, to: modelTextField, constraint: 40)
    layoutConstraint(from: engineTextField, to: bodyTextField, constraint: 40)
    layoutConstraint(from: transmissionTextField, to: engineTextField, constraint: 40)
    layoutConstraint(from: priceTextField, to: transmissionTextField, constraint: 40)
    layoutConstraint(from: saveButton, to: priceTextField, constraint: 40)
  }

  func addSubviews(_ subviews: UIView...) {
    subviews.forEach { subview in
      view.addSubview(subview)
      subview.translatesAutoresizingMaskIntoConstraints = false
    }
  }

  func layoutConstraint(from child: UIView, to parent: UIView, constraint: CGFloat) {
    NSLayoutConstraint.activate([
      child.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: constraint),
      child.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      child.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
    ])
  }

  @objc func save() {
    guard let brand = brandTextField.text, brand.count > 0 else { return }
    guard let model = modelTextField.text, model.count > 0 else { return }
    guard let body = bodyTextField.text, body.count > 0 else { return }
    guard let engine = engineTextField.text, engine.count > 0 else { return }
    guard let transmission = transmissionTextField.text, transmission.count > 0 else { return }
    guard let price = priceTextField.text, let priceInt = Int(price), priceInt > 0 else { return }

    StorageManager.shared.save(brand, model, body, engine, transmission, price) { car in
      delegate?.appendTable(with: car)
    }
    dismiss(animated: true)
  }

  @objc func cancel() {
    dismiss(animated: true)
  }

}