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
  var price = price()

  static func getCarList() -> [CarModel] {
    var cars: [CarModel] = []

    cars.append(CarModel(brand: "Volvo", model: "C30", body: "hatback", engine: "gasoline", transmission: "automatic"))
    cars.append(CarModel(brand: "Volvo", model: "S40", body: "sedan", engine: "gasoline", transmission: "automatic"))
    cars.append(CarModel(brand: "Mazda", model: "CX5", body: "suv", engine: "gasoline", transmission: "automatic"))
    cars.append(CarModel(brand: "Citroen", model: "DS4", body: "sedan", engine: "gasoline", transmission: "mechanical"))
    cars.append(CarModel(brand: "Mazda", model: "3", body: "sedan", engine: "gasoline", transmission: "mechanical"))
    cars.append(CarModel(brand: "Mazda", model: "CX3", body: "hatback", engine: "gasoline", transmission: "automatic"))
    cars.append(CarModel(brand: "Volvo", model: "D40", body: "hatback", engine: "electric", transmission: "automatic"))
    cars.append(CarModel(brand: "Citroen", model: "C4", body: "sedan", engine: "gasoline", transmission: "automatic"))
    cars.append(CarModel(brand: "Citroen", model: "C3", body: "hatback", engine: "gasoline", transmission: "mechanical"))
    cars.append(CarModel(brand: "Mazda", model: "C30", body: "hatback", engine: "electric", transmission: "automatic"))
    cars.append(CarModel(brand: "Citroen", model: "DS3", body: "hatback", engine: "gasoline", transmission: "mechanical"))

    return cars
  }

  private static func price() -> Int {
    return Int.random(in: 10000...50000)
  }

}
