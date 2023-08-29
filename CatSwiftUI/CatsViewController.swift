//
//  CatsViewController.swift
//  CatSwiftUI
//
//  Created by Joshua Ho on 8/25/23.
//

import Foundation
import SwiftUI

class HostingCell: UITableViewCell { // just to hold hosting controller
    var host: UIHostingController<AnyView>?
}

struct UIList: UIViewRepresentable {

    var viewModel: CatsViewModel
    
    func makeUIView(context: Context) -> UITableView {
        let collectionView = UITableView(frame: .zero, style: .plain)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.register(HostingCell.self, forCellReuseIdentifier: "Cell")
        return collectionView
    }

    func updateUIView(_ uiView: UITableView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {

        var viewModel: CatsViewModel

        init(viewModel: CatsViewModel) {
            self.viewModel = viewModel
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            self.viewModel.cats.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HostingCell

            let view = HStack {
                AsyncImage(url: URL(string: viewModel.cats[indexPath.row].photo)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .frame(maxWidth: 150, maxHeight: 150)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 150, maxHeight: 150)
                }
                VStack(alignment: .leading) {
                    Text(viewModel.cats[indexPath.row].name)
                        .font(.title)
                        .bold()
                    Text(viewModel.cats[indexPath.row].breed)
                        .foregroundColor(.gray)
                    Text(viewModel.cats[indexPath.row].address)
                        .foregroundColor(.accentColor)
                }
                Spacer()
            }.padding()
            
            // create & setup hosting controller only once
            if tableViewCell.host == nil {
                let controller = UIHostingController(rootView: AnyView(view))
                tableViewCell.host = controller
                
                let tableCellViewContent = controller.view!
                tableCellViewContent.translatesAutoresizingMaskIntoConstraints = false
                tableViewCell.contentView.addSubview(tableCellViewContent)
                tableCellViewContent.topAnchor.constraint(equalTo: tableViewCell.contentView.topAnchor).isActive = true
                tableCellViewContent.leftAnchor.constraint(equalTo: tableViewCell.contentView.leftAnchor).isActive = true
                tableCellViewContent.bottomAnchor.constraint(equalTo: tableViewCell.contentView.bottomAnchor).isActive = true
                tableCellViewContent.rightAnchor.constraint(equalTo: tableViewCell.contentView.rightAnchor).isActive = true
            } else {
                // reused cell, so just set other SwiftUI root view
                tableViewCell.host?.rootView = AnyView(view)
            }
            tableViewCell.setNeedsLayout()
            return tableViewCell
        }
    }
}
