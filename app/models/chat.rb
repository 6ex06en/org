class Chat < ActiveRecord::Base

  belongs_to :user
  has_many   :users_relationships, class_name: "UsersChat", foreign_key: "chat_id", dependent: :destroy

  after_create     :create_relationship_with_user, :invite_addressee
  after_validation :format_chat_name

  validates :name, :chat_type, :user_id, presence: true
  validates :name, uniqueness: true
  validates :chat_type, inclusion: {in: %w(private chat)}
  validates :name, numericality: {only_integer: true}, if: ->(c) {c.chat_type == "private"}
  validate  :has_user?, on: :create, if: ->(c) {c.chat_type == "private"}

  private

    def create_relationship_with_user
      UsersChat.create!(user_id: self.user_id, chat_id: self.id)
    end

    def format_chat_name
      case chat_type
      when "private"
          minmax = [name.to_i, user.id].sort
          self.name = "#{minmax[0]}_#{minmax[1]}"
        when "chat"
          self.name = "#{name}_#{user.id}"
      end
    end

    def has_user?
      if chat_type == "private"
        errors.add(:base, "User not found") unless User.find_by(id: self.name)
      end
    end

    def invite_addressee
      if chat_type == "private"
        users_id = name.split("_")
        users_id.each do |id|
          if user_id.to_i == id.to_i
            users_id.delete(id)
            invited_user = User.find_by(id: users_id.first)
            user.invite_to_chat(invited_user, self) if invited_user
          end
        end
      end
    end
end
