import UIKit

final class LoaderSpinner: UIActivityIndicatorView {
    convenience init() {
        self.init(style: .medium)
        startAnimating()
        hidesWhenStopped = true
    }
}
