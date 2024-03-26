import UIKit

final class RealodButton: UIButton {
    
    private let action: Completion
    
    init(action: @escaping Completion) {
        self.action = action
        super.init(frame: .zero)
        
        setTitle("Try to reload", for: .normal)
        setTitleColor(.blue, for: .normal)
        addTarget(self, action: #selector(reloadButtonActionHandler), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    @objc private func reloadButtonActionHandler() {
        action()
    }
}
