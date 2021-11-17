//
//  ImageCompressionHandler.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 11..
//

import UIKit

protocol ImageCompressionHandler {
    func compressImage(image: UIImage) -> Data?
}

extension ImageCompressionHandler {
    func compressImage(image: UIImage) -> Data? {
        var compressionQuality: CGFloat = 1.0
        let maxSize: Double = 2.0
        
        var compressedImage: Data
        var sizeInMB: Double
        
        repeat {
            compressedImage = image.jpegData(compressionQuality: compressionQuality)!
            let imageSize: Double = Double(compressedImage.count)
            sizeInMB = Double(imageSize) / 1024 / 1024;
            
            if compressionQuality < 0.01 {
                break
            }
            
            compressionQuality -= 0.2
            
        } while sizeInMB > maxSize
        
        return sizeInMB > maxSize ? nil : compressedImage
    }
}
