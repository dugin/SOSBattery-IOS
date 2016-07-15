//
//  Cabo.swift
//  SOSBattery
//
//  Created by Rodrigo Dugin on 10/07/16.
//  Copyright © 2016 Point-Break Apps. All rights reserved.
//

import UIKit

class Cabo: NSObject {
     
     var android : Bool
     var iphone : Bool
     
     init(android : Bool, iphone: Bool) {
          self.android = android
          self.iphone = iphone
     }

}
