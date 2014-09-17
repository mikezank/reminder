require 'byebug'
require 'date'

require 'Qt4'
require_relative 'calpopup_ui'

class CalendarPopup < Qt::Dialog
  
  attr_reader :selected_rubydate
  
  slots 'date_selected()', 'caldate_selected()'

  def initialize(parent=nil)
    super
    @ui = Ui_CalpopupDialog.new
    @ui.setupUi(self)
    @ui.dateEdit.date = Qt::Date.currentDate
    @ui.calendarWidget.setSelectedDate(Qt::Date.currentDate)
  end
  
  def date_selected()
    @selected_qdate = @ui.dateEdit.date
    @selected_rubydate = @selected_qdate.to_rubydate
    @ui.calendarWidget.setSelectedDate(@selected_qdate)
  end
  
  def caldate_selected()
    @selected_qdate = @ui.calendarWidget.selectedDate
    @selected_rubydate = @selected_qdate.to_rubydate
    @ui.dateEdit.date = @selected_qdate
  end
  
end