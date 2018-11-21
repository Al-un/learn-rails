# frozen_string_literal: true

class UpdateProductsForeignKeys < ActiveRecord::Migration[5.2]
  def change
    # Remote foreign keys to update it
    remove_foreign_key :article_publications, :articles
    remove_foreign_key :article_publications, :catalogs
    # Add deletion cascade
    add_foreign_key :article_publications, :articles, on_delete: :cascade
    add_foreign_key :article_publications, :catalogs, on_delete: :cascade

    # Add missing non-null constraint
    change_column_null :articles, :name, false
    change_column_null :catalogs, :code, false
    change_column_null :catalogs, :name, false
    change_column_null :users, :auth0_id, false
    change_column_null :article_publications, 'article_id', false
    change_column_null :article_publications, 'catalog_id', false
  end
end
