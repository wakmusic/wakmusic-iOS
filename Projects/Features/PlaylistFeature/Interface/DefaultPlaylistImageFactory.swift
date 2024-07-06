import UIKit

public protocol DefaultPlaylistImageDelegate: AnyObject {
    func receive(_ name:String,_ url: String)
}

public protocol DefaultPlaylistImageFactory {
    func makeView(_ delegate: any DefaultPlaylistImageDelegate ) -> UIViewController
}

