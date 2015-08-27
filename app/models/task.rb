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

  def Task.filter_tasks(user, obj={})
    sql_query = "SELECT 'tasks'.* FROM 'tasks' WHERE"
    if obj["your_status"].present?
      sql_query << " 'tasks'.manager_id = '#{user.id}'" if obj["your_status"] == "Менеджер"
      sql_query << " 'tasks'.executor_id = '#{user.id}'" if obj["your_status"] == "Исполнитель"
    end
    first_ar = last_ar = []
    first_ar = [obj["date_exec_start(1i)"],obj["date_exec_start(2i)"],obj["date_exec_start(3i)"],obj["date_exec_start(4i)"],obj["date_exec_start(5i)"]]
    .select{|v| v.present?}
    last_ar = [obj["date_exec_end(1i)"],obj["date_exec_end(2i)"],obj["date_exec_end(3i)"],obj["date_exec_end(4i)"],obj["date_exec_end(5i)"]]
    .select{|v| v.present?}
    first_date = Time.new(*first_ar)
    last_date = Time.new(*last_ar)
    if obj["date_exec_start(1i)"].present? and obj["date_exec_end(1i)"].present?
      sql_query << " AND ('tasks'.'date_exec' BETWEEN '#{first_date}' AND '#{last_date}')"
    elsif obj["date_exec_start(1i)"].present?
      sql_query << " AND ('tasks'.'date_exec' BETWEEN '#{first_date}' AND '#{Time.now}')"
    elsif obj["date_exec_end(1i)"].present?
      sql_query << " AND ('tasks'.'date_exec' BETWEEN '#{user.created_at}' AND '#{last_date}')"
    end
    sql_query << " AND 'tasks'.name = '#{obj["name"]}'" if obj["name"].present?
    if obj["status"].present?
      sql_query << " AND 'tasks'.status = 'execution'" if obj["status"] == "В работе"
      sql_query << " AND 'tasks'.status = 'pause'" if obj["status"] == "Приостановлен"
      sql_query << " AND 'tasks'.status = 'completed'" if obj["status"] == "Завершен"
      sql_query << " AND 'tasks'.status = 'archived'" if obj["status"] == "Архивный"
    end  
    # puts first_ar.to_s + " -first_ar"
    # puts first_date.to_s
    # puts last_ar.to_s + " -last_ar"
    # puts last_date.to_s
    # puts sql_query
    Task.find_by_sql(sql_query)
  end

end
