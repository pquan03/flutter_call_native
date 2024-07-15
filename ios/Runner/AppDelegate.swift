import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var imagePicker: ImagePicker?
    private var allPhotos: ImageFetcherHandler?
    private var albumsFetch: AlbumFetcherHandler?
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      let nativeChannel = FlutterMethodChannel(name: "com.example.winter/native", binaryMessenger: controller.binaryMessenger)
      imagePicker = ImagePicker(controller: controller)
      allPhotos = ImageFetcherHandler(controller: controller)
      albumsFetch = AlbumFetcherHandler(controller: controller)
      
      
      
      nativeChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "ShowToast" {
                self?.albumsFetch?.fetchAllAlbums(result: result)
            } else if call.method == "GetAllAlbums" {
                self?.albumsFetch?.fetchAllAlbums(result: result)
            } else if call.method == "GetImagesFromAlbums" {
                if let args = call.arguments as? [String: Any], let albumName = args["albumName"] as? String {
                    self?.allPhotos?.fetchImagesFromAlbum(albumName: albumName, result: result)
                }
            }
          })
      
      
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }}
