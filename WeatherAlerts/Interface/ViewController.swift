import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let identifier = "alertCell"
    private var alerts = [Alert]()
    private let tableView = UITableView()
    
    // can be injected
    var useCase: AlertsUseCaseProtocol = AlertsUseCase()
    var imageUseCase: AlertImageUseCaseProtocol = AlertImageUseCase()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        tableView.register(AlertCell.self, forCellReuseIdentifier: identifier)
        fetchData()
    }
    
    private func fetchData() {
        useCase.getAlerts { [weak self] result in
            switch result {
            case .failure:
                self?.alerts = []
            case .success(let alerts):
                self?.alerts = alerts
            }
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        alerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AlertCell
        let alert = alerts[indexPath.row]
        let image = imageUseCase.getImage(for: alert.id)
        cell.setUp(with: alert, and: image)
        cell.imageDownloadCallback = { [weak self] data in
            self?.imageUseCase.saveImage(data, for: alert.id)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        95
    }
}

