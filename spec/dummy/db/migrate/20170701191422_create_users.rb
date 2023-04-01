if Rails::VERSION::MAJOR >= 5
  version = [Rails::VERSION::MAJOR, Rails::VERSION::MINOR].join('.').to_f
  base = ActiveRecord::Migration[version]
else
  base = ActiveRecord::Migration
end

class CreateUsers < base
  def change
    create_table :users do |t|
      t.string :name
      t.timestamps
    end
  end
end
