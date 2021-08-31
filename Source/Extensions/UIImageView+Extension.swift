//
//  UIImageView+Extension.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 31/8/21.
//

import UIKit

extension UIImageView {
    func setImageURL(_ url: URL,
                     placeholderImage: UIImage? = nil,
                     transitionDuration: TimeInterval = 0.5) {
        if let cachedImage = ImageCacher().cachedImage(key: url.absoluteString) {
            image = cachedImage
            return
        }

        image = placeholderImage

        let networkService = JBNetworkService()
        networkService.getImage(withURL: url) { result in
            switch result {
            case .success(let image):
                UIView.transition(with: self, duration: transitionDuration, options: .transitionCrossDissolve) {
                    self.image = image
                }
            default:
                break
            }
        }
    }
}
