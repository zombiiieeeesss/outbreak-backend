require Amnesia
use Amnesia

defdatabase Database do
  deftable Job, [{:id, autoincrement}, :timestamp, :execute_at, :name, :params], index: [:execute_at] do
    @type t :: %Job{id: non_neg_integer, timestamp: non_neg_integer, execute_at: String.t, name: String.t, params: map()}
  end
end
