class Task < ActiveRecord::Base
  belongs_to :manager, class_name: "User"
  belongs_to :executor, class_name: "User"
  validates :manager_id, presence: true
  validates :executor_id, presence: true
  validates :name, presence: true, length: {minimum: 2}
  validates :date_exec, presence: true, on: :update

  after_create :set_date_exec, unless: Proc.new {|t| t.date_exec }

  private

   def set_date_exec
   	self.date_exec = self.created_at
   end


  def Task.collect_tasks(date, user, obj={})
    date = date.to_time.beginning_of_day
    c = {}
    if obj[:only_day]
      c[:executor] =Task.where(executor_id: user.id, date_exec: date.beginning_of_day..date.end_of_day).order(:date_exec)
      c[:manager] =Task.where(manager_id: user.id, date_exec: date.beginning_of_day..date.end_of_day).order(:date_exec)
    else
      c[:executor] =Task.select(:date_exec).where(executor_id: user.id, 
        date_exec: date.beginning_of_year - 7.day..date.next_year.end_of_year + 7.day).map{|x| x.date_exec.to_time}
      c[:manager] =Task.select(:date_exec).where(manager_id: user.id, 
        date_exec: date.beginning_of_year - 7.day..date.next_year.end_of_year + 7.day).map{|x| x.date_exec.to_time}
    end
    c
  end

end
