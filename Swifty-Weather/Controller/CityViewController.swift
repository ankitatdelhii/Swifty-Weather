//
//  CityViewController.swift
//  Swifty-Weather
//
//  Created by Ankit Saxena on 15/02/19.
//  Copyright © 2019 Ankit Saxena. All rights reserved.
//

import UIKit

protocol cityNamePr {
    func changeCityName(name: String)
}

class CityViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    var delegate : cityNamePr?
    var cityName : String?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func getWeatherPressed(_ sender: UIButton) {
        cityName = cityTextField.text!
        guard let cName = cityName else{
            fatalError("Nil city Name")
        }
        delegate?.changeCityName(name: cName)
        
        self.dismiss(animated: true, completion: nil)
    }

}
