//
//  DetailTableViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/1.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var placeID: String?

    enum DetailSection {

        // swiftlint:disable nesting
        enum InformationRow {

            case phoneNumber, address, businessHours

        }
        // swiftlint:enable nesting

        case informaion(rows: [InformationRow])

        case photo
    }

    let detailSections: [DetailSection] = [

        .photo,
        .informaion(rows: [.phoneNumber, .address, .businessHours])
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        print(placeID)

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon-cross"), for: .normal)
        button.frame = CGRect(x: 11, y: 20, width: 19, height: 19)
        button.tintColor = .black
        button.addTarget(self, action: #selector(self.backToLastView), for: .touchUpInside)

        let leftBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.setRightBarButton(leftBarButton, animated: true)

        tableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")

        tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")

    }

    @objc func backToLastView() {
        print("Ruuuunnn")
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return detailSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let section = detailSections[section]

        switch section {
        case .photo:
            return 1
        case let .informaion(rows): return rows.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = detailSections[indexPath.section]
        switch section {
        case .photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { fatalError() }

            return cell

        case let .informaion(rows):

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? InfoCell else { fatalError() }

            let row = rows[indexPath.row]

            switch row {

            case .phoneNumber:
                cell.iconImageView.image = UIImage(named: "icons8-ringer-volume-100")
                cell.infoLabel.text = "02 22527788"

                return cell

            case .address:
                cell.iconImageView.image = UIImage(named: "icons8-address-100")
                cell.infoLabel.text = "台北市大同區重慶北路四段20號"

                return cell

            case .businessHours:
                cell.iconImageView.image = UIImage(named: "icons8-open-sign-100")
                cell.infoLabel.text = "9:00 ~ 18:00"

                return cell
            }

        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:
            let viewWidth = view.bounds.width
            return viewWidth

        default:
            return 60
        }

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
