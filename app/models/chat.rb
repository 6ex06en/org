class Chat < ActiveRecord::Base

  before_create :format_chat_name
  after_create :create_relationship_with_user, :invite_addressee
  belongs_to :user

  validates :name, :chat_type, :user_id, presence: true
  validates :chat_type, inclusion: {in: %w(private chat)}

  #TODO:cоздать валидацию на проверку имени при создании чата с типом "чат"
  #имя должно быть числом
  #TODO:создать валидацию на уникальность имени

  private

    def create_relationship_with_user
      UsersChat.create!(user_id: self.user_id, chat_id: self.id)
    end

    def format_chat_name
      case chat_type
        when "chat"
          minmax = [name.to_i, user.id].sort
          self.name = "#{minmax[0]}_#{minmax[1]}"
        when "private"
          self.name = "#{name}_#{user.id}"
      end
    end

    def invite_addressee
      if chat_type == "chat"
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

#TODO:
# Создать через js по клику канал "чат" с именем - id ресипиента и типом чат
# на before_save повесить переименовку канала на имя типа sort(self.id, target.id) - #{id_id}
# либо переименовку канала #{channel_name}_#{current_user.id} if chat_type == private
#
#
#
#
#
#
#
#
#
#
#
