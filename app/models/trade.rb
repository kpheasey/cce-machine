class Trade < ActiveRecord::Base
  belongs_to :market
  belongs_to :exchange

  validates_uniqueness_of :exchange_trade_id, scope: :exchange

  default_scope -> { order('created_at DESC') }

  after_create :notify_trade_create

  def self.on_create
    connection.execute 'LISTEN trades_create'
    loop do
      ActiveRecord::Base.connection.raw_connection.wait_for_notify do |event, pid, trade|
        Rails.logger.info "LISTEN: #{trade}"
        yield trade
      end
    end
  ensure
    ActiveRecord::Base.connection.execute 'UNLISTEN trades_create'
  end

  private

  def notify_trade_create
    ActiveRecord::Base.connection.execute "NOTIFY trades_create, #{ActiveRecord::Base.connection.quote self.to_json}"
  end

end
