import UIKit

final class HeaderUIView: UIView {
    
    private lazy var headerView: UIView = { 
        let headerView = UIView()
        headerView.backgroundColor = .red
        return headerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
