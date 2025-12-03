import Foundation

//protocol QuestionFactoryDelegate: AnyObject {
//    func didReceiveNextQuestion(question: QuizQuestion?)
//}

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() 
    func didFailToLoadData(with error: Error)
}
