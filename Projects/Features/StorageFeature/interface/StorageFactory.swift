import UIKit

@MainActor
public protocol StorageFactory {
    func makeView() -> UIViewController
}
