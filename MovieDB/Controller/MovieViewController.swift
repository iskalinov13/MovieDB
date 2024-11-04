//
//  ViewController.swift
//  MovieDB
//
//  Created by FIskalinov on 21.10.2024.
//

import UIKit

class MovieViewController: UIViewController {
    private lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "MovieDB"
        layoutUI()
        getMovies()
    }
    
    private func layoutUI() {
        view.addSubview(movieTableView)
        NSLayoutConstraint.activate([
            movieTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    private func getMovies() {
        NetworkingManager.shared.getMovies { movies in
            self.movies = movies
            self.movieTableView.reloadData()
        }
    }
}

extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.title.text = movies[indexPath.row].title
        
        NetworkingManager.shared.loadImage(porterPath: movies[indexPath.row].posterPath) { image in
            cell.movieImage.image = image
        }
        return cell
    }
}

