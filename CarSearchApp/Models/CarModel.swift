//
//  CarModel.swift
//  CarSearchApp
//
//  Created by Nikolay Trofimov on 03.08.2023.
//

import Foundation

struct CarModel {
  let brand: String
  let model: String
  let body: String
  let engine: String
  let transmission: String
  var price: String

  static func getRandomCar() -> CarModel {
    CarModel(brand: ["Volvo", "Mazda", "Citroen"].randomElement() ?? "",
             model: ["C30", "S40", "CX5", "CX9", "DS3", "DS4", "DS5"].randomElement() ?? "",
             body: ["Hatch", "Sedan", "Wagon", "SUV"].randomElement() ?? "",
             engine: ["2.0 Gasoline", "2.5 Gasoline", "2.0 Diesel", "2.4 Diesel", "Electric" ].randomElement() ?? "",
             transmission: ["Automatic", "Variator", "Mechanical"].randomElement() ?? "",
             price: String(Int.random(in: 10000...50000)))
  }

}
