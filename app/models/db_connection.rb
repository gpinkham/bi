class DbConnection

  def initialize(name, credentials)
    @name = name
    @credentials = credentials
  end

  def connection
    get_klass.connection
  end

  def execute(query, options = {})
    QueryResultPresenter::Presenter.new(connection.execute(query, options))
  end

  private

  def get_klass
    if @klass.nil?
      @klass = Class.new(ActiveRecord::Base) do
        self.abstract_class = true
        def self.name
          'DbConnectionHolder'
        end
      end
      @klass.establish_connection(@credentials)
    end
    @klass
  end
end
