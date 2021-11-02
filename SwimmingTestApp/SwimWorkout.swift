//
//  SwimWorkout.swift
//  SwimmingTestApp
//
//  Created by Zoli Nahoczki on 11/1/21.
//

import Foundation

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

struct SwimWorkout {
    var startDate: Date
    var endDate: Date
    var energyBurned: Double
    var distance: Double
}
