//
//  EventsViewController.swift
//  Bookingdle
//
//  Created by Mai Nguyen on 13/10/2023.
//

import UIKit

class EventsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return DataManager.shared.events.count
    }

    // Set up collection view to show events information
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCell
        
        // Show information on screen
        cell.imageView.image = DataManager.shared.events[indexPath.row].photo
        cell.eventTitle.text = DataManager.shared.events[indexPath.row].title
        cell.eventShortDesc.text = DataManager.shared.events[indexPath.row].shortDescription
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){}

    func configureCollectionView()
    {
       collectionView!.dataSource = self
       collectionView!.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureCollectionView()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let indexPaths = collectionView.indexPathsForSelectedItems! as NSArray
        let indexPath = indexPaths[0] as! IndexPath
        let vc = segue.destination as! EventViewController
        vc.event = indexPath.row
    }
}
