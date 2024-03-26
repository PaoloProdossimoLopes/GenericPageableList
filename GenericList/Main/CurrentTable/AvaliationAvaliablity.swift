import Foundation

final class AvaliationAvaliablity: AvaliationAvaliabliting {
    
    private let featureToggle: FeatureToggle
    
    init(featureToggle: FeatureToggle) {
        self.featureToggle = featureToggle
    }
    
    var isAvaliationAvailable: Bool {
        featureToggle.isOn(.isAvaliationEnabled)
    }
}
