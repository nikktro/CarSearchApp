//
//  CarModel.swift
//  CarSearchApp
//
//  Created by Nikolay Trofimov on 03.08.2023.
//

import Foundation

struct CarModel {
  let brand: Brand
  let model: String
  let body: Body
  let engine: Engine
  let transmission: Transmission
  var price = price()

  static func getCarList() -> [CarModel] {
    var cars: [CarModel] = []

    cars.append(CarModel(brand: .volvo, model: "C30", body: .hatback, engine: .gasoline, transmission: .automatic))
    cars.append(CarModel(brand: .volvo, model: "S40", body: .sedan, engine: .gasoline, transmission: .automatic))
    cars.append(CarModel(brand: .mazda, model: "CX5", body: .suv, engine: .gasoline, transmission: .automatic))
    cars.append(CarModel(brand: .citroen, model: "DS4", body: .sedan, engine: .gasoline, transmission: .mechanical))
    cars.append(CarModel(brand: .mazda, model: "3", body: .sedan, engine: .gasoline, transmission: .mechanical))
    cars.append(CarModel(brand: .mazda, model: "CX3", body: .hatback, engine: .gasoline, transmission: .automatic))
    cars.append(CarModel(brand: .volvo, model: "D40", body: .hatback, engine: .electric, transmission: .automatic))
    cars.append(CarModel(brand: .citroen, model: "C4", body: .sedan, engine: .gasoline, transmission: .automatic))
    cars.append(CarModel(brand: .citroen, model: "C3", body: .hatback, engine: .gasoline, transmission: .mechanical))
    cars.append(CarModel(brand: .mazda, model: "C30", body: .hatback, engine: .electric, transmission: .automatic))
    cars.append(CarModel(brand: .citroen, model: "DS3", body: .hatback, engine: .gasoline, transmission: .mechanical))

    return cars
  }

  private static func price() -> Int {
    return Int.random(in: 10000...50000)
  }

}

enum Brand: String {
  case mazda = "Mazda"
  case volvo = "Volvo"
  case citroen = "Citroen"
}

enum Body: String {
  case sedan = "Sedan"
  case hatback = "Hatback"
  case wagon = "Wagon"
  case suv = "SUV"
}

enum Engine: String {
  case gasoline = "Gasoline"
  case diesel = "Diesel"
  case electric = "Electric"
}

enum Transmission: String {
  case automatic = "Automatic"
  case mechanical = "Mechanical"
}
