class InitData < ActiveRecord::Migration[7.0]
  def up
    Health.create!(path: 'readable')
  end
end
