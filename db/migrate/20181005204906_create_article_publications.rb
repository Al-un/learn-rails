class CreateArticlePublications < ActiveRecord::Migration[5.2]
  def change
    create_table :article_publications do |t|
      t.references :article, foreign_key: true
      t.references :catalog, foreign_key: true

      t.timestamps
    end
  end
end
