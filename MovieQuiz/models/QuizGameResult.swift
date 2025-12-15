import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    init(correct: Int = 0, total: Int = 10, date: Date = Date()) {
        self.correct = correct
        self.total = total
        self.date = date
    }
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
} 
