class AddSubdomainToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :subdomain, :string
  end
end
