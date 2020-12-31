//
//  MapView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 12/4/20.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let landmarks = LandmarkAnnotation.requestMockData()
    
    func makeUIView(context: Context) -> MKMapView{
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context){
        let coordinate = CLLocationCoordinate2D(
            latitude: 53.304853, longitude: 34.303430)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        view.addAnnotations(landmarks)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static func requestMockData()-> [LandmarkAnnotation]{
        return [
            LandmarkAnnotation(title: "СберТех",
                               subtitle:"СберТех - современная компания, решающая сложнейшие задачи по обеспечению Сбербанка современными IT-решениями",
                               coordinate: .init(latitude: 53.304853, longitude: 34.303430)),
        ]
    }
    
}
