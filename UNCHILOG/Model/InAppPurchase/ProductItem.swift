//
//  ProductItem.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/30.
//

enum ProductItem {
    case removeAds

    var id: String {
        return switch self {
        case .removeAds:
#if DEBUG
            // テスト
            SecretProductIdKey.TEST_REMOVE_ADS
#else
            // 本番
            SecretProductIdKey.REMOVE_ADS
#endif
        }
    }

    static func get(id: String) -> ProductItem? {
        return switch id {
        case ProductItem.removeAds.id:
            .removeAds
        default:
            nil
        }
    }
}
