require Amnesia
use Amnesia

defdatabase Database do
  deftable Job, [{:id, autoincrement}, :timestamp, :execute_at, :name], index: [:execute_at] do
    @type t :: %Job{id: non_neg_integer, timestamp: non_neg_integer, execute_at: String.t, name: String.t}
  end
end
