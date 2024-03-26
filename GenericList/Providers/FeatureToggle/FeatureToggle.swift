import Foundation

protocol FeatureToggle {
    func isOn(_ toggle: Toggle) -> Bool
}
