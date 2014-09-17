=begin
** Form generated from reading ui file 'remlist.ui'
**
** Created: Wed Sep 10 11:30:56 2014
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_RemlistDialog
    attr_reader :remTable
    attr_reader :shorttextEdit
    attr_reader :longtextEdit
    attr_reader :exitButton
    attr_reader :widget
    attr_reader :verticalLayout
    attr_reader :addButton
    attr_reader :changeButton
    attr_reader :deleteButton

    def setupUi(remlistDialog)
    if remlistDialog.objectName.nil?
        remlistDialog.objectName = "remlistDialog"
    end
    remlistDialog.resize(802, 459)
    @remTable = Qt::TableWidget.new(remlistDialog)
    @remTable.objectName = "remTable"
    @remTable.geometry = Qt::Rect.new(10, 10, 621, 421)
    @shorttextEdit = Qt::LineEdit.new(remlistDialog)
    @shorttextEdit.objectName = "shorttextEdit"
    @shorttextEdit.geometry = Qt::Rect.new(640, 40, 113, 21)
    @longtextEdit = Qt::TextEdit.new(remlistDialog)
    @longtextEdit.objectName = "longtextEdit"
    @longtextEdit.geometry = Qt::Rect.new(640, 90, 104, 79)
    @exitButton = Qt::PushButton.new(remlistDialog)
    @exitButton.objectName = "exitButton"
    @exitButton.geometry = Qt::Rect.new(660, 410, 114, 32)
    @widget = Qt::Widget.new(remlistDialog)
    @widget.objectName = "widget"
    @widget.geometry = Qt::Rect.new(660, 210, 111, 121)
    @verticalLayout = Qt::VBoxLayout.new(@widget)
    @verticalLayout.objectName = "verticalLayout"
    @verticalLayout.setContentsMargins(0, 0, 0, 0)
    @addButton = Qt::PushButton.new(@widget)
    @addButton.objectName = "addButton"

    @verticalLayout.addWidget(@addButton)

    @changeButton = Qt::PushButton.new(@widget)
    @changeButton.objectName = "changeButton"

    @verticalLayout.addWidget(@changeButton)

    @deleteButton = Qt::PushButton.new(@widget)
    @deleteButton.objectName = "deleteButton"

    @verticalLayout.addWidget(@deleteButton)


    retranslateUi(remlistDialog)
    Qt::Object.connect(@addButton, SIGNAL('clicked()'), remlistDialog, SLOT('add_reminder()'))
    Qt::Object.connect(@changeButton, SIGNAL('clicked()'), remlistDialog, SLOT('change_reminder()'))
    Qt::Object.connect(@deleteButton, SIGNAL('clicked()'), remlistDialog, SLOT('delete_reminder()'))
    Qt::Object.connect(@exitButton, SIGNAL('clicked()'), remlistDialog, SLOT('accept()'))

    Qt::MetaObject.connectSlotsByName(remlistDialog)
    end # setupUi

    def setup_ui(remlistDialog)
        setupUi(remlistDialog)
    end

    def retranslateUi(remlistDialog)
    remlistDialog.windowTitle = Qt::Application.translate("remlistDialog", "Dialog", nil, Qt::Application::UnicodeUTF8)
    @exitButton.text = Qt::Application.translate("remlistDialog", "Exit", nil, Qt::Application::UnicodeUTF8)
    @addButton.text = Qt::Application.translate("remlistDialog", "Add", nil, Qt::Application::UnicodeUTF8)
    @changeButton.text = Qt::Application.translate("remlistDialog", "Change", nil, Qt::Application::UnicodeUTF8)
    @deleteButton.text = Qt::Application.translate("remlistDialog", "Delete", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(remlistDialog)
        retranslateUi(remlistDialog)
    end

end

module Ui
    class RemlistDialog < Ui_RemlistDialog
    end
end  # module Ui

