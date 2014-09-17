=begin
** Form generated from reading ui file 'calpopup.ui'
**
** Created: Wed Sep 10 09:28:45 2014
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_CalpopupDialog
    attr_reader :pushButton
    attr_reader :layoutWidget_2
    attr_reader :horizontalLayout
    attr_reader :label
    attr_reader :dateEdit
    attr_reader :pushButton_2
    attr_reader :calendarWidget

    def setupUi(calpopupDialog)
    if calpopupDialog.objectName.nil?
        calpopupDialog.objectName = "calpopupDialog"
    end
    calpopupDialog.resize(608, 212)
    @pushButton = Qt::PushButton.new(calpopupDialog)
    @pushButton.objectName = "pushButton"
    @pushButton.geometry = Qt::Rect.new(500, 580, 114, 32)
    @layoutWidget_2 = Qt::Widget.new(calpopupDialog)
    @layoutWidget_2.objectName = "layoutWidget_2"
    @layoutWidget_2.geometry = Qt::Rect.new(30, 30, 171, 26)
    @horizontalLayout = Qt::HBoxLayout.new(@layoutWidget_2)
    @horizontalLayout.objectName = "horizontalLayout"
    @horizontalLayout.setContentsMargins(0, 0, 0, 0)
    @label = Qt::Label.new(@layoutWidget_2)
    @label.objectName = "label"

    @horizontalLayout.addWidget(@label)

    @dateEdit = Qt::DateEdit.new(@layoutWidget_2)
    @dateEdit.objectName = "dateEdit"

    @horizontalLayout.addWidget(@dateEdit)

    @pushButton_2 = Qt::PushButton.new(calpopupDialog)
    @pushButton_2.objectName = "pushButton_2"
    @pushButton_2.geometry = Qt::Rect.new(60, 100, 114, 32)
    @calendarWidget = Qt::CalendarWidget.new(calpopupDialog)
    @calendarWidget.objectName = "calendarWidget"
    @calendarWidget.geometry = Qt::Rect.new(250, 20, 304, 166)

    retranslateUi(calpopupDialog)
    Qt::Object.connect(@pushButton_2, SIGNAL('clicked()'), calpopupDialog, SLOT('accept()'))
    Qt::Object.connect(@calendarWidget, SIGNAL('clicked(QDate)'), calpopupDialog, SLOT('caldate_selected()'))
    Qt::Object.connect(@dateEdit, SIGNAL('dateChanged(QDate)'), calpopupDialog, SLOT('date_selected()'))

    Qt::MetaObject.connectSlotsByName(calpopupDialog)
    end # setupUi

    def setup_ui(calpopupDialog)
        setupUi(calpopupDialog)
    end

    def retranslateUi(calpopupDialog)
    calpopupDialog.windowTitle = Qt::Application.translate("calpopupDialog", "Dialog", nil, Qt::Application::UnicodeUTF8)
    @pushButton.text = Qt::Application.translate("calpopupDialog", "Exit", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("calpopupDialog", "Enter Date", nil, Qt::Application::UnicodeUTF8)
    @pushButton_2.text = Qt::Application.translate("calpopupDialog", "Select", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(calpopupDialog)
        retranslateUi(calpopupDialog)
    end

end

module Ui
    class CalpopupDialog < Ui_CalpopupDialog
    end
end  # module Ui

