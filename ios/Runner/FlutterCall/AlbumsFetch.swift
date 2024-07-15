//
//  AlbumsFetch.swift
//  Runner
//
//  Created by Winter Not Exist on 12/07/2024.
//

import Foundation
import UIKit
import Photos
import Flutter

class AlbumFetcherHandler: NSObject {
    private var flutterResult: FlutterResult?
    private weak var controller: FlutterViewController?

    init(controller: FlutterViewController) {
        super.init()
        self.controller = controller
    }

    func fetchAllAlbums(result: @escaping FlutterResult) {
        self.flutterResult = result
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.getAllAlbums()
            default:
                result(FlutterError(code: "PERMISSION_DENIED", message: "Photo library access denied", details: nil))
            }
        }
    }

    private func getAllAlbums() {
        let fetchOptions = PHFetchOptions()
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        
        var albums: [[String: Any]] = []

        userAlbums.enumerateObjects { (collection, _, _) in
            let album = ["title": collection.localizedTitle ?? "", "identifier": collection.localIdentifier]
            albums.append(album)
        }

        flutterResult?(albums)
    }
}
