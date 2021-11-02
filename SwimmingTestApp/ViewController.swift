//
//  ViewController.swift
//  SwimmingTestApp
//
//  Created by Zoli Nahoczki on 11/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    /*
     let options: = {
                         type: "Swimming",
                         startDate:"2021-11-01T14:48:00.000Z",
                         endDate: "2021-11-01T15:48:00.000Z",
                         energyBurned: 54,
                         energyBurnedUnit: 'calorie',
                         distance: 220,
                         distanceUnit: 'meter'
                     }
     */

    
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var distanceTextBox: UITextField!
    @IBOutlet weak var caloriesTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HealthKitAssistant.authorizeHealthKit { (result, error) in
                    if result {
                        print("Auth ok")
                    } else {
                        print("Auth denied")
                    }
                    
                }
        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let swimWorkout = SwimWorkout(startDate: startDatePicker.date,
                                      endDate: endDatePicker.date,
                                      energyBurned: Double(caloriesTextBox.text!) ?? 0.0,
                                      distance: Double(distanceTextBox.text!) ?? 0.0)
        
        HealthKitAssistant.saveSwim(swimWorkout: swimWorkout) { success, err in
            if let err = err {
                print(err)
            } else {
                print("saved ", success)
            }
        }
    }
    
    
}

