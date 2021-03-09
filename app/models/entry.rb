class Entry < ApplicationRecord
  belongs_to :task

  validates :worker_id, {presence: true}
  validates :task_id, {presence: true}
  validates :day, {presence: true}
  validates :from_time_h, {presence: true}
  validates :from_time_m, {presence: true}
  validates :to_time_h, {presence: true}
  validates :to_time_m, {presence: true}

  # 同じ募集、同じ日付に対するentryが既にある場合trueを返す。
  def already_entried?
    if Entry.find_by(worker_id: self.worker_id,
                       task_id: self.task_id,
                       day: self.day)
      return true
    else
      return false
    end
  end

  # @taskと同時に曜日を表示したい場面が多いためここに定義。
  def self.get_days_of_week(wday)
    days = ["日","月","火","水","木","金","土"]
    return days[wday]
  end

  # mm/dd(曜日)形式の文字列に変換する。
  def self.date_to_string(day)
    return "#{day.mon}/#{day.mday}(#{get_days_of_week(day.wday)})"
  end

  # yyyy/mm/dd(曜日)形式の文字列に変換する。
  def self.date_y_to_string(day)
    return "#{day.year}/#{day.mon}/#{day.mday}(#{get_days_of_week(day.wday)})"
  end

  # hh:mm形式の文字列に変換する。
  def time_to_string
    # attendanceがtrueならその時間を、falseなら✕マークを追加する。
    if self.attendance
      # 0:0～0:0なら、「フリー」とする。
      if self.from_time_h == 0 && self.from_time_m == 0 && self.to_time_h == 0 && self.to_time_m == 0
        time = "フリー"
      else
        # 0は00とする（例：17:0は17:00に直したい）
        time =  "#{(self.from_time_h == 0)? "00" : self.from_time_h}:#{(self.from_time_m == 0)? "00" : self.from_time_m}-#{(self.to_time_h == 0)? "00" : self.to_time_h}:#{(self.to_time_m == 0)? "00" : self.to_time_m}"
      end
    else
      time = "×"
    end
  end

  # fields_forで使用する「〇〇時」のプルダウンメニューの選択肢をここで生成する。
  def self.values_h
    values_h = []
    (0..23).each do |i|
      values_h.push([i, i])
    end
    return values_h
  end

  # fields_forで使用する「〇〇分」のプルダウンメニューの選択肢をここで生成する。（5分刻み）
  def self.values_m
    values_m = []
    (0..11).each do |i|
      values_m.push([i*5, i*5])
    end
    return values_m
  end
end
