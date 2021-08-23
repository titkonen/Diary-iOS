import UIKit
import CoreLocation
import MapKit
import CoreData

class NewTrackingViewController: UIViewController {

    var seconds = 1
    var timer: Timer?
    var trails = [Trails]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Coredata Context Layer
    
    private let locationManager = LocationManager.shared
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        //locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func startPressed(_ sender: UIButton) {
        startTracking()
        print("start pressed!")
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {
        
        self.stopTracking()
        
//        let alertController = UIAlertController(title: "End tracking?",
//                                                message: "Do you wish to end your tracking?",
//                                                preferredStyle: .actionSheet)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
//
//            self.stopTracking()
            //self.saveTracking()
          //self.performSegue(withIdentifier: .details, sender: nil)
//        })
//        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
//          self.stopTracking()
//          _ = self.navigationController?.popToRootViewController(animated: true)
//        })
//
//        present(alertController, animated: true)
        
        print("stop pressed!")
        
    }
    
    @IBAction func saveTextPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New text", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newTrails = Trails(context: self.context)
            newTrails.title = textField.text!
            self.trails.append(newTrails)
            self.saveTrails()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new text"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func saveTimePressed(_ sender: UIButton) {
        
        let newTrails = Trails(context: self.context)
       // newRun.distance = distance.value
        newTrails.duration = Int16(seconds)
        newTrails.timestamp = Date()
        newTrails.title = "New track added"
        
        self.trails.append(newTrails)
        
        self.saveTrails()
        
        print("saveTimePressed")
        print(newTrails)
    }
    
    // MARK: - Functions
    func saveTrails() {
         do {
            try context.save()
         } catch {
            print("Error saving context \(error)")
         }
    }
    
    func startTracking() {
        seconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            _ in self.eachSecond()
        }
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateView()
//        stopButton.isHidden = true
        startLocationUpdates()
    }
    
    func stopTracking() {
       
        timer?.invalidate()
        updateView()
        print("Tracking stopped.Invalidate")
        //startButton.isHidden = false
        locationManager.stopUpdatingLocation()
    }
    
    private func tallennus() {
        let newTrails = Trails(context: self.context)
        newTrails.distance = distance.value
        newTrails.duration = Int16(seconds)
        newTrails.timestamp = Date()
        
//        for location in locationList {
//            let locationObject = Location(context: context)
//            locationObject.timestamp = location.timestamp
//            locationObject.latitude = location.coordinate.latitude
//            locationObject.longitude = location.coordinate.longitude
//            newTrails.addToLocations(locationObject)
//          }
      
        self.saveTrails()
      
       // trails = newTrails
    }
    
    func eachSecond() {
        seconds += 1
        updateView()
    }
    
    func eachSecondStop() {
        seconds = 0
        updateView()
    }
    
    func updateView() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time: \(formattedTime)"
        
    }
    
    private func startLocationUpdates() {
      locationManager.delegate = self
      locationManager.activityType = .fitness
      locationManager.distanceFilter = 10
      locationManager.startUpdatingLocation()
    }

}

// MARK: - Location Manager Delegate

extension NewTrackingViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
      
      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
        let coordinates = [lastLocation.coordinate, newLocation.coordinate]
        mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
        let region = MKCoordinateRegion.init(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
      }
      
      locationList.append(newLocation)
    }
  }
}

// MARK: - Map View Delegate

extension NewTrackingViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = .blue
    renderer.lineWidth = 3
    return renderer
  }
}
