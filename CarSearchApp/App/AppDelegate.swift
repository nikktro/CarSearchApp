//
//  AppDelegate.swift
//  CarSearchApp
//
//  Created by Nikolay Trofimov on 03.08.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.backgroundColor = .systemBackground

    let navigationViewController = UINavigationController(rootViewController: ViewController())
    window?.rootViewController = navigationViewController

    firstRun()

    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    StorageManager.shared.savaContext()
  }

  func firstRun() {
    let userDefaults = UserDefaults.standard
    let defaultValues = ["firstRun" : true]
    userDefaults.register(defaults: defaultValues)

    if userDefaults.bool(forKey: "firstRun") {
      for _ in 1...12 {
        let car = CarModel.getRandomCar()
        StorageManager.shared.save(car.brand, car.model, car.body, car.engine, car.transmission, car.price) { car in
          print("new car is added \(car)")
        }
      }
      userDefaults.set(false, forKey: "firstRun")
    }
  }

}

