import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount          
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    
    private var totalCorrectAnswers: Int {
        get {
            return storage.integer(forKey: "totalCorrectAnswers")
        }
        set {
            storage.set(newValue, forKey: "totalCorrectAnswers")
        }
    }
    
    private var totalQuestionsAsked: Int {
        get {
            return storage.integer(forKey: "totalQuestionsAsked")
        }
        set {
            storage.set(newValue, forKey: "totalQuestionsAsked")
        }
    }

    var totalAccuracy: Double { guard totalQuestionsAsked > 0 else { return 0}
        return Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100
    }
    
    var gamesCount: Int {
        get {return UserDefaults.standard.integer(forKey: Keys.gamesCount.rawValue)}
        set {storage.set (newValue, forKey: Keys.gamesCount.rawValue)}
    }
    
    var bestGame: GameResult {
        get {
            let correct = UserDefaults.standard.integer(forKey: "bestGameCorrect")
            let total = UserDefaults.standard.integer(forKey: "bestGameTotal")
            let date = UserDefaults.standard.object(forKey: "bestGameDate") as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            UserDefaults.standard.set(newValue.correct, forKey: "bestGameCorrect")
            UserDefaults.standard.set(newValue.total, forKey: "bestGameTotal")
            UserDefaults.standard.set(newValue.date, forKey: "bestGameDate")
        }
    }
    
    func store(correct count: Int, total amount: Int) {
            
            gamesCount += 1
            
            totalCorrectAnswers += count
            
            totalQuestionsAsked += amount
            
            let currentGame = GameResult(correct: count, total: amount, date: Date())
            if currentGame.isBetterThan(bestGame) {
                bestGame = currentGame
            }
        storage.synchronize()
        }
    }

