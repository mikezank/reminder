=begin
** Form generated from reading ui file 'remcalendar.ui'
**
** Created: Wed Sep 17 15:58:00 2014
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

require 'Qt4'

class Ui_MainWindow
    attr_reader :actionAdd_Reminder
    attr_reader :actionList_Reminders
    attr_reader :actionPick_Date
    attr_reader :actionToday
    attr_reader :actionQuit
    attr_reader :actionImport_Reminders
    attr_reader :actionExport_Reminders
    attr_reader :centralWidget
    attr_reader :verticalLayoutWidget
    attr_reader :verticalLayout
    attr_reader :pushButton
    attr_reader :calTable
    attr_reader :rightButton
    attr_reader :leftButton
    attr_reader :statusbar
    attr_reader :menuBar
    attr_reader :menuView
    attr_reader :menuMaintain
    attr_reader :menuGo
    attr_reader :menuFile

    def setupUi(mainWindow)
    if mainWindow.objectName.nil?
        mainWindow.objectName = "mainWindow"
    end
    mainWindow.resize(1347, 692)
    @actionAdd_Reminder = Qt::Action.new(mainWindow)
    @actionAdd_Reminder.objectName = "actionAdd_Reminder"
    @actionList_Reminders = Qt::Action.new(mainWindow)
    @actionList_Reminders.objectName = "actionList_Reminders"
    @actionPick_Date = Qt::Action.new(mainWindow)
    @actionPick_Date.objectName = "actionPick_Date"
    @actionToday = Qt::Action.new(mainWindow)
    @actionToday.objectName = "actionToday"
    @actionQuit = Qt::Action.new(mainWindow)
    @actionQuit.objectName = "actionQuit"
    @actionImport_Reminders = Qt::Action.new(mainWindow)
    @actionImport_Reminders.objectName = "actionImport_Reminders"
    @actionExport_Reminders = Qt::Action.new(mainWindow)
    @actionExport_Reminders.objectName = "actionExport_Reminders"
    @centralWidget = Qt::Widget.new(mainWindow)
    @centralWidget.objectName = "centralWidget"
    @verticalLayoutWidget = Qt::Widget.new(@centralWidget)
    @verticalLayoutWidget.objectName = "verticalLayoutWidget"
    @verticalLayoutWidget.geometry = Qt::Rect.new(190, 80, 431, 271)
    @verticalLayout = Qt::VBoxLayout.new(@verticalLayoutWidget)
    @verticalLayout.objectName = "verticalLayout"
    @verticalLayout.setContentsMargins(0, 0, 0, 0)
    @pushButton = Qt::PushButton.new(@centralWidget)
    @pushButton.objectName = "pushButton"
    @pushButton.geometry = Qt::Rect.new(560, 570, 114, 32)
    @calTable = Qt::TableWidget.new(@centralWidget)
    @calTable.objectName = "calTable"
    @calTable.geometry = Qt::Rect.new(70, 20, 1211, 541)
    @rightButton = Qt::PushButton.new(@centralWidget)
    @rightButton.objectName = "rightButton"
    @rightButton.geometry = Qt::Rect.new(1290, 270, 50, 50)
    @rightButton.iconSize = Qt::Size.new(50, 50)
    @leftButton = Qt::PushButton.new(@centralWidget)
    @leftButton.objectName = "leftButton"
    @leftButton.geometry = Qt::Rect.new(10, 270, 50, 50)
    @leftButton.iconSize = Qt::Size.new(50, 50)
    mainWindow.centralWidget = @centralWidget
    @statusbar = Qt::StatusBar.new(mainWindow)
    @statusbar.objectName = "statusbar"
    mainWindow.statusBar = @statusbar
    @menuBar = Qt::MenuBar.new(mainWindow)
    @menuBar.objectName = "menuBar"
    @menuBar.geometry = Qt::Rect.new(0, 0, 1347, 22)
    @menuView = Qt::Menu.new(@menuBar)
    @menuView.objectName = "menuView"
    @menuMaintain = Qt::Menu.new(@menuBar)
    @menuMaintain.objectName = "menuMaintain"
    @menuGo = Qt::Menu.new(@menuBar)
    @menuGo.objectName = "menuGo"
    @menuFile = Qt::Menu.new(@menuBar)
    @menuFile.objectName = "menuFile"
    mainWindow.setMenuBar(@menuBar)

    @menuBar.addAction(@menuFile.menuAction())
    @menuBar.addAction(@menuView.menuAction())
    @menuBar.addAction(@menuMaintain.menuAction())
    @menuBar.addAction(@menuGo.menuAction())
    @menuMaintain.addAction(@actionAdd_Reminder)
    @menuMaintain.addAction(@actionList_Reminders)
    @menuGo.addAction(@actionPick_Date)
    @menuGo.addAction(@actionToday)
    @menuFile.addAction(@actionImport_Reminders)
    @menuFile.addAction(@actionExport_Reminders)
    @menuFile.addAction(@actionQuit)

    retranslateUi(mainWindow)
    Qt::Object.connect(@pushButton, SIGNAL('clicked()'), mainWindow, SLOT('close()'))
    Qt::Object.connect(@rightButton, SIGNAL('clicked()'), mainWindow, SLOT('cal_forward_shift()'))
    Qt::Object.connect(@leftButton, SIGNAL('clicked()'), mainWindow, SLOT('cal_backward_shift()'))

    Qt::MetaObject.connectSlotsByName(mainWindow)
    end # setupUi

    def setup_ui(mainWindow)
        setupUi(mainWindow)
    end

    def retranslateUi(mainWindow)
    mainWindow.windowTitle = Qt::Application.translate("MainWindow", "Reminders Calendar", nil, Qt::Application::UnicodeUTF8)
    @actionAdd_Reminder.text = Qt::Application.translate("MainWindow", "Add Reminder", nil, Qt::Application::UnicodeUTF8)
    @actionList_Reminders.text = Qt::Application.translate("MainWindow", "List Reminders", nil, Qt::Application::UnicodeUTF8)
    @actionPick_Date.text = Qt::Application.translate("MainWindow", "Pick Date", nil, Qt::Application::UnicodeUTF8)
    @actionToday.text = Qt::Application.translate("MainWindow", "Today", nil, Qt::Application::UnicodeUTF8)
    @actionQuit.text = Qt::Application.translate("MainWindow", "Quit", nil, Qt::Application::UnicodeUTF8)
    @actionImport_Reminders.text = Qt::Application.translate("MainWindow", "Import Reminders", nil, Qt::Application::UnicodeUTF8)
    @actionExport_Reminders.text = Qt::Application.translate("MainWindow", "Export Reminders", nil, Qt::Application::UnicodeUTF8)
    @pushButton.text = Qt::Application.translate("MainWindow", "Exit", nil, Qt::Application::UnicodeUTF8)
    @rightButton.text = ''
    @leftButton.text = ''
    @menuView.title = Qt::Application.translate("MainWindow", "View", nil, Qt::Application::UnicodeUTF8)
    @menuMaintain.title = Qt::Application.translate("MainWindow", "Maintain", nil, Qt::Application::UnicodeUTF8)
    @menuGo.title = Qt::Application.translate("MainWindow", "Go", nil, Qt::Application::UnicodeUTF8)
    @menuFile.title = Qt::Application.translate("MainWindow", "File", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(mainWindow)
        retranslateUi(mainWindow)
    end

end

module Ui
    class MainWindow < Ui_MainWindow
    end
end  # module Ui

if $0 == __FILE__
    a = Qt::Application.new(ARGV)
    u = Ui_MainWindow.new
    w = Qt::MainWindow.new
    u.setupUi(w)
    w.show
    a.exec
end
