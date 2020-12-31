//
//  BoughtTicket+CoreDataProperties.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 11/24/20.
//
//

import Foundation
import CoreData


extension BoughtTicket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BoughtTicket> {
        return NSFetchRequest<BoughtTicket>(entityName: "BoughtTicket")
    }

    @NSManaged public var movieName: String
    @NSManaged public var price: String
    @NSManaged public var cinemaName: String
    @NSManaged public var time: String
    @NSManaged public var place: String
}

extension BoughtTicket : Identifiable {

}
