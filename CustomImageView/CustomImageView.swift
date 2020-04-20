//
//  CustomImageView.swift
//  NewsApp
//
//  Created by Kautsya Kanu on 31/12/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import UIKit
import CoreData

enum Source { case cache, core, remote }
struct ImageData {
    let urlString: String
    var image: UIImage
    let source: Source
}

public class CustomImageView: UIImageView {
    //FIXME: CIVImage issue between widget and mainApp
    //model not from same context
    //MARK: Properties
    static public let shared = CustomImageView()
    private var urlString = ""
    let noImage = UIImage(named: "NoImage.png",
                          in: Bundle(for: CustomImageView.self), with: nil)!
    
    //MARK: Elements
    private var loader: UIActivityIndicatorView!
    
    //MARK:- IBInspectable
    @IBInspectable var shouldPersist: Bool = false
    @IBInspectable var expirationTime: Int = 0
    
    private init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        let _ = CoreDataManager.shared
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
    public static func clearOldData() {
        CoreDataManager.performOnBackground({
            context in
            let imageDeleteRequest = CIVImage.deleteAll(in: context)
            _ = try? context.execute(imageDeleteRequest)
        })
        imageCache.removeAllObjects()
    }
    
    public func setImage(with url: URL?) {
        setImage(with: url?.absoluteString)
    }
    
    public func setImage(with urlString: String?) {
        guard let urlString = urlString else {
            image = noImage
            return
        }
        image = nil
        self.urlString = urlString
        
        loader.startAnimating()
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            guard let self = self else { return }
            self.fetchCacheImage(from: urlString, completion: {
                imageData in
                if imageData.urlString == self.urlString {
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.setImage(imageData)
                    }
                }
            })
        }
    }
}

//MARK:- Helpers
extension CustomImageView {
    private func setImage(_ imageData: ImageData) {
        loader.stopAnimating()
        switch imageData.source {
        case .cache:
            image = imageData.image
        default:
            animate(image: imageData.image)
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
