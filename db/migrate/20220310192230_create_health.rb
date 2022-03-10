class CreateHealth < ActiveRecord::Migration[7.0]
  def change
    create_table :healths, comment: "データベース死活チェック用テーブル" do |t|
      t.string :path, null: false, comment: '用途別[readable writable toggle]'

      t.timestamps
    end
  end
end
