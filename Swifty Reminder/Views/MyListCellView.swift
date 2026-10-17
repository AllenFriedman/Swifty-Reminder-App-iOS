//
//  MyListCellView.swift
//  RemindersApp
//
//  Created by Mohammad Azam on 1/20/23.
//

import SwiftUI

struct MyListCellView: View {
    let myList: MyList

    var body: some View {
        HStack {
            ListPumpkinIcon(myList: myList)
                .frame(width: 34, height: 34)
            Text(myList.name)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.pumpkin)
                .opacity(0.6)
                .padding([.trailing], 10)
        }
    }
}

struct MyListCellView_Previews: PreviewProvider {
    static var previews: some View {
        MyListCellView(myList: PreviewData.myList)
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}
