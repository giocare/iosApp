//
//  JobInfo+CoreDataProperties.swift
//  
//
//  Created by jess on 5/7/20.
//
//

import Foundation
import CoreData

extension JobInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JobInfo> {
        return NSFetchRequest<JobInfo>(entityName: "JobInfo")
    }

    @NSManaged public var position: String?
    @NSManaged public var company: String?
    @NSManaged public var location: String?
    @NSManaged public var logo: String?
    @NSManaged public var date: Date?
    


}
