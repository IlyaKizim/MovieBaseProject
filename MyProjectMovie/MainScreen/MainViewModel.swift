import Foundation
import RxSwift

protocol SetForHeaderDelegate: AnyObject {
    func setUp()
}

protocol MyViewModelDelegate: AnyObject {
    func didAddToInteresting()
    func didRemoveFromInteresting()
    func didDeleteFromInteresting()
    func didDeleteRemoveFromInteresting()
}

final class MainViewModel {
    
    enum Section: Int {
        case PopularMovies = 0
        case TopRateMovie
        case UpComingMovies
        case PlayingNowMoview
        case TVshow
    }
    
    enum MovieData {
        case popular([Title])
        case topRated([Title])
        case upcoming([Title])
        case favorites([Title])
        case watched([Title])
    }
    
    weak var headerDelegate: SetForHeaderDelegate?
    weak var delegate: MyViewModelDelegate?
    private (set) var shouldReloadTableViewPublishSubject = PublishSubject<Void>()
    private var apiclient: Apiclient
    private var apiclientGetMovie: ApiclientGetMovie
    private var isActivated = false
    private var isActivatedTwo = false
    lazy var movieData: [MovieData] = [.popular([]), .topRated([]), .upcoming([]), .favorites([]), .watched([])]
    lazy var integer = 0
    lazy var randomInt = Int.random(in: 0..<integer)
    lazy var radius = 20
    lazy var titleForHeaderSection = [
        "Популярные фильмы",
        "Высокий рейтинг",
        "Скоро в прокате",
        "Смотрят сейчас",
        "TV шоу"
    ]
    
    init(apiclient: Apiclient, apiclientGetMovie: ApiclientGetMovie) {
        self.apiclient = apiclient
        self.apiclientGetMovie = apiclientGetMovie
    }
    
    func addToInteresting() {
        if !isActivated {
            isActivated = true
            delegate?.didAddToInteresting()
        } else {
            isActivated = false
            delegate?.didRemoveFromInteresting()
        }
    }
    
    func deleteFromInteresting() {
        if !isActivatedTwo {
            isActivatedTwo = true
            delegate?.didDeleteFromInteresting()
        } else {
            isActivatedTwo = false
            delegate?.didDeleteRemoveFromInteresting()
        }
    }
    
    func getData() {
       apiclient.getPopularMovies {[weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.movieData[0] = .popular(data)
                    self?.integer = data.count
                    self?.headerDelegate?.setUp()
                    self?.shouldReloadTableViewPublishSubject.onNext(())
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        apiclient.getTopRateMovie {[weak self] (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.movieData[1] = .topRated(data)
                    self?.shouldReloadTableViewPublishSubject.onNext(())
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        apiclient.getUpComingMovies {[weak self] (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.movieData[2] = .upcoming(data)
                    self?.shouldReloadTableViewPublishSubject.onNext(())
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        apiclient.getPlayingNowMoview {[weak self] (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.movieData[3] = .favorites(data)
                    self?.shouldReloadTableViewPublishSubject.onNext(())
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        apiclient.getTVshow {[weak self] (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.movieData[4] = .watched(data)
                    self?.shouldReloadTableViewPublishSubject.onNext(())
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getMovies(indexPath: IndexPath, title: [Title]) {
        apiclientGetMovie.getMovie(with: title[indexPath.row].originalTitle ?? ""  + " trailer") { (results) in
            switch results {
            case .success(let videoElement):
                MovieDetailsViewControllers.getmodalll(string: videoElement.id.videoId)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
