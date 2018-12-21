//
//  HomeViewController.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 04/08/2018.
//  Copyright © 2018 Factory. All rights reserved.
//

import UIKit
import RxSwift
import Starscream


class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        viewModel.getDataFromApi().disposed(by: disposeBag)
        viewModel.getUsersFromAPI().disposed(by: disposeBag)
        viewModel.getUsersFromAPI(searchQuerry: "").disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startDownload()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
