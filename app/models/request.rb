class Request < ApplicationRecord
  belongs_to :owner
  belongs_to :worker

  # 同じ内容のリクエストが既にある場合trueを返す。
  def already_requested?
    if Request.find_by(owner_id: self.owner_id, worker_id: self.worker_id)
      return true
    else
      return false
    end
  end
end
