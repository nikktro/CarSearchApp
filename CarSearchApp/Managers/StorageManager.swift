//
//  StorageManager.swift
//  CarSearchApp
//
//  Created by Nikolay Trofimov on 05.08.2023.
//

import Foundation
import CoreData

class StorageManager {

  static let shared = StorageManager()

  let context: NSManagedObjectContext

  private let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CarSearchApp")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  private init() {
    context = persistentContainer.viewContext
  }

  // MARK: Public methods
  func fetchData(completion: (Result<[Car], Error>) -> Void) {
    let fetchRequest = Car.fetchRequest()

    do {
      let cars = try context.fetch(fetchRequest)
      completion(.success(cars))
    } catch let error {
      completion(.failure(error))
    }
  }

  func save(_ newCarParameters: String..., completion: (Car) -> Void) {
    let car = Car(context: context)
    car.brand = newCarParameters[0]
    car.model = newCarParameters[1]
    car.body = newCarParameters[2]
    car.engine = newCarParameters[3]
    car.transmission = newCarParameters[4]
    car.price = Int64(newCarParameters[5]) ?? 0

    completion(car)
    savaContext()
  }

  func edit(_ car: Car, newCarParameters: String...) {
    car.brand = newCarParameters[0]
    car.model = newCarParameters[1]
    car.body = newCarParameters[2]
    car.engine = newCarParameters[3]
    car.transmission = newCarParameters[4]
    car.price = Int64(newCarParameters[5]) ?? 0
    savaContext()
  }

  func delete(_ car: Car) {
    context.delete(car)
    savaContext()
  }

  func savaContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch let error {
        print(error.localizedDescription)
      }
    }
  }

}
