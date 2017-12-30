//
//  ViewController.swift
//  Locator
//
//  Created by Pkoolwijk on 27/12/2017.
//  Copyright © 2017 Blue Dolfin. All rights reserved.
//

import UIKit
import MapKit    // neede to use the locationmanager
import MessageUI // needed to send sms messages

class ViewController: UIViewController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {
    
    // global variables to hold position
    var myLatitude: Double?
    var myLongtitude: Double?
    var myAltitude: Double?
    
    // takes care of updating location
    let locationManager =  CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //**************** OUTLETS ****************
    
    //textfield for showing location
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longtitude: UITextField!
    @IBOutlet weak var altitude: UITextField!
    
    //Central map on screen
    @IBOutlet weak var map: MKMapView!
    
    
    // function on location manager to check if device is authorized to use GPS
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
        if status == .authorizedWhenInUse{
            print("GPS allowed")
            map.showsUserLocation = true
        }
        else{
            print("GPS not allowed")
            // create the alert
            let alert = UIAlertController(title: "No GPS", message: "Please allow location services and try again!", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    // function on location manager to update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //get coordinates from location manager and update testfields
        let myCoordinates = locationManager.location?.coordinate
        myAltitude = locationManager.location?.altitude
        myLatitude = myCoordinates?.latitude
        myLongtitude = myCoordinates?.longitude
        latitude.text = String(myLatitude!)
        longtitude.text = String(myLongtitude!)
        altitude.text = String(describing: Measurement(value: myAltitude!, unit: UnitLength.meters))
        
        // update map with zoomed in area from 10KM x 10KM
        let viewRegion = MKCoordinateRegionMakeWithDistance(myCoordinates!, 10000, 10000)
        self.map.setRegion(viewRegion, animated: false)
        
        
    }
    
    
    
    // **************** CODE FOR SOS BUTTON  ****************
    
    let messsageCompose = MFMessageComposeViewController()
    
    //function to check if user can send sms
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    //function to dimiss sms screen when sms is send
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    //function when SOS button is clicked
    @IBAction func sendSOS(_ sender: UIButton) {
        
        if canSendText() {
            
            print("sending SOS")
            
            //compese message with google link
            let googleLink = "https://www.google.com/maps/place/" + String(myLatitude!) + "+" + String(myLongtitude!)
            let SMStext = "EMERGENCY!!, Please rescue me from this location Latitude: " + String(myLatitude!) + " Longtitude: " + String(myLongtitude!) + "  " + googleLink
            let messsageCompose = MFMessageComposeViewController()
            messsageCompose.messageComposeDelegate = self
            messsageCompose.recipients = []
            messsageCompose.body = SMStext
            present(messsageCompose, animated: true, completion: nil)
            
        }else{
            // create the alert
            let alert = UIAlertController(title: "No SMS available.", message: "Please find a better location and try again!", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    
    
}




