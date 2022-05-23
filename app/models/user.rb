class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :recoverable
  devise :database_authenticatable, :registerable,
         :rememberable

   has_many :user_album_associations
   has_many :albums, through: :user_album_associations

   def is_album_user?
     UserAlbumAssociation.where(user_id: id, album_user: true).any?
   end
end
