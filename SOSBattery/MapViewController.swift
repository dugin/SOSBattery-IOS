//
//  MapViewController.swift
//  SOSBattery
//
//  Created by Rodrigo Dugin on 08/07/16.
//  Copyright © 2016 Point-Break Apps. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
     
   /*
     override func viewDidLoad() {
          super.viewDidLoad()
          
         print("viewDidLoad MAP")
          
          
          let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
          let myLocation =  appDelegate.myLocation
          
          let camera = GMSCameraPosition.cameraWithLatitude(myLocation!.coordinate.latitude,
                                                            longitude: myLocation!.coordinate.longitude, zoom: 15)
          
          var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
          mapView.myLocationEnabled = true
          self.view = mapView
          
          print(appDelegate.estArray.count)
          
          for est in appDelegate.estArray{
               
               
               
               let position = CLLocationCoordinate2DMake(est.coordenadas[0], est.coordenadas[1])
               print(position)
               let marker = GMSMarker(position: position)
               marker.title = est.nome
               marker.snippet = ListViewController().hrFuncionamento(est.hr_open, hrFecha: est.hr_close)
               marker.map = mapView
               
          }
          
          func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
               let infoWindow = NSBundle.mainBundle().loadNibNamed("InfoWindow", owner: self, options: nil).first! as! InfoWindow
               infoWindow.nome.text = "\(marker.position.latitude) \(marker.position.longitude)"
               return infoWindow
          }

          
          
     } */
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
          let myLocation =  appDelegate.myLocation

          
          let camera = GMSCameraPosition.cameraWithLatitude(myLocation!.coordinate.latitude,
                                                            longitude: myLocation!.coordinate.longitude, zoom: 15)
          let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
          mapView.myLocationEnabled = true
          mapView.delegate = self
          self.view = mapView
          
          for est in appDelegate.estArray{
               
               
               
               let position = CLLocationCoordinate2DMake(est.coordenadas[0], est.coordenadas[1])
               print(position)
               let marker = GMSMarker(position: position)
               marker.title = est.nome
               marker.snippet = ListViewController().hrFuncionamento(est.hr_open, hrFecha: est.hr_close)
               marker.icon = UIImage(named: "Bateria" )
               marker.userData = est.imgURL
               marker.map = mapView
               
               
               
          }
     }
     
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
     }
     
     func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
          let infoWindow = NSBundle.mainBundle().loadNibNamed("InfoWindow", owner: self, options: nil).first! as! InfoWindow
          
          infoWindow.nome.text = marker.title
          infoWindow.hrFunc.text = marker.snippet
          
          let url = NSURL(string: marker.userData as! String)
          let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
          infoWindow.logo.image  = UIImage(data: data!)
          
          
         
          
          return infoWindow
     }
     
     
     
     
}
