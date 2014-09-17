require 'byebug'
require 'date'
require_relative 'remdataclass'
require_relative 'remaddchange'

require 'Qt4'
require_relative 'remlist_ui'

class RemlistWindow < Qt::Dialog
  
  NUM_COLS = 4
  
  slots 'add_reminder()', 'change_reminder()', 'delete_reminder()' # defined from buttons on the form
  
  def initialize(parent=nil)
    super
    @ui = Ui_RemlistDialog.new
    @ui.setupUi(self)
    @ui.remTable.setColumnCount(NUM_COLS)
    @ui.remTable.setHorizontalHeaderLabels(%w(Reminder Start End Frequency))
    #@ui.remTable.horizontalHeader().setResizeMode(Qt::HeaderView.Stretch)
    #@ui.remTable.verticalHeader().setResizeMode(Qt::HeaderView.Stretch)
    border_style = 'QTableWidget {border-width: 5px; padding: 3px; border-color: darkblue}'
    @ui.remTable.setStyleSheet(border_style)
    finish_init
  end
  
  def finish_init
    @remlist = ReminderList.new
    @ui.remTable.setRowCount(@remlist.length)
    row = 0
    @rem_for_row = []
    @remlist.each_reminder do |rem|
      col0 = Qt::TableWidgetItem.new(rem.short_text)
      @ui.remTable.setItem(row, 0, col0)
      col1 = Qt::TableWidgetItem.new(rem.start_date.to_s)
      @ui.remTable.setItem(row, 1, col1)
      col2 = Qt::TableWidgetItem.new(rem.end_date.to_s)
      @ui.remTable.setItem(row, 2, col2)
      col3 = Qt::TableWidgetItem.new(rem.freq_format)
      @ui.remTable.setItem(row, 3, col3)
      row += 1
      @rem_for_row << rem
    end
    @ui.remTable.resizeRowsToContents
    @ui.remTable.resizeColumnsToContents
  end
  
  def add_reminder()
    addwin = ReminderAddChangeWindow.new(Date.today)
    retcode = addwin.exec
    finish_init
  end
  
  def change_reminder()
    selrow = @ui.remTable.currentRow
    changerem = @rem_for_row[selrow]
    changewin = ReminderAddChangeWindow.new(changerem)
    retcode = changewin.exec
    finish_init
  end
  
  def delete_reminder()
    selrow = @ui.remTable.currentRow
    delrem = @rem_for_row[selrow]
    # find prior tasks associated with this Reminder (duedates <= today)
    prior_tasks = delrem.find_prior_tasks
    # remove tasks that have already been completed (already on the SavedTaskList)
    savedtasks = SavedTaskList.new
    prior_tasks.select! { |task| not savedtasks.task_already_saved?(task) }
    if prior_tasks.length > 0
      # give user the option to save the prior uncompleted tasks
      msg = Qt::MessageBox.new
      horizontalSpacer = Qt::SpacerItem.new(400, 0, Qt::SizePolicy.Minimum, Qt::SizePolicy.Expanding)
      layout = msg.layout
      layout.addItem(horizontalSpacer, layout.rowCount(), 0, 1, layout.columnCount())
      msg.setText("There are #{prior_tasks.length} prior uncompleted tasks for this Reminder.\n\n" +
                   "Would you like to save them?")
      msg.setStandardButtons(Qt::MessageBox.Yes | Qt::MessageBox.No)
      msg.setDefaultButton(Qt::MessageBox.Yes)
      retvalue = msg.exec
      if retvalue == Qt::MessageBox.Yes
        prior_tasks.each { |task| savedtasks.add_task(task) }
      end
      @remlist.delete_reminder(delrem)
      finish_init
    else
      msg = Qt::MessageBox.new
      msg.setText("About to delete this reminder: #{delrem.short_text}")
      msg.setInformativeText("Are you sure?")
      msg.setStandardButtons(Qt::MessageBox.Yes | Qt::MessageBox.No)
      msg.setDefaultButton(Qt::MessageBox.No)
      retvalue = msg.exec
      if retvalue == Qt::MessageBox.Yes
        @remlist.delete_reminder(delrem)
        finish_init
      end
    end
  end
  
end