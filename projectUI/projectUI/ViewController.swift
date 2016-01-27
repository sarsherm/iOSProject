//
//  ViewController.swift
//  projectUI
//
//  Created by Sarah Sherman on 1/26/16.
//  Copyright © 2016 Sarah Sherman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, CancelButtonDelegate, MKMapViewDelegate, UISearchBarDelegate {
    
    var locationManager: CLLocationManager!
    var location: CLLocation?
    
    var tableIsFoundItems = true
    var searchActive : Bool = false
    
    var items = [Item(name: "shoes", latitude: 47.611588, longitude: -122.196994, distance: 5, zipCode: 98004, details: "size 6", dateListed: "12/29/15", found: 0), Item(name: "shirt", latitude: 47.61067, longitude: -122.203068, distance: 5, zipCode: 98052, details: "blue, size small", dateListed: "1/14/16", found: 10), Item(name: "earrings", latitude: 49.000345, longitude: -122.197000, distance: 6, zipCode: 98008, details: "diamonds", dateListed: "1/20/16", found: 2)]
    
    var tableItems = [Item]()
    
    var tempTable = [Item]()
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func foundButtonPressed(sender: UIButton) {
        if tableIsFoundItems == false {
            tableItems = []
            for var i = 0; i < items.count; ++i {
                if items[i].found != 0 {
                    tableItems.append(items[i])
                }
            }
            tableView.reloadData()
        }
        tableIsFoundItems = true
        
    }
    
    @IBAction func notFoundButtonPressed(sender: UIButton) {
        if tableIsFoundItems == true {
            tableItems = []
            for var i = 0; i < items.count; ++i {
                if items[i].found == 0 {
                    tableItems.append(items[i])
                }
            }
            tableView.reloadData()
        }
        tableIsFoundItems = false
    }
    
    
    @IBOutlet weak var searchOutlet: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        map.delegate = self
        searchOutlet.delegate = self

        
        for var i = 0; i < items.count; ++i {
            if items[i].found != 0 {
                tableItems.append(items[i])
                print(items[i].details)
            }
        }
        
        tempTable = tableItems
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  //later change to kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //        let userCoordinate = mapView.userLocation.coordinate
        //        print(userCoordinate)
//        print("Current Location from CL: ", locationManager.location)
        
        let currentLocation = locationManager.location
        
        let location2D = CLLocationCoordinate2D(
            latitude: currentLocation!.coordinate.latitude,
            longitude: currentLocation!.coordinate.longitude
        )
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        
        let region = MKCoordinateRegion(center: location2D, span: span)
        
        map.setRegion(region, animated: true)
        let annotation = Pin(coordinate: location2D)
        annotation.title = "User"
        annotation.type = "User"
        map.addAnnotation(annotation)
        
        
        
        mapView(map, viewForAnnotation: annotation)
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Pin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                view.pinTintColor = annotation.pinColor()
                print(view.pinTintColor)
            }
            return view
        }
        return nil
    }
    
    // location stuffs
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[locations.count-1] as CLLocation
       
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        
    }
  
    
    
    
    //table view stuffs
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell")! as! ItemCell
        let item = tableItems[indexPath.row]
        print(item.details)
        print(tableItems[indexPath.row].details)
        cell.zipCodeLabel.text = String(item.zipCode)
        cell.detailsLabel.text = String(item.details)
        cell.dateListedLabel.text = String(item.dateListed)
        cell.numberFoundLabel.text = String(item.found)
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    //segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navigationController = segue.destinationViewController as! UINavigationController
        let controller = navigationController.topViewController as! AddItemViewController
        controller.cancelButtonDelegate = self
        
    }

    
    // navigation functions
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        removeAnnotations()
        addItemAnnotation(tableItems[indexPath.row])
        
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
       print("hi")
    }
 
    
    func addItemAnnotation(item: Item){
        print(item.details)
        let itemAnnotation = MKPointAnnotation()
        let itemLocation2D = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        itemAnnotation.coordinate = itemLocation2D
        print(item.name)
        itemAnnotation.title = item.name
        self.map.addAnnotation(itemAnnotation)
        self.map.selectAnnotation(itemAnnotation,animated:true)
        
    }
    
    func removeAnnotations() {
        var annotationsToRemove = [MKAnnotation]()
        for var i = 0; i < map.annotations.count; ++i {
            if map.annotations[i].title! != "User" {
                annotationsToRemove.append(map.annotations[i])
            }
        }
        map.removeAnnotations(annotationsToRemove)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    //search functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print(tableItems)
        
        tempTable = tableItems
        print(tempTable)
        tableItems = []
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchOutlet.text! = ""
        dismissKeyboard()
        tableItems = tempTable
        self.tableView.reloadData()
        searchActive = false;
    }

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
         tableItems = items.filter({ (Item) -> Bool in
            let tmp: NSString = NSString(string: Item.name)
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        
        if(tableItems.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }


}

