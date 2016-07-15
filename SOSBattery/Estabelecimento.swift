//
//  Estabelecimento.swift
//  SOSBattery
//
//  Created by Rodrigo Dugin on 10/07/16.
//  Copyright © 2016 Point-Break Apps. All rights reserved.
//

import UIKit

class Estabelecimento: NSObject {
     
     var bairro : String
     var cabo : Cabo
     var cidade : String
     var coordenadas : [Double]
     var createdAt : String
     var end : String
     var estado : String
     var hr_open : [String]
     var hr_close : [String]
     var id : String
     var imgURL : String
     var modifiedAt : String
     var nome : String
     var tipo : String
     var wifi : Bool
     var wifi_SSID : String
     var wifi_senha : String
     
     
     init(bairro : String, cabo : Cabo, cidade : String, coordenadas : [Double], createdAt : String, end : String, estado : String, hr_open : [String], hr_close : [String], id : String, imgURL : String, modifiedAt : String, nome : String, tipo : String, wifi : Bool, wifi_SSID : String, wifi_senha : String) {
          
          
          self.bairro = bairro
          self.cabo = cabo
          self.cidade = cidade
          self.coordenadas = coordenadas
          self.createdAt = createdAt
          self.end = end
          self.estado = estado
          self.hr_open = hr_open
          self.hr_close = hr_close
          self.id = id
          self.imgURL = imgURL
          self.modifiedAt = modifiedAt
          self.nome = nome
          self.tipo = tipo
          self.wifi = wifi
          self.wifi_SSID = wifi_SSID
          self.wifi_senha = wifi_senha
     }}
