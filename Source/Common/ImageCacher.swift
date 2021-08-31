//
//  ImageCacher.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import UIKit

final class ImageCacher {
    static let sharedCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "ImageCacher"
        cache.countLimit = 20
        cache.totalCostLimit = 900 * 1024 * 1024
        return cache
    }()

    func cachedImage(key: String) -> UIImage? {
        return ImageCacher.sharedCache.object(forKey: key as NSString)
    }

    func cacheImage(image: UIImage, key: String) {
        ImageCacher.sharedCache.setObject(image, forKey: key as NSString)
    }
}
