import sys
import os
import subprocess


def make_new_feature(feature_name, has_demo=False):
    make_dir(f"{feature_name}Feature")
    make_project_file(feature_name, f"{feature_name}Feature", has_demo)
    make_sources(feature_name)
    make_tests(feature_name)
    if has_demo:
        make_demo(feature_name)

def write_code_in_file(file_path, codes):
    if not os.path.isfile(file_path):
        subprocess.run(['touch', file_path])

    master_key_file = open(file_path, 'w')
    master_key_file.write(codes)
    master_key_file.close()

def make_dir(path):
    if not os.path.exists(path):
        os.makedirs(path)

def make_dirs(paths):
    for path in paths:
        make_dir(path)

def make_project_file(feature_name, file_path, has_demo=False, dependencies=[]):
    project_path = file_path + '/Project.swift'
    file_name = file_path.split('/')[-1]
    file_content = f"""
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "{feature_name}Feature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.CommonFeature"""
    file_content += ",\n        ".join(dependencies)
    file_content += "\n    ]" 
    file_content += ",\n    hasDemo: true" if has_demo else ""
    file_content += "\n)"
    write_code_in_file(project_path, file_content)

def make_sources(feature_name):
    make_dir(f'{feature_name}Feature/Sources')
    feature_file_path = f'{feature_name}Feature/Sources/{feature_name}Feature.swift'
    feature_content = '// This is for tuist'
    write_code_in_file(feature_file_path, feature_content)

def make_tests(feature_name):
    make_dir(f'{feature_name}Feature/Tests')
    test_file_path = f'{feature_name}Feature/Tests/TargetTests.swift'
    test_content = '''import XCTest

class TargetTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertEqual("A", "A")
    }

}
'''
    write_code_in_file(test_file_path, test_content)

def make_demo(feature_name):
    make_dir(f'{feature_name}Feature/Demo')
    make_dir(f'{feature_name}Feature/Demo/Sources')
    make_dir(f'{feature_name}Feature/Demo/Resources')
    launch_path = f'{feature_name}Feature/Demo/Resources/LaunchScreen.storyboard'
    launch = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="13122.16" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES" initialViewController="01J-lp-oVM">
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="13104.12"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <scenes>
        <!--View Controller-->
        <scene sceneID="EHf-IW-A2E">
            <objects>
                <viewController id="01J-lp-oVM" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">
                        <rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
                        <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                        <color key="backgroundColor" xcode11CocoaTouchSystemColor="systemBackgroundColor" cocoaTouchSystemColor="whiteColor"/>
                        <viewLayoutGuide key="safeArea" id="6Tk-OE-BBY"/>
                    </view>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="iYj-Kq-Ea1" userLabel="First Responder" sceneMemberID="firstResponder"/>
            </objects>
            <point key="canvasLocation" x="53" y="375"/>
        </scene>
    </scenes>
</document>
'''
    write_code_in_file(launch_path, launch)

    app_delegate_path = f'{feature_name}Feature/Demo/Sources/AppDelegate.swift'
    app_delegate = '''import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .yellow
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
'''
    write_code_in_file(app_delegate_path, app_delegate)




print('Input new feature name ', end=': ', flush=True)
feature_name = sys.stdin.readline().replace("\n", "")

print('Include demo? (Y or N, default = N) ', end=': ', flush=True)
has_demo = sys.stdin.readline().replace("\n", "").upper() == "Y"

print(f'Start to generate the new feature named {feature_name}...')

current_file_path = os.path.dirname(os.path.abspath(__file__))
os.chdir(current_file_path)
os.chdir(os.pardir)
root_path = os.getcwd()
os.chdir(root_path + '/Projects/Features')

make_new_feature(feature_name, has_demo)
