//
//  CarTableViewCell.swift
//  CarSearchApp
//
//  Created by Nikolay Trofimov on 03.08.2023.
//

import UIKit

class CarTableViewCell: UITableViewCell {

  @IBOutlet weak var brandModelLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var engineLabel: UILabel!
  @IBOutlet weak var transmissionLabel: UILabel!

  func configure(with car: CarModel) {
    brandModelLabel.text = car.brand.rawValue + " " + car.model
    priceLabel.text = "🏷️ \(car.price) $"
    bodyLabel.text = car.body.rawValue
    engineLabel.text = car.engine.rawValue
    transmissionLabel.text = car.transmission.rawValue
  }

}
