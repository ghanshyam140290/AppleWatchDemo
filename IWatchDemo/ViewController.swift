//
//  ViewController.swift
//  IWatchDemo
//
//  Created by Santosh Maurya on 26/06/18.
//  Copyright © 2018 Santosh Maurya. All rights reserved.
//

import HealthKit
import UIKit
import WatchConnectivity
let healthKitStore: HKHealthStore = HKHealthStore()
private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
class ViewController: UIViewController {

    @IBOutlet var lbl_BloodType: UILabel!
    @IBOutlet var lbl_Age: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var validSession: WCSession? {
            
            // Adapted from https://gist.github.com/NatashaTheRobot/6bcbe79afd7e9572edf6
            
            #if os(iOS)
            if let session = session, session.isPaired && session.isWatchAppInstalled {
                return session
            }
            #elseif os(watchOS)
            return session
            #endif
            return nil
        }
        
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func autorizationAction(_ sender: Any) {
        self.authorizeKitInApp()
        
    }
    
    @IBAction func getDetail(_ sender: Any) {
        let (age, bloodType) = self.readProfile()
        
        self.lbl_Age.text = "\(String(describing:age!))"
        self.lbl_BloodType.text = self.getReadablebloodType(bloodType: bloodType?.bloodType)
        
        
        
    }
    
    func authorizeKitInApp() {
        
        let healthKitTypeToRead : Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier:HKCharacteristicTypeIdentifier.dateOfBirth)!,
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
        HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKSampleType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKSampleType.workoutType(),
        
    ]
        let healthKitTypesToWrite : Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.workoutType()]
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Error Accurred")
            return
        }
        
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypeToRead) { (success, error) in
          //  self.delegate?.workout(manager: self, didAuthorizeAccess: success,error: error)
            print("Read Write Authorization Scceeded")
        }
        
    }
    
    
    func readProfile() -> (age:Int?, bloodType:HKBloodTypeObject?) {
        var age : Int?
        var bloodType:HKBloodTypeObject?
        
        // Read Age
        do {
            let birthday = try healthKitStore.dateOfBirthComponents()
           
            
            let calendar  = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            
            age = currentYear - birthday.year!
            
        
            
        }catch{}
        
        // Read Blood Type
        do {
            
            bloodType = try healthKitStore.bloodType()
            
            
            
        } catch{ }
        
        return (age, bloodType)
    }

    
    func getReadablebloodType(bloodType:HKBloodType?) -> String {
        var bloodTypeText = ""
        if bloodType != nil
        {
            
            switch(bloodType!){
                
                case .aPositive:
                bloodTypeText = "A+"
                
            case .notSet:
                  bloodTypeText = "Not Set"
            case .aNegative:
                 bloodTypeText = "A-"
            case .bPositive:
                 bloodTypeText = "B+"
            case .bNegative:
                 bloodTypeText = "B-"
            case .abPositive:
                 bloodTypeText = "AB+"
            case .abNegative:
                 bloodTypeText = "AB-"
            case .oPositive:
                 bloodTypeText = "O-"
            case .oNegative:
                 bloodTypeText = "O+"
            default:
                    break
                
            }
            
        }
        return bloodTypeText
    }
    
}
