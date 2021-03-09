class OwnerWorker < ApplicationRecord
  belongs_to :owner
  belongs_to :worker

  # 同じ内容のowner_workerが既にある場合trueを返す。
  def self.already_linked?(link)
    if OwnerWorker.find_by(owner_id: link.owner_id, worker_id: link.worker_id)
      return true
    else
      return false
    end
  end
end
