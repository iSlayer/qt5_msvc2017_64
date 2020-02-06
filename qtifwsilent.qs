function Controller() {
    installer.autoRejectMessageBoxes();
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    })
}

Controller.prototype.WelcomePageCallback = function() {
    // click delay here because the next button is initially disabled for ~1 second
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function()
{
    gui.currentPageWidget().TargetDirectoryLineEdit.setText(installer.environmentVariable("QT_INSTALL_DIR"));
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();

    widget.deselectAll();
    // Note components described in InstallationLog.txt file
    widget.selectComponent("qt.qt5.5123.win64_msvc2017_64");
    widget.selectComponent("qt.qt5.5123.qtcharts");
    widget.selectComponent("qt.qt5.5123.qtdatavis3d");
    widget.selectComponent("qt.qt5.5123.qtpurchasing");
    widget.selectComponent("qt.qt5.5123.qtvirtualkeyboard");
    widget.selectComponent("qt.qt5.5123.qtwebengine");
    widget.selectComponent("qt.qt5.5123.qtnetworkauth");
    widget.selectComponent("qt.qt5.5123.qtwebglplugin");
    widget.selectComponent("qt.qt5.5123.qtscript");
    widget.selectComponent("qt.tools.vcredist_msvc2017_x86");
    widget.selectComponent("qt.tools.vcredist_msvc2017_x64");
    widget.selectComponent("qt.tools.vcredist");
    widget.selectComponent("qt.tools.vcredist_64");

    gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function()
{
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.FinishedPageCallback = function() {
	var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm;
	if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
		checkBoxForm.launchQtCreatorCheckBox.checked = false;
	}
    gui.clickButton(buttons.FinishButton);
}
