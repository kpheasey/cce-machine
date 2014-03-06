class Trade < ActiveRecord::Base
  belongs_to :market
  belongs_to :exchange

  validates_uniqueness_of :exchange_trade_id, scope: :exchange

  default_scope -> { order('date DESC') }

  def self.on_create
    connection.execute 'LISTEN trades_new'
    loop do
      ActiveRecord::Base.connection.raw_connection.wait_for_notify do |event, pid, trade|
        yield trade
      end
    end
  ensure
    ActiveRecord::Base.connection.execute 'UNLISTEN trades_new'
  end

  def notify_latest
    ActiveRecord::Base.connection.execute "NOTIFY trades_new, #{ActiveRecord::Base.connection.quote self.to_json}"
  end

end
