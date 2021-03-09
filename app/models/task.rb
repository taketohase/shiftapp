class Task < ApplicationRecord
  has_many :entries, dependent: :destroy

  validates :owner_id, {presence: true}
  validates :title, {presence: true, length: {maximum: 30}}
  validates :from_date, {presence: true}
  validates :to_date, {presence: true}
  validates :deadline, {presence: true}
  validates :comment, {length: {maximum: 200}}

  # 設定が不適切だと、そのメッセージを配列にして返す
  def task_setting_errors
    error_messages = []
    # タイトル、日付のどれかがnilになっている
    if self.title == nil || self.from_date == nil || self.to_date == nil
      error_messages.push("必須項目が未入力です")
    else
      # to_dateがfrom_fateより前になっている
      if self.to_date < self.from_date
        error_messages.push("対象期間の設定が不整合です")
      end
      # 締め切りが今日より前になっている
      if self.deadline < Date.today
        error_messages.push("締め切りを今日より前の日付に設定することはできません")
      end
    end

    if error_messages.empty?
      return nil
    else
      return error_messages
    end
  end

  # taskには、何日から何日までの希望が欲しいかの情報が含まれる。その期間を配列で渡す。
  def get_days
    # 日数を取得する
    num_of_days = (self.to_date - self.from_date).to_i
    # 日数分、日にちを加算しながら配列に格納する
    days = [self.from_date]
    for i in 1..num_of_days do
      days.push(self.from_date + i)
    end
    return days
  end

  # キーに従業員のid、バリューに日数分のentryの配列を持ったハッシュを取得する
  def get_entries_table
    # taskの管理者を探す
    owner = Owner.find(self.owner_id)
    # 今回のtaskに該当する期間の日付を配列で取得する
    days = self.get_days

    entries_table = {}

    #この管理者の従業員のすべてに対し
    owner.workers.each do |worker|
      # この従業員が持つentryの中から、今回のtaskに関するものを取り出す
      entries = worker.entries.where(task_id: self.id)
      # 存在すれば
      if entries.empty? == false
        # キーが従業員のid、バリューが配列である要素をentries_tableに追加する。
        entries_table[worker.id] = []
        days.each_with_index do |day, i|
          # 該当の日付の物を取得する
          entry = entries.find_by(day: day)
          # インスタンスメソッド"time_to_string"(models\entry.rb)
          # 時間をhh:mm形式の文字列に変換して追加する。
          entries_table[worker.id]
              .push([entry.id.to_s, entry.time_to_string])
        end
      end
    end
    return entries_table
  end
end
