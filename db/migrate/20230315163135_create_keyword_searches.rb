class CreateKeywordSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :keyword_searches do |t|
      t.string :keyword
      t.string :total_results
      t.integer :total_links
      t.integer :total_adwords
      t.text :source_code

      t.timestamps
    end
  end
end
