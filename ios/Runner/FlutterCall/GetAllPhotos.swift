//
//  GetAllPhotos.swift
//  Runner
//
//  Created by Winter Not Exist on 12/07/2024.
//

import Foundation
import UIKit
import Photos
import Flutter

class ImageFetcherHandler: NSObject {
    private var flutterResult: FlutterResult?
    private weak var controller: FlutterViewController?

    init(controller: FlutterViewController) {
        super.init()
        self.controller = controller
    }

    func fetchImagesFromAlbum(albumName: String, result: @escaping FlutterResult) {
        self.flutterResult = result
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.getImagesFromAlbum(albumName: albumName)
            default:
                result(FlutterError(code: "PERMISSION_DENIED", message: "Photo library access denied", details: nil))
            }
        }
    }

    private func getImagesFromAlbum(albumName: String) {
        var album: PHAssetCollection?
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        collections.enumerateObjects { (collection, _, _) in
            album = collection
        }
        
        guard let assetCollection = album else {
            flutterResult?(FlutterError(code: "ALBUM_NOT_FOUND", message: "Album not found", details: nil))
            return
        }

        let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        var imageArray: [FlutterStandardTypedData] = []

        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true

        assets.enumerateObjects { (asset, _, _) in
            imageManager.requestImageData(for: asset, options: options) { (data, _, _, _) in
                if let data = data {
                    imageArray.append(FlutterStandardTypedData(bytes: data))
                }
            }
        }

        flutterResult?(imageArray)
    }
}
