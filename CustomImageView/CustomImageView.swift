//
//  CustomImageView.swift
//  NewsApp
//
//  Created by Kautsya Kanu on 31/12/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import UIKit
import CoreData

public class CustomImageView: UIImageView {
    //FIXME: CIVImage issue between widget and mainApp
    //model not from same context
    //MARK: Properties
    enum Source { case cache, core, remote }
    struct ImageData {
        let urlString: String
        var image: UIImage
        let source: Source
    }
    private var urlString = ""
    
    //MARK: Elements
    private var loader: UIActivityIndicatorView!
    
    //MARK:- IBInspectable
    @IBInspectable var shouldPersist: Bool = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoader()
    }
    
    private func setupLoader() {
        loader = UIActivityIndicatorView()
        addSubview(loader)
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

//MARK:- Available Functions
extension CustomImageView {
    public static func saveAllData() {
        CoreDataStack.shared.save()
    }
    
    public static func clearOldData() {
        let context = CoreDataStack.shared.CIVContext
        let imageDeleteRequest = CIVImage.deleteAll()
        _ = try? context.execute(imageDeleteRequest)
        imageCache.removeAllObjects()
    }
    
    public func setImage(with url: URL?) {
        setImage(with: url?.absoluteString)
    }
    
    public func setImage(with urlString: String?) {
        guard let urlString = urlString else {
            image = #imageLiteral(resourceName: "NoImage.png")
            return
        }
        self.urlString = urlString
        
        loader.startAnimating()
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            guard let self = self else { return }
            self.fetchCacheImage(from: urlString, completion: {
                imageData in
                if imageData.urlString == self.urlString { self.setImage(imageData) }
            })
        }
    }
    
    private func setImage(_ imageData: ImageData) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            self.loader.stopAnimating()
            switch imageData.source {
            case .cache:
                self.image = imageData.image
            default:
                self.animate(image: imageData.image)
            }
        }
    }
    
    private func animate(image: UIImage?) {
        let options: UIView.AnimationOptions = [.transitionCrossDissolve]
        UIView.transition(with: self, duration: 0.5, options: options, animations: {
            [weak self] in
            self?.image = image
            }, completion: nil)
    }
}
