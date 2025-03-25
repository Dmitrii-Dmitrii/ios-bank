struct FeatureModel {
    let type: FeatureType
    let title: String
}

extension FeatureModel {
    enum FeatureType {
        case balance
        case transfer
        case history
    }
}
