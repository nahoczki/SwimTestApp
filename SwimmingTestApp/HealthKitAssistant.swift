//
//  HealthKitAssistant.swift
//  SwimmingTestApp
//
//  Created by Zoli Nahoczki on 11/1/21.
//

import Foundation
import HealthKit

class HealthKitAssistant {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    public class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        guard let swimDistance = HKObjectType.quantityType(forIdentifier: .distanceSwimming) else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }
        
        guard let energyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }
        
        let healthKitTypesToWrite: Set<HKSampleType> = [swimDistance,
                                                        energyBurned,
                                                        HKObjectType.workoutType()]
        
        let healthKitTypesToRead: Set<HKObjectType> = [swimDistance,
                                                       energyBurned,
                                                       HKObjectType.workoutType()]
        
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
        
    }
    
    
    public class func saveSwim(swimWorkout: SwimWorkout,
                               completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        let healthStore = HKHealthStore()
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .swimming
        
        let builder = HKWorkoutBuilder(healthStore: healthStore,
                                       configuration: workoutConfiguration,
                                       device: .local())
        
        builder.beginCollection(withStart: swimWorkout.startDate) { (success, error) in
          guard success else {
            completion(false, error)
            return
          }
            
            // MARK: Active energy burned
            guard let burnedQuantityType = HKQuantityType.quantityType(
                forIdentifier: .activeEnergyBurned) else {
              completion(false, nil)
              return
            }
                
            let burnedUnit = HKUnit.kilocalorie()
            let energyBurned = swimWorkout.energyBurned
            let burnedQuantity = HKQuantity(unit: burnedUnit,
                                            doubleValue: energyBurned)
            
            let burnedSample = HKCumulativeQuantitySample(type: burnedQuantityType,
                                                          quantity: burnedQuantity,
                                                          start: swimWorkout.startDate,
                                                          end: swimWorkout.endDate)
            
            // MARK: Distance swam
            
            guard let distanceQuantityType = HKQuantityType.quantityType(
                forIdentifier: .distanceSwimming) else {
                completion(false, nil)
                return
            }
            
            let swimUnit = HKUnit.meter()
            let distance = swimWorkout.distance
            let swimQuantity = HKQuantity(unit: swimUnit,
                                          doubleValue: distance)
            
            let swimDistanceSample = HKCumulativeQuantitySample(type: distanceQuantityType,
                                                                quantity: swimQuantity,
                                                                start: swimWorkout.startDate,
                                                                end: swimWorkout.endDate)
            
            //1. Add the sample to the workout builder
            builder.add([burnedSample, swimDistanceSample]) { (success, error) in
              guard success else {
                completion(false, error)
                return
              }
                  
              //2. Finish collection workout data and set the workout end date
              builder.endCollection(withEnd: swimWorkout.endDate) { (success, error) in
                guard success else {
                  completion(false, error)
                  return
                }
                    
                //3. Create the workout with the samples added
                builder.finishWorkout { (_, error) in
                  let success = error == nil
                  completion(success, error)
                }
              }
            }
        }
    }
}
