//
//  HelpView.swift
//  Aspetica
//
//  Created by Artem Misesin on 4/23/19.
//  Copyright © 2019 Artem Misesin. All rights reserved.
//

import UIKit
import SnapKit

class HelpView: UIView {

    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Color.mainBackground
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    private let containerView = UIView()

    init() {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        
        let triangle = TriangleView(frame: .zero)

        addSubview(triangle)

        triangle.snp.makeConstraints { make in
            make.width.equalTo(8)
            make.height.equalTo(8 * 0.5)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(snp.bottom)
        }

        textLabel.sizeToFit()

        containerView.layer.cornerRadius = 4
        containerView.backgroundColor = Color.helpColor

        addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(triangle.snp.top)
        }

        containerView.addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }

}
