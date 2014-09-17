require 'byebug'
require 'date'
require_relative 'remdataclass'

require 'Qt4'
require_relative 'remaddchange_ui'

class ReminderAddChangeWindow < Qt::Dialog
  
  #
  # Constructors:
  #
  #    window = ReminderAddChange.new(date)  -- adds a Reminder on the specified default date
  #
  #    window = ReminderAddChange.new(reminder) -- changes the given Reminder
  #
  
  FREQSINGLES = ['Day', 'Week', 'Month']
  FREQMULTIPLES = ['Days', 'Weeks', 'Months']
  FREQMAP = {'Days'=>'D', 'Day'=>'D', 'Weeks'=>'W', 'Week'=>'W', 'Months'=>'M', 'Month'=>'M'}
  FREQINDEX  = {'D'=>0, 'W'=>1, 'M'=>2}
  
  slots 'onetime_clicked()', 'get_start_calendar()', 'get_end_calendar()', 'done_maintenance()',
         'save_clicked()', 'repeat_changed(int)', 'noend_clicked()'
  
  def initialize(arg)
    if arg.class == Date
      selected_date = arg
      @changemode = false
    elsif arg.class == Reminder
      @sel_rem = arg
      @changemode = true
    else
      raise "Invalid call with arg = #{arg}"
    end
    super(parent=nil)
    @ui = Ui_MaintDialog.new
    @ui.setupUi(self)
    @ui.errorMsg.setStyleSheet('QLabel {color: red}')
    if @changemode
      preload_for_change
    else
      preload_for_add(selected_date)
    end
  end
  
  def preload_for_add(seldate)
    #
    # defaults for Add Reminder:
    #
    #   start_date = given default date
    #   end_date = given default date
    #   noenddate = false (default form load)
    #   freq_amount = 1 (default form load)
    #   freq_type = D (default form load)
    #   onetimeonly = false (default form load)
    #   short_text = blank (defualt form load)
    #   long_text = blank (default form load)
    #
    @ui.startdateEdit.date = seldate.to_qdate
    @ui.enddateEdit.date = seldate.to_qdate
    @ui.calendarWidget.selectedDate = seldate.to_qdate
    @ui.freqCombo.insertItems(0, FREQSINGLES)
  end
    
  def preload_for_change
    #
    # defaults for Change Reminder:  load from the given Reminder
    #
    @ui.startdateEdit.date = @sel_rem.start_date.to_qdate
    if @sel_rem.end_date
      @ui.enddateEdit.date = @sel_rem.end_date.to_qdate
    else
      @ui.enddateEdit.setHidden(true)
      @ui.endLabel.setHidden(true)
      @ui.noendBox.setCheckState(Qt::Checked)
    end
    @ui.calendarWidget.selectedDate = @sel_rem.start_date.to_qdate
    if @sel_rem.freq_type == 'O'
      @ui.repeatSpin.setHidden(true)
      @ui.freqCombo.setHidden(true)
      @ui.repeatLabel.setHidden(true)
      @ui.onetimeBox.setCheckState(Qt::Checked)
    else
      @ui.onetimeBox.setCheckState(Qt::Unchecked)
      @ui.repeatSpin.value = @sel_rem.freq_amount
      if @sel_rem.freq_amount > 1
        @ui.freqCombo.insertItems(0, FREQMULTIPLES)
      else
        @ui.freqCombo.insertItems(0, FREQSINGLES)
      end
      @ui.freqCombo.setCurrentIndex(FREQINDEX[@sel_rem.freq_type])
    end
    @ui.shortEdit.text = @sel_rem.short_text
    @ui.longEdit.setPlainText(@sel_rem.long_text)
  end
  
  def onetime_clicked()
    @ui.repeatSpin.setHidden(@ui.onetimeBox.isChecked)
    @ui.freqCombo.setHidden(@ui.onetimeBox.isChecked)
    @ui.repeatLabel.setHidden(@ui.onetimeBox.isChecked)
    unless @ui.onetimeBox.isChecked
      @ui.freqCombo.clear
      @ui.freqCombo.insertItems(0, FREQSINGLES)
      @ui.repeatSpin.value = 1
    end
  end
  
  def noend_clicked()
    @ui.enddateEdit.setHidden(@ui.noendBox.isChecked)
    @ui.endLabel.setHidden(@ui.noendBox.isChecked)
    unless @ui.noendBox.isChecked
      @ui.enddateEdit.date = @ui.startdateEdit.date
    end
  end
  
  def get_start_calendar()
    @ui.startdateEdit.date = @ui.calendarWidget.selectedDate
  end
  
  def get_end_calendar()
    @ui.enddateEdit.date = @ui.calendarWidget.selectedDate
  end
  
  def repeat_changed(value)
    @ui.freqCombo.clear
    if value == 1
      @ui.freqCombo.insertItems(0, FREQSINGLES)
    else
      @ui.freqCombo.insertItems(0, FREQMULTIPLES)
    end
  end
  
  def save_clicked()
    if not @ui.noendBox.isChecked
      if @ui.startdateEdit.date.to_rubydate > @ui.enddateEdit.date.to_rubydate
        errorline = 'Start Date cannot be after End Date'
      end
    end
    if @ui.shortEdit.text == ''
      if errorline
        errorline += '; Short Description cannot be blank'
      else
        errorline = 'Short Description cannot be blank'
      end
    end
    if errorline
      @ui.errorMsg.setText(errorline)
      return
    end
    
    # no errors so process the add / change
    start_date = @ui.startdateEdit.date.to_rubydate
    if @ui.noendBox.isChecked
      end_date = nil # end_date set to nil if noendBox is checked
    else
      end_date = @ui.enddateEdit.date.to_rubydate
    end
    if @ui.onetimeBox.isChecked
      freq_type = "O"
      freq_amount = 0
    else
      freq_type = FREQMAP[@ui.freqCombo.currentText]
      freq_amount = @ui.repeatSpin.value
    end
    short_text = @ui.shortEdit.text
    long_text = @ui.longEdit.toPlainText
    long_text = short_text if long_text == ''  # long text defaults to short text if left empty
    r = Reminder.new(start_date, freq_type, freq_amount, end_date, short_text, long_text)
    @rem = ReminderList.new
    if @changemode
      @rem.change_reminder(@sel_rem, r)
    else
      @rem.add_reminder(r)
    end
    @ui.errorMsg.setText('New Reminder saved')
  end
  
  def done_maintenance()
    accept
  end
  
end