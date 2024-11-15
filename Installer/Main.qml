import QtQuick
import QtQuick.Layouts // Needed for Column/Row Layout (https://doc.qt.io/qt-6/qtquicklayouts-index.html)
import QtQuick.Dialogs // Needed for FolderDialog (used to select the location of the CD with a dialog)
import QtQuick.Controls as Controls // Needed for various controls (https://doc.qt.io/qt-6/qtquick-controls-qmlmodule.html)
import org.kde.kirigami as Kirigami // Needed for various KDE controls that follow the KDE Human Interface Guidelines (https://develop.kde.org/docs/getting-started/kirigami/)
import Installer // Needed for Process Type from ProcessStarter.cpp to run bash scripts

Kirigami.ApplicationWindow {
    id: installerWindow
    width: Kirigami.Units.gridUnit * 64
    height: Kirigami.Units.gridUnit * 36
    title: qsTr("Demo Installer")
    pageStack.initialPage: welcomePage //Set the initial page stack page to the welcome page

    // A proccess that runs a program that tries to get the location of a mounted CD if there is one
    Process {
        id: getCDMountLocation

        onSuccess: (successOutput) => {
            cdMountLocation.text = successOutput
        }
    }

    // A process that runs a program that sets up Wine
    Process {
        id: wineSetup

        onStart: busyIndicator.running = true
        onSuccess: (successOutput) => {
            installOutput.text = successOutput
        }
        onError: (errorOutput) => {
            installOutput.text = errorOutput
        }

        onFinish: {
            busyIndicator.running = false
            installOutput.visible = true
            installer.run("Install", [cdMountLocation.text])
        }
    }

    // A process that runs a program that installs a Windows CD into the Wine prefix
    Process {
        id: installer

        onStart: busyIndicator.running = true
        onSuccess: (successOutput) => {
            installOutput.text = installOutput.text + successOutput
        }
        onError: (errorOutput) => {
            installOutput.text = installOutput.text + errorOutput
        }
        onFinish: {
            busyIndicator.running = false
            pageStack.push(installCompletePage)
        }
    }

    Kirigami.ScrollablePage {
        id: welcomePage
        Layout.fillWidth: true
        title: qsTr("Welcome!")

        actions: [
            Kirigami.Action {
                text:"Next"
                icon.name: "go-next"
                onTriggered: {
                    getCDMountLocation.run("GetCDMountLocation", [])
                    pageStack.push(cdLocationPage)
                }
            }
        ]

        ColumnLayout {
            id: header
            spacing: Kirigami.Units.smallSpacing
            anchors.top: parent.top

            Kirigami.Heading {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Welcome to the Demo installer!"
                level: 1
            }

            Controls.Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "This application will help you install and play your Windows Demo CD based game on Linux. Once installed from CD, whenever you launch this application it will take you directly into your game, no CD needed! Press the Next button above to proceed."
            }
        }

        ColumnLayout {
            id: footer
            spacing: Kirigami.Units.smallSpacing
            anchors.bottom: parent.bottom

            Controls.Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Check out our other Installers/Launchers HERE."
            }

            Controls.Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Get support and report issues HERE and HERE respectfully."
            }

            Controls.Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Consider supporting us HERE or HERE (includes priority recommendations and support)."
            }
        }
    }

    Kirigami.ScrollablePage {
        id: cdLocationPage
        Layout.fillWidth: true
        title: qsTr("Demo CD Location")

        actions: [
            Kirigami.Action {
                text:"Install"
                icon.name: "install"
                onTriggered: {
                    wineSetup.run("WineSetup", [])
                }
            }
        ]

        ColumnLayout {
            spacing: Kirigami.Units.smallSpacing

            Controls.Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Please ensure your Demo CD is mounted and it's location is selected in the textbox below, then press the Install button above to proceed."
            }

            RowLayout {
                spacing: Kirigami.Units.smallSpacing

                Controls.TextField {
                    id: cdMountLocation
                    Layout.fillWidth: true
                    placeholderText: "Demo CD Location"
                }

                Controls.Button {
                    id: browseButton
                    text: "Browse"
                    icon.name: "find-location"
                    onClicked: folderDialog.open()
                }

                FolderDialog {
                    id: folderDialog
                    currentFolder: "documentsFolder"
                    onAccepted: cdMountLocation.text = decodeURIComponent(folderDialog.selectedFolder.toString().replace(/^(file:\/{2})/,"")); // Set CD location to the selected folder with the QT url prefix file:// and special characters stripped
                }
            }

            Controls.TextArea {
                id: installOutput
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                visible: false
                enabled: false
            }

            Controls.BusyIndicator {
                id: busyIndicator
                Layout.fillWidth: true
                running: false
            }
        }
    }

    Kirigami.ScrollablePage {
        id: installCompletePage
        Layout.fillWidth: true
        title: qsTr("Installation Complete!")

        actions: [
            Kirigami.Action {
                text:"Start"
                icon.name: "media-playback-start"
                onTriggered: {
                    wineSetup.run("Launch", [])
                    onClicked: installerWindow.close();
                }
            }
        ]

        ColumnLayout {
            spacing: Kirigami.Units.smallSpacing
            anchors.top: parent.top

            Controls.Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "The installation is complete! Now whenever you launch this application it will take you directly into your game, no CD needed! You can either close this Window, or press the Start button above to Start Demo now."
            }
        }

        ColumnLayout {
            spacing: Kirigami.Units.smallSpacing
            anchors.bottom: parent.bottom

            Controls.Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Check out our other Installers/Launchers HERE."
            }

            Controls.Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Get support and report issues HERE and HERE respectfully."
            }

            Controls.Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Consider supporting us HERE or HERE (includes priority recommendations and support)."
            }
        }
    }
}
