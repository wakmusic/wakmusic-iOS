public extension DesignSystemAsset {
    @available(*, deprecated, renamed: "BlueGrayColor", message: "'GrayColor' renamed 'BlueGrayColor'")
    typealias GrayColor = BlueGrayColor
}

public extension DesignSystemAsset.BlueGrayColor {
    static var gray100: DesignSystemColors { Self.blueGray100 }
    static var gray200: DesignSystemColors { Self.blueGray200 }
    static var gray25: DesignSystemColors { Self.blueGray25 }
    static var gray300: DesignSystemColors { Self.blueGray300 }
    static var gray400: DesignSystemColors { Self.blueGray400 }
    static var gray50: DesignSystemColors { Self.blueGray50 }
    static var gray500: DesignSystemColors { Self.blueGray500 }
    static var gray600: DesignSystemColors { Self.blueGray600 }
    static var gray700: DesignSystemColors { Self.blueGray700 }
    static var gray800: DesignSystemColors { Self.blueGray800 }
    static var gray900: DesignSystemColors { Self.blueGray900 }
}
