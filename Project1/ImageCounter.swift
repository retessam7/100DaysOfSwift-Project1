//
//  ImageCounter.swift
//  Project1
//
//  Created by VII on 18.01.2025.
//

import UIKit

class ImageCounter: NSObject, Codable {
    static let shared = ImageCounter()  // Синглтон, доступный через .shared
    var fileNameCounter = [String: Int]()
}
