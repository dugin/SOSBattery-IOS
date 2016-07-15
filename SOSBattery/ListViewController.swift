//
//  ListViewController.swift
//  SOSBattery
//
//  Created by Rodrigo Dugin on 08/07/16.
//  Copyright © 2016 Point-Break Apps. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import GeoFire




class ListViewController: UITableViewController, CLLocationManagerDelegate{
     
     var locationManager = CLLocationManager()
     var myLocation: CLLocation!
     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
     @IBOutlet var tabelaView: UITableView!
     var ref: FIRDatabaseReference!
     var geoFire: GeoFire!
     var dataStore = [Estabelecimento]()
     let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
     
     var distArray = [Double]()
     
     override func viewDidLoad() {
          
         showLoadingSpinner()
          
          setTableInsets()
          
          self.ref = FIRDatabase.database().reference()
          let geoFireRef = ref.child("coordenadas")
          
           geoFire = GeoFire(firebaseRef: geoFireRef)

          
          
          askForLocationPermissions()
          
          super.viewDidLoad()
          
     }
     
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          
          return dataStore.count
     }
     
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
          let cell = self.tabelaView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
     
     roundCornerImage(cell.logoStore )
     
     
     
     cell.nameStore.text = dataStore[indexPath.row].nome
     cell.endStore.text = dataStore[indexPath.row].end
     cell.bairroStore.text = dataStore[indexPath.row].bairro
     cell.logoStore.image = UIImage(named: "No image")

     fetchImage( dataStore[indexPath.row].imgURL,  imageView: cell.logoStore)
     
     cell.distStore.text = "\(distanceInMetersToWalkTime(distArray[indexPath.row]) ) min"
   
     cell.workTimeStore.text = hrFuncionamento(dataStore[indexPath.row].hr_open, hrFecha: dataStore[indexPath.row].hr_close )
     
     return cell
     }
     
     func showLoadingSpinner(){
          myActivityIndicator.color = UIColor(rgba: "#589E3F")
          myActivityIndicator.center = view.center
          myActivityIndicator.startAnimating()
          view.addSubview(myActivityIndicator)
     }
     
     func hrFuncionamento(hrAbre: [String], hrFecha: [String]) -> String{
          
          switch getDayOfWeek() {
          case 0:
               return "\(hrAbre[2]) às \(hrFecha[2])"
          case 1:
               return "\(hrAbre[1]) às \(hrFecha[1])"
          case 2:
               return "\(hrAbre[0]) às \(hrFecha[0])"
          case 3:
               return "\(hrAbre[0]) às \(hrFecha[0])"
          case 4:
               return "\(hrAbre[0]) às \(hrFecha[0])"
          case 5:
               return "\(hrAbre[0]) às \(hrFecha[0])"
          case 6:
               return "\(hrAbre[0]) às \(hrFecha[0])"

          default:
               return "Fechado"
               
          }
        
         
          
     }
     
     func getDayOfWeek()->Int {
          
         
          let todayDate = NSDate()
          let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
          let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
          let weekDay = myComponents.weekday
          return weekDay
     }
     
     
     
     func setTableInsets(){
          
          let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
          let tabBarHeight = 49 as CGFloat
          let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: tabBarHeight , right: 0)
          tabelaView.contentInset = insets
          tabelaView.scrollIndicatorInsets = insets
          tabelaView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
          
     }
     
     func distanceInMetersToWalkTime(meters : Double) -> Int{
          let time = meters/1.5
          let min = Int(time/60)
          
          if min == 0{
               return 1}
          return min
     }
     
     func roundCornerImage(image: UIImageView){
          
          image.layer.cornerRadius = image.frame.size.width / 2;
          image.clipsToBounds = true
          
     }
     
     func fetchImage(imageURL: String, imageView: UIImageView){
     
     let url = NSURL(string: imageURL)
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
     if let data = NSData(contentsOfURL: url!)
     {//make sure your image in this url does exist, otherwise unwrap in a if let check
     dispatch_async(dispatch_get_main_queue(), {
     imageView.image = UIImage(data: data)
     });
          }
     }
     }
     func askForLocationPermissions (){
          
     
          // Ask for Authorisation from the User.
          self.locationManager.requestAlwaysAuthorization()
          
          // For use in foreground
          self.locationManager.requestWhenInUseAuthorization()
          
          if CLLocationManager.locationServicesEnabled() {
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
               locationManager.startUpdatingLocation()
               
               
          }

          
     }
     
     
     func noStoreNearby(){
          
          let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
          noDataLabel.text = "Sem Lojas ao redor"
          noDataLabel.textColor = UIColor(rgba: "#589E3F")

          noDataLabel.textAlignment = NSTextAlignment.Center
          self.tabelaView.separatorColor = UIColor.clearColor()
          self.tabBarController?.tabBar.hidden = true
          self.tabelaView.backgroundView = noDataLabel

     }
     
     func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          
          
           self.appDelegate.myLocation = locations[0]
          myLocation = locations[0]
          
          print(locations[0].coordinate)
          
          
          locationManager.stopUpdatingLocation()
          
          retrieveDataFromFirebase()
     }

     
         
     
     func retrieveDataFromFirebase()  {
          
          var myDictionary = [Double: String]()
          
         
          let circleQuery = geoFire.queryAtLocation(myLocation, withRadius: 5)
          
          circleQuery.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
              // print("Key '\(key)' entered the search area and is at location '\(location)'")
               
                let dist  = location.distanceFromLocation(self.myLocation)
                 myDictionary[dist] = key
               
               

          })
          
         
          circleQuery.observeReadyWithBlock({
               
             
               
               let distKeyDictionary = myDictionary.sort{ $0.0 < $1.0 }
               
               for (dist, id) in distKeyDictionary {
                    
                    self.distArray.append(dist)
               
               self.ref.child("estabelecimentos").child(id).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
               
                    let caboDict = snapshot.value!["cabo"] as! NSDictionary
                    
                    let cabo = Cabo.init(android: caboDict["android"] as! Bool, iphone: caboDict["iphone"] as! Bool)

                    let  store  = Estabelecimento.init(bairro: snapshot.value!["bairro"] as! String, cabo: cabo, cidade: snapshot.value!["cidade"] as! String, coordenadas: snapshot.value!["coordenadas"] as! [Double], createdAt: snapshot.value!["createdAt"] as! String, end: snapshot.value!["end"] as! String, estado: snapshot.value!["estado"] as! String,  hr_open: snapshot.value!["hr_open"] as! [String], hr_close: snapshot.value!["hr_close"] as! [String], id: snapshot.value!["id"] as! String, imgURL: snapshot.value!["imgURL"] as! String, modifiedAt: snapshot.value!["modifiedAt"] as! String, nome: snapshot.value!["nome"] as! String, tipo: snapshot.value!["tipo"] as! String, wifi: snapshot.value!["wifi"] as! Bool, wifi_SSID: snapshot.value!["wifi_SSID"] as! String, wifi_senha: snapshot.value!["wifi_senha"] as! String)
                    
                    
                    self.dataStore.append(store)
                    
                   self.appDelegate.estArray.append(store)
                    
                    self.tabelaView.reloadData()
                    
                  
                    
                    
               }) { (error) in
                    print(error.localizedDescription)
               }
                    
                    
                    
               }
               
               self.myActivityIndicator.stopAnimating()
               
               
               let tabBarControllerMap = self.tabBarController?.tabBar
             let tabItemMap = tabBarControllerMap!.items![1]
              tabItemMap.enabled = true
               
               if self.dataStore.count == 0{
               self.noStoreNearby()
               }
               
                
          })
          
     
     
     }

     

     
}
