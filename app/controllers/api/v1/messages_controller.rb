module Api
  module V1
    class MessagesController < V1Controller
      def create
        if params[:group] && params[:text] && params[:text] != ''
          group = Group.find_by_id(params[:group])
          if group
            if group.check_user(@token_id)
              message = GroupMessage.new(:group_id => params[:group], :message => params[:text], :owner_id => @token_id)
              if message.save
                answer(true, message)
              else
                answer(false, message.errors)
              end
            else
              answer(false, "You not in group")
            end
          else
            answer(false, "Group not found")
          end
        else
          wrong_params
        end
      end

      def edit
        if params[:id] && params[:text]
          message = GroupMessage.find_by_id(params[:id])
          if message
            group = Group.find_by_id(message.group_id)
            if group
              if group.check_user(@token_id)
                if message.owner_id == @token_id || group.owner_id == @token_id
                  message.message = params[:text]
                  message.save
                  answer(true, "saved")
                else
                  answer(false, "You not owner")
                end
              else
                answer(false, "You not in group")
              end
            else
              answer(false, "Group not found")
            end
          else
            answer(false, "Message not found")
          end
        else
          wrong_params
        end
      end

      def upload_photo
        if params[:photo]
          message = GroupMessage.find_by_id(params[:id])
          if message
            group = Group.find_by_id(message.group_id)
            if group
              if group.check_user(@token_id)
                message.update_attributes(photo: params[:photo])
                answer(true, message.photo)
              else
                answer(false, "You not in group")
              end
            else
              answer(false, "Group not found")
            end
          else
            answer(false, "Message not found")
          end
        else
          wrong_params
        end
      end

      def delete
        message = GroupMessage.find_by_id(params[:id])
        if message
          group = Group.find_by_id(message.group_id)
          if group
            if group.check_user(@token_id)
              if message.owner_id == @token_id || group.owner_id == @token_id
                message.delete
                answer(true, "deleted")
              else
                answer(false, "You not owner")
              end
            else
              answer(false, "You not in group")
            end
          else
            answer(false, "Group not found")
          end
        else
          answer(false, "Message not found")
        end
      end
    end
  end
end
