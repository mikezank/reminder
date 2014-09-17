require 'byebug'
require 'date'
require 'csv'
require_relative 'remdataclass'
require_relative 'calpopup'
require_relative 'remlist'
require_relative 'remaddchange'

require 'Qt4'
require_relative 'remcalendar_ui'

#-- Add date conversions between QDate and ruby Date
class Date
  def to_qdate
    Qt::Date.new(self.year, self.month, self.day)
  end
end

class Qt::Date
  def to_rubydate
    Date.parse(self.toString)
  end
end
#--

class CalendarWindow < Qt::MainWindow
  
  NUM_ROWS = 5
  NUM_COLS = 7
  
  slots 'cal_forward_shift()', 'cal_backward_shift()'
  
  def initialize(parent=nil)
    super
    @ui = Ui_MainWindow.new
    @ui.setupUi(self)
    @ui.rightButton.setStyleSheet('QPushButton {border-image: url(right_arrow.png)}' +
                                  '  QPushButton:pressed {border-image: url(right_arrow_pressed)}')
    @ui.leftButton.setStyleSheet('QPushButton {border-image: url(left_arrow.png)}' +
                                  '  QPushButton:pressed {border-image: url(left_arrow_pressed)}')
    define_menu_actions
    @cal_start = Date.today - 7 - Date.today.wday
    finish_init
  end
  
  def define_menu_actions
    
    #-- taskmenu appears when the button associated with a task is pressed
    complete_action = Qt::Action.new('Completed', self)
    edit_action = Qt::Action.new('Edit', self)
    @taskmenu = Qt::Menu.new
    @taskmenu.addAction(complete_action)
    @taskmenu.addAction(edit_action)
    
    complete_action.connect(SIGNAL('triggered()')) do # "Complete" action selected
      @selected_task.set_completed
      # move the task to the SavedTaskList
      savedlist = SavedTaskList.new
      savedlist.add_task(@selected_task)
      finish_init
    end
    
    edit_action.connect(SIGNAL('triggered()')) do # "Edit" action selected
      if @selected_task.parent
        changewin = ReminderAddChangeWindow.new(@rem.get_reminder(@selected_task.parent))
        retcode = changewin.exec
        finish_init
      else # this is a SavedTask and cannot be changed
        msgbox = Qt::MessageBox.new
        msgbox.setText('Cannot edit a saved task')
        msgbox.exec
      end
        
    end
    #--
    
    #-- daymenu appears when the calendar date is pressed
    add_action = Qt::Action.new('Add Reminder', self)
    @daymenu = Qt::Menu.new
    @daymenu.addAction(add_action)
    add_action.connect(SIGNAL('triggered()')) do # "Add" action selected
      addwin = ReminderAddChangeWindow.new(@selected_date)
      retcode = addwin.exec
      finish_init
    end
    #--
    
    #-- define the window menuBar actions
    @ui.actionAdd_Reminder.connect(SIGNAL('triggered()')) do # Maintain -> Add Reminder
      addwin = ReminderAddChangeWindow.new(Date.today)
      retcode = addwin.exec
      finish_init
    end
    @ui.actionList_Reminders.connect(SIGNAL('triggered()')) do # Maintain -> List Reminders
      remlistwin = RemlistWindow.new
      retcode = remlistwin.exec
      finish_init
    end
    @ui.actionPick_Date.connect(SIGNAL('triggered()')) do # Go -> Pick Date
      popupwin = CalendarPopup.new
      retcode = popupwin.exec()
      seldate = popupwin.selected_rubydate
      @cal_start = seldate - seldate.wday
      finish_init
    end
    @ui.actionToday.connect(SIGNAL('triggered()')) do # Go -> Today
      @cal_start = Date.today - 7 - Date.today.wday
      finish_init
    end
    @ui.actionImport_Reminders.connect(SIGNAL('triggered()')) do # File -> Import Reminders
      filename = Qt::FileDialog.getOpenFileName(self, 'Import From', '/.', 'CSV file (*.csv)')
      if filename
        @rem.clear_reminders
        CSV.foreach(filename) do |row|
          start_date, end_date, freq_type, freq_amount, short_text, long_text = row[0].split("|")
          r = Reminder.new(Date.parse(start_date), freq_type, freq_amount.to_i, Date.parse(end_date), 
                            short_text, long_text)
          @rem.add_reminder(r)
        end
        finish_init
      end
    end
    @ui.actionExport_Reminders.connect(SIGNAL('triggered()')) do # File -> Export Reminders
      filename = Qt::FileDialog.getSaveFileName(self, 'Export To', '/.', 'CSV file (*.csv)')
      if filename
        CSV.open(filename, "wb", col_sep: "|") do |csv|
          @rem.each_reminder do |r|
            csv << [r.start_date.to_s, r.end_date.to_s, r.freq_type, r.freq_amount.to_s,
              r.short_text, r.long_text]
          end
        end
      end
    end
    @ui.actionQuit.connect(SIGNAL('triggered()')) {close} # File -> Quit
    #--
    
  end
  
  def finish_init
    #progressbar = Qt::ProgressDialog.new('Loading', 'Cannot cancel', 0, 2, self)
    #progressbar.setWindowModality(Qt::WindowModal)
    
    #progressbar.setRange(0,2)
    #progressbar.reset
    #progressbar.setValue(0)
    @cal_end = @cal_start + NUM_ROWS * NUM_COLS - 1
    @rem = ReminderList.new
    @rem.test_load
    @cal = Calendar.new(@rem, @cal_start, @cal_end)
    @button_tasks = {} # hash to associate each Task button with its corresponding Task
    
    @ui.calTable.setRowCount(NUM_ROWS)
    @ui.calTable.setColumnCount(NUM_COLS)
    @ui.calTable.setHorizontalHeaderLabels(%w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday))
    @ui.calTable.horizontalHeader().setResizeMode(Qt::HeaderView.Stretch)
    @ui.calTable.verticalHeader().setResizeMode(Qt::HeaderView.Stretch)
    border_style = 'QTableWidget {border-width: 5px; padding: 3px; border-color: darkblue}'
    @ui.calTable.setStyleSheet(border_style)
    @ui.calTable.setContextMenuPolicy(Qt::CustomContextMenu)
    
    #progressbar.setValue(1)
    
    date = @cal_start
    for row in 0...NUM_ROWS do
      for col in 0...NUM_COLS do
        listitems = []
        if @cal.has_day?(date) then
          @cal.get_day(date).cal_tasks.each {|task| listitems << task}
        end
        widget = make_table_cell(date, listitems)
        @ui.calTable.setCellWidget(row, col, widget)
        date += 1
      end
    end
    
    #progressbar.setValue(2)
  end
  
  def make_table_cell(date, tasks)
    list = Qt::ListWidget.new
    list.connect(SIGNAL('itemClicked(QListWidgetItem*)')) do |widget|
      # when calendar date is clicked save the selected date and popup the daymenu
      @selected_date = Date.parse(widget.text)
      @daymenu.popup(Qt::Cursor.pos)
    end
    listhead = date.strftime('%b %d, %Y')
    head = Qt::ListWidgetItem.new(listhead, list)
    #head.setProperty('calendarDate', date)
    head.setTextAlignment(Qt::AlignCenter)
    if date == Date.today
      head.setBackground(Qt::Brush.new(Qt::blue, Qt::SolidPattern))
      head.setForeground(Qt::Brush.new(Qt::white, Qt::SolidPattern))
    else
      head.setForeground(Qt::Brush.new(Qt::darkCyan, Qt::SolidPattern))
    end
    tasks.each do |task|
      if task.completed
        color = 'green'
      else
        if task.duedate <= Date.today
          color = 'red'
        else
          color = '#A3C1DA'
        end
      end
      button = create_button(task.short_text, color)
      button.setMenu(@taskmenu)
      @button_tasks[button] = task
      litem = Qt::ListWidgetItem.new(list)
      list.setItemWidget(litem, button)
    end
    list.setMinimumWidth(list.sizeHintForColumn(0))
    liststyle = 'QListWidget {border-width: 2px; padding: 3px; margin: 3px}'
    list.setStyleSheet(liststyle)
    list.setResizeMode(Qt::ListView.Adjust)
    list
  end
  
  def create_button(text, color)
    button = Qt::PushButton.new(text)
    button.setStyleSheet("text-align: left; background-color: #{color}")
    # when Task button is clicked lookup and save parent Reminder object associated with that Task
    button.connect(SIGNAL('pressed()')) {@selected_task = @button_tasks[button]}
    button
  end
  
  def cal_forward_shift()
    @cal_start = @cal_end + 1
    finish_init
  end
  
  def cal_backward_shift()
    @cal_start -= NUM_ROWS * NUM_COLS
    finish_init
  end
end

if __FILE__ == $0
  app = Qt::Application.new(ARGV)
  cal_window = CalendarWindow.new
  cal_window.show
  app.exec
end