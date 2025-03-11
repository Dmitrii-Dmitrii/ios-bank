struct FeatureModel {
    let type: FeatureType
    let title: String
}

enum FeatureType {
    case balance
    case transfer
    case history
}
