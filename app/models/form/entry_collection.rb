class Form::EntryCollection < Form::Base
  attr_accessor :entries

  def initialize(attributes, form_count)
    super attributes
    # FORM_COUNTの数だけEntryのインスタンスを作成する。
    self.entries = form_count.times.map { Entry.new() } unless self.entries.present?
  end

  # 上でsuper attributesとしているので必要
  def entries_attributes=(attributes)
    # attributesハッシュ内の値の部分を引数にして、インスタンスを作成する。
    self.entries = attributes.map { |_, value| Entry.new(value) }
  end

  def save(worker_id, task_id, days)
    # トランザクション処理は、すべての処理が正常に行われた場合のみ実行される。
    # すなわち、途中で失敗すると、すべての処理がなかったことになる。
    # モデルへの保存がすべてできた場合のみ実行し、trueを返す。save!は失敗した場合に
    # 例外を投げる。
    Entry.transaction do
      # 例外が発生する可能性のある処理
      self.entries.each_with_index do |entry, i|
        entry.worker_id = worker_id
        entry.task_id = task_id
        entry.day = days[i]
        # インスタンスメソッド"already_entried?"(models\entry.rb)
        # 同じ募集、同じ日付に対するentryが既にある場合trueを返す
        if entry.already_entried?
          # 意図的に例外を投げる
          raise
        else
          entry.save!
        end
      end
    end
      # 例外が発生せず正常に終了した場合の処理
      return true
    rescue => e
      # 例外が発生した場合の処理
      return false
  end
end
