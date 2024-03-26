import Foundation

struct CurrentResourceModel: NetworkPageable, Equatable {
    let events: [Event]
    var pagination: NetworkPagination?
    
    struct Event: Decodable, Equatable {
        let eventDate: String
        let shortDescription: String
        let longDescription: String
        let transactionDetail: TransactionDetail?
        let timestamp: String
        let value: Double
        
        enum CodingKeys: String, CodingKey {
            case eventDate = "data_lancamento"
            case shortDescription = "descricao_curta"
            case longDescription = "descricao_longa"
            case transactionDetail = "contraparte_transacao"
            case timestamp = "data_hora_transacão"
            case value = "valor"
        }
    }
    
    struct TransactionDetail: Decodable, Equatable {
        let agency: String
        let account: String
        let dac: String
        
        enum CodingKeys: String, CodingKey {
            case agency = "agencia"
            case account = "conta"
            case dac
        }
    }
}

extension NetworkPagination {
    enum CodingKeys: String, CodingKey {
        case nextPage = "next_page"
        case totalPage = "total_page"
    }
}
