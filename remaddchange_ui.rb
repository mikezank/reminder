=begin
** Form generated from reading ui file 'remaddchange.ui'
**
** Created: Wed Sep 17 08:04:39 2014
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_MaintDialog
    attr_reader :label_4
    attr_reader :onetimeBox
    attr_reader :pushButton
    attr_reader :shortEdit
    attr_reader :label_3
    attr_reader :longEdit
    attr_reader :pushButton_2
    attr_reader :doneButton
    attr_reader :calendarWidget
    attr_reader :errorMsg
    attr_reader :layoutWidget
    attr_reader :horizontalLayout_4
    attr_reader :horizontalLayout_3
    attr_reader :repeatLabel
    attr_reader :repeatSpin
    attr_reader :freqCombo
    attr_reader :noendBox
    attr_reader :widget
    attr_reader :horizontalLayout_5
    attr_reader :horizontalLayout
    attr_reader :label
    attr_reader :startdateEdit
    attr_reader :startCalendar
    attr_reader :widget1
    attr_reader :horizontalLayout_6
    attr_reader :horizontalLayout_2
    attr_reader :endLabel
    attr_reader :enddateEdit
    attr_reader :endCalendar

    def setupUi(maintDialog)
    if maintDialog.objectName.nil?
        maintDialog.objectName = "maintDialog"
    end
    maintDialog.resize(731, 468)
    @label_4 = Qt::Label.new(maintDialog)
    @label_4.objectName = "label_4"
    @label_4.geometry = Qt::Rect.new(32, 310, 108, 16)
    @onetimeBox = Qt::CheckBox.new(maintDialog)
    @onetimeBox.objectName = "onetimeBox"
    @onetimeBox.geometry = Qt::Rect.new(40, 220, 191, 20)
    @pushButton = Qt::PushButton.new(maintDialog)
    @pushButton.objectName = "pushButton"
    @pushButton.geometry = Qt::Rect.new(500, 580, 114, 32)
    @shortEdit = Qt::LineEdit.new(maintDialog)
    @shortEdit.objectName = "shortEdit"
    @shortEdit.geometry = Qt::Rect.new(150, 270, 251, 21)
    @label_3 = Qt::Label.new(maintDialog)
    @label_3.objectName = "label_3"
    @label_3.geometry = Qt::Rect.new(32, 270, 110, 16)
    @longEdit = Qt::TextEdit.new(maintDialog)
    @longEdit.objectName = "longEdit"
    @longEdit.geometry = Qt::Rect.new(148, 310, 256, 91)
    @pushButton_2 = Qt::PushButton.new(maintDialog)
    @pushButton_2.objectName = "pushButton_2"
    @pushButton_2.geometry = Qt::Rect.new(500, 330, 114, 32)
    @doneButton = Qt::PushButton.new(maintDialog)
    @doneButton.objectName = "doneButton"
    @doneButton.geometry = Qt::Rect.new(310, 420, 114, 32)
    @calendarWidget = Qt::CalendarWidget.new(maintDialog)
    @calendarWidget.objectName = "calendarWidget"
    @calendarWidget.geometry = Qt::Rect.new(390, 10, 304, 166)
    @errorMsg = Qt::Label.new(maintDialog)
    @errorMsg.objectName = "errorMsg"
    @errorMsg.geometry = Qt::Rect.new(20, 500, 701, 16)
    @errorMsg.frameShape = Qt::Frame::Panel
    @errorMsg.frameShadow = Qt::Frame::Sunken
    @layoutWidget = Qt::Widget.new(maintDialog)
    @layoutWidget.objectName = "layoutWidget"
    @layoutWidget.geometry = Qt::Rect.new(30, 180, 259, 32)
    @horizontalLayout_4 = Qt::HBoxLayout.new(@layoutWidget)
    @horizontalLayout_4.objectName = "horizontalLayout_4"
    @horizontalLayout_4.setContentsMargins(0, 0, 0, 0)
    @horizontalLayout_3 = Qt::HBoxLayout.new()
    @horizontalLayout_3.objectName = "horizontalLayout_3"
    @repeatLabel = Qt::Label.new(@layoutWidget)
    @repeatLabel.objectName = "repeatLabel"

    @horizontalLayout_3.addWidget(@repeatLabel)

    @repeatSpin = Qt::SpinBox.new(@layoutWidget)
    @repeatSpin.objectName = "repeatSpin"
    @repeatSpin.minimum = 1

    @horizontalLayout_3.addWidget(@repeatSpin)


    @horizontalLayout_4.addLayout(@horizontalLayout_3)

    @freqCombo = Qt::ComboBox.new(@layoutWidget)
    @freqCombo.objectName = "freqCombo"

    @horizontalLayout_4.addWidget(@freqCombo)

    @noendBox = Qt::CheckBox.new(maintDialog)
    @noendBox.objectName = "noendBox"
    @noendBox.geometry = Qt::Rect.new(40, 140, 111, 20)
    @widget = Qt::Widget.new(maintDialog)
    @widget.objectName = "widget"
    @widget.geometry = Qt::Rect.new(30, 30, 330, 38)
    @horizontalLayout_5 = Qt::HBoxLayout.new(@widget)
    @horizontalLayout_5.objectName = "horizontalLayout_5"
    @horizontalLayout_5.setContentsMargins(0, 0, 0, 0)
    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @label = Qt::Label.new(@widget)
    @label.objectName = "label"

    @horizontalLayout.addWidget(@label)

    @startdateEdit = Qt::DateEdit.new(@widget)
    @startdateEdit.objectName = "startdateEdit"

    @horizontalLayout.addWidget(@startdateEdit)


    @horizontalLayout_5.addLayout(@horizontalLayout)

    @startCalendar = Qt::PushButton.new(@widget)
    @startCalendar.objectName = "startCalendar"

    @horizontalLayout_5.addWidget(@startCalendar)

    @widget1 = Qt::Widget.new(maintDialog)
    @widget1.objectName = "widget1"
    @widget1.geometry = Qt::Rect.new(30, 100, 318, 38)
    @horizontalLayout_6 = Qt::HBoxLayout.new(@widget1)
    @horizontalLayout_6.objectName = "horizontalLayout_6"
    @horizontalLayout_6.setContentsMargins(0, 0, 0, 0)
    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.objectName = "horizontalLayout_2"
    @endLabel = Qt::Label.new(@widget1)
    @endLabel.objectName = "endLabel"

    @horizontalLayout_2.addWidget(@endLabel)

    @enddateEdit = Qt::DateEdit.new(@widget1)
    @enddateEdit.objectName = "enddateEdit"

    @horizontalLayout_2.addWidget(@enddateEdit)


    @horizontalLayout_6.addLayout(@horizontalLayout_2)

    @endCalendar = Qt::PushButton.new(@widget1)
    @endCalendar.objectName = "endCalendar"

    @horizontalLayout_6.addWidget(@endCalendar)

    layoutWidget.raise()
    onetimeBox.raise()
    label_4.raise()
    pushButton.raise()
    shortEdit.raise()
    label_3.raise()
    layoutWidget.raise()
    longEdit.raise()
    pushButton_2.raise()
    doneButton.raise()
    startCalendar.raise()
    endCalendar.raise()
    calendarWidget.raise()
    errorMsg.raise()
    noendBox.raise()

    retranslateUi(maintDialog)
    Qt::Object.connect(@onetimeBox, SIGNAL('toggled(bool)'), maintDialog, SLOT('onetime_clicked()'))
    Qt::Object.connect(@pushButton_2, SIGNAL('clicked()'), maintDialog, SLOT('save_clicked()'))
    Qt::Object.connect(@doneButton, SIGNAL('clicked()'), maintDialog, SLOT('accept()'))
    Qt::Object.connect(@startCalendar, SIGNAL('clicked()'), maintDialog, SLOT('get_start_calendar()'))
    Qt::Object.connect(@endCalendar, SIGNAL('clicked()'), maintDialog, SLOT('get_end_calendar()'))
    Qt::Object.connect(@repeatSpin, SIGNAL('valueChanged(int)'), maintDialog, SLOT('repeat_changed(int)'))
    Qt::Object.connect(@noendBox, SIGNAL('clicked()'), maintDialog, SLOT('noend_clicked()'))

    Qt::MetaObject.connectSlotsByName(maintDialog)
    end # setupUi

    def setup_ui(maintDialog)
        setupUi(maintDialog)
    end

    def retranslateUi(maintDialog)
    maintDialog.windowTitle = Qt::Application.translate("maintDialog", "Dialog", nil, Qt::Application::UnicodeUTF8)
    @label_4.text = Qt::Application.translate("maintDialog", "Long Description", nil, Qt::Application::UnicodeUTF8)
    @onetimeBox.text = Qt::Application.translate("maintDialog", "One Time Only", nil, Qt::Application::UnicodeUTF8)
    @pushButton.text = Qt::Application.translate("maintDialog", "Exit", nil, Qt::Application::UnicodeUTF8)
    @label_3.text = Qt::Application.translate("maintDialog", "Short Description", nil, Qt::Application::UnicodeUTF8)
    @pushButton_2.text = Qt::Application.translate("maintDialog", "Save", nil, Qt::Application::UnicodeUTF8)
    @doneButton.text = Qt::Application.translate("maintDialog", "Done", nil, Qt::Application::UnicodeUTF8)
    @errorMsg.text = ''
    @repeatLabel.text = Qt::Application.translate("maintDialog", "Repeat every", nil, Qt::Application::UnicodeUTF8)
    @noendBox.text = Qt::Application.translate("maintDialog", "No End Date", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("maintDialog", "Start Date", nil, Qt::Application::UnicodeUTF8)
    @startCalendar.text = Qt::Application.translate("maintDialog", "<= Set Start Date", nil, Qt::Application::UnicodeUTF8)
    @endLabel.text = Qt::Application.translate("maintDialog", "End Date", nil, Qt::Application::UnicodeUTF8)
    @endCalendar.text = Qt::Application.translate("maintDialog", "<= Set End Date", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(maintDialog)
        retranslateUi(maintDialog)
    end

end

module Ui
    class MaintDialog < Ui_MaintDialog
    end
end  # module Ui

