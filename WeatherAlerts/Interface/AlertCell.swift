import UIKit
import Kingfisher

class AlertCell: UITableViewCell {
    private let alertImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalToConstant: 70),
            img.heightAnchor.constraint(equalToConstant: 70)
        ])
        return img
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let startLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let endLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(sourceLabel)
        stack.addArrangedSubview(startLabel)
        stack.addArrangedSubview(endLabel)
        stack.addArrangedSubview(durationLabel)
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.addArrangedSubview(alertImageView)
        stack.addArrangedSubview(textStack)
        return stack
    }()
    
    var imageDownloadCallback: ((_ data: Data) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func setUp(with alert: Alert, and image: AlertImage) {
        nameLabel.text = alert.eventName
        sourceLabel.text = alert.source
        endLabel.text = alert.endDate
        startLabel.text = alert.startDate
        durationLabel.text = alert.duration
        
        switch image {
        case .image(let image):
            alertImageView.image = image
        case .url(let url):
            alertImageView.kf.indicatorType = .activity
            alertImageView.kf.setImage(
                with: url,
                options: [.forceRefresh])
            { [weak self] result in
                switch result {
                case .success(let value):
                    if let data = value.data() {
                        self?.imageDownloadCallback?(data)
                    }
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
