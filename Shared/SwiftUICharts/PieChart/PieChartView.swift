//
//  PieChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct PieChartView : View {
    public var data: ChartData
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var formSize:CGSize
    public var dropShadow: Bool
    public var cornerImage: Image?
    public var valueSpecifier:String
    
    @State private var showValue = false
    @State private var currentValue: (categoryId: String, amount: Double) = (categoryId: "", amount: 0) { didSet { } }
    
    public init(data: ChartData, title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOrangeLight, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, cornerImage:Image? = Image(systemName: "chart.pie.fill"), valueSpecifier: String? = "%.1f"){
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.formSize = form!
        if self.formSize == ChartForm.large {
            self.formSize = ChartForm.extraLarge
        }
        self.dropShadow = dropShadow!
        self.cornerImage = cornerImage
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        ZStack{
            Rectangle()
                .fill(self.style.backgroundColor)
                .cornerRadius(20)
                .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 12 : 0)
            VStack(alignment: .leading){
                HStack{
                    if(!showValue){
                        Text(self.title)
                            .font(.headline)
                            .foregroundColor(self.style.textColor)
                    }else{
                        Text("\(self.currentValue.categoryId) - \(self.currentValue.amount, specifier: self.valueSpecifier)")
                            .font(.headline)
                            .foregroundColor(self.style.textColor)
                    }
                    Spacer()
                    self.cornerImage
                        .imageScale(.large)
                        .foregroundColor(self.style.legendTextColor)
                }.padding()
                PieChartRow(data: data, backgroundColor: self.style.backgroundColor, accentColor: self.style.accentColor, showValue: $showValue, currentValue: $currentValue)
                    .foregroundColor(self.style.accentColor).padding(self.legend != nil ? 0 : 12).offset(y:self.legend != nil ? 0 : -10)
                if(self.legend != nil) {
                    Text(self.legend!)
                        .font(.headline)
                        .foregroundColor(self.style.legendTextColor)
                        .padding()
                }
                
            }
        }.frame(width: self.formSize.width, height: self.formSize.height)
    }
}

#if DEBUG
struct PieChartView_Previews : PreviewProvider {
    static var previews: some View {
        PieChartView(data:TestData.values, title: "Title", legend: "Legend")
    }
}
#endif
