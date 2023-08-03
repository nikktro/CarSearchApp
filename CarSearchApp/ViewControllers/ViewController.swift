//
//  ViewController.swift
//  CarSearchApp
//
//  Created by Nikolay Trofimov on 03.08.2023.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
      self?.navigationController?.pushViewController(CarViewController() , animated: true)
    }
  }

}
