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
      c[:executor] =Task.where(executor_id: user.id, date_exec: date.beginning_of_day..date.end_of_day).where("status IS NOT 'archived'").order(:date_exec)
      c[:manager] =Task.where(manager_id: user.id, date_exec: date.beginning_of_day..date.end_of_day).where("status IS NOT 'archived'").order(:date_exec)
    else
      c[:executor] =Task.select(:date_exec).where(executor_id: user.id, 
        date_exec: date.beginning_of_year - 7.day..date.next_year.end_of_year + 7.day).where("status IS NOT 'archived'").map{|x| x.date_exec.to_time}
      c[:manager] =Task.select(:date_exec).where(manager_id: user.id, 
        date_exec: date.beginning_of_year - 7.day..date.next_year.end_of_year + 7.day).where("status IS NOT 'archived'").map{|x| x.date_exec.to_time}
    end
    c
  end

  def Task.filter_tasks(user, obj)
    sql_query = {}
    sql_user = ""
    if obj["your_status"].present?
      sql_user = "manager_id = '#{user.id}'" if obj["your_status"] == "Менеджер"
      sql_user = "executor_id = '#{user.id}'" if obj["your_status"] == "Исполнитель"
    else
      sql_user = "manager_id = '#{user.id}' OR executor_id = '#{user.id}'"
    end
    if obj["date_exec_start"].present? and obj["date_exec_end"].present?
      sql_query[:date_exec] = obj["date_exec_start"].to_time(:utc)..obj["date_exec_end"].to_time(:utc)
    elsif obj["date_exec_start"].present?
      sql_query[:date_exec] = obj["date_exec_start"].to_time(:utc)..(obj["date_exec_start"].to_time(:utc) + 20.year)
    elsif obj["date_exec_end"].present?
      sql_query[:date_exec] = user.created_at..obj["date_exec_end"].to_time(:utc)
    else
      sql_query[:date_exec] = user.created_at..(Time.now + 20.year)
    end
    sql_query[:name] = obj["name"] if obj["name"].present?
    if obj["status"].present?
      sql_query[:status] = 'ready' if obj["status"] == "Не выполняется"
      sql_query[:status] = 'execution' if obj["status"] == "В работе"
      sql_query[:status] = 'pause' if obj["status"] == "Приостановлена"
      sql_query[:status] = 'completed' if obj["status"] == "Выполнена"
      sql_query[:status] = 'finished' if obj["status"] == "Принята"
      sql_query[:status] = 'archived' if obj["status"] == "В архиве"
    end  
    Task.where(sql_query).where(sql_user)
  end

end
