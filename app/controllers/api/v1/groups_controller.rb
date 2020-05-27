module Api
  module V1
    class GroupsController < V1Controller
      skip_before_action :verify_authenticity_token, :only => [:create, :edit, :upload_photo, :answer_user_request]

      def create
        @group = Group.new(group_params)

        if @group.name.nil? || @group.description.nil? || @token_id.nil?
          wrong_params
        else
          @group.owner_id = @token_id
          if @group.save
            gu = GroupUser.new(:group_id => @group.id, :user_id => @token_id)
            gu.save
            answer(true, @group)
          else
            answer(false, @group.errors)
          end
        end
      end

      def show
        group = Group.find_by_id(params[:id])
        if group
          if params[:users] == "true"
            group.get_users
          end
          if params[:feed] == "true"
            group.get_feed
          end
          answer(true, render_group(group))
        else
          not_found
        end
      end

      def edit
        group = Group.find_by_id(params[:id])
        if group
          if group.owner_id == @token_id
            if group.update(group_params)
              answer(true, group)
            else
              wrong_params
            end
          else
            answer(false, "You not owner")
          end
        else
          not_found
        end
      end

      def upload_photo
        if params[:photo]
          group = Group.find_by_id(params[:id])
          if group
            if group.owner_id == @token_id
              group.update_attributes(photo: params[:photo])
              answer(true, group.photo)
            else
              answer(false, "You not owner")
            end
          else
            not_found
          end
        else
          wrong_params
        end
      end

      def delete_user
        if params[:users_ids]
          begin
            ids = ActiveSupport::JSON.decode params[:users_ids]
            ids.delete(@token_id)
            if ids.count > 0
              GroupUser.where('user_id IN (?) ', ids).delete_all
              GroupUserRequest.where('user_id IN (?)', ids).update(:hide => 1)
            end
            answer(true, "deleted")
          rescue
            wrong_params
          end
        else
          wrong_params
        end
      end

      def delete
        group = Group.find_by_id(params[:id])
        if group
          if group.owner_id == @token_id
            GroupUser.where('group_id = ? ', group.id).delete_all
            group.delete
            answer(true, "deleted")
          else
            answer(false, "You not owner")
          end
        else
          not_found
        end
      end

      def get_inbox_request
        group = Group.find_by_id(params[:id])
        if group
          if group.owner_id == @token_id
            group.get_inbox
            answer(true, group.inbox)
          else
            answer(false, "You not owner")
          end
        else
          not_found
        end
      end

      def get_outbox_request
        group = Group.find_by_id(params[:id])
        if group
          if group.owner_id == @token_id
            group.get_outbox
            answer(true, group.outbox)
          else
            answer(false, "You not owner")
          end
        else
          not_found
        end
      end

      def join
        group = Group.find_by_id(params[:id])
        if group
          gu = GroupUser.where('user_id = ? AND group_id = ?', @token_id, group.id).take
          if gu
            answer(false, "You already in group")
          else
            request = GroupUserRequest.where('user_id = ? AND group_id = ? AND type_request = 1 AND hide = 0', @token_id, group.id).take
            if request
              answer(false, "You already send request")
            else
              gu = GroupUserRequest.new(:user_id => @token_id, :group_id => group.id, :status => 0, :type_request => 1)
              gu.save
              answer(true, "add request")
            end
          end
        else
          not_found
        end
      end

      def answer_request
        group = Group.find_by_id(params[:id])
        if params[:user_id] && params[:status] && (params[:status] == '2' || params[:status] == '3')
          if group.owner_id == @token_id
            request = GroupUserRequest.where('user_id = ? AND group_id = ? AND type_request = 1', params[:user_id], group.id).take
            if request
              if request.status == 0 || request.status == 1
                if params[:status] == '2'
                  gu = GroupUser.new(:group_id => group.id, :user_id => params[:user_id])
                  gu.save
                end
                GroupUserRequest.where('user_id = ? AND group_id = ?', params[:user_id], group.id).update(:status => params[:status])

                answer(true, "saved")
              else
                answer(false, "Already request")
              end
            else
              answer(false, "Not have request")
            end
          else
            answer(false, "You not owner")
          end
        else
          wrong_params
        end
      end

      def answer_user_request
        if params[:group_id] && params[:status] && (params[:status].to_i == 2 || params[:status].to_i == 3)
          group = Group.find_by_id(params[:group_id])
          if group
            gu = GroupUser.where('user_id = ? AND group_id = ?', @token_id, group.id).take
            if gu
              answer(false, "Already in group")
            else
              request = GroupUserRequest.where('user_id = ? AND group_id = ? AND type_request = 0', @token_id, group.id)
              if request
                if params[:status].to_i == 2
                  gu = GroupUser.new(:group_id => group.id, :user_id => @token_id)
                  gu.save
                end
                GroupUserRequest.where('user_id = ? AND group_id = ?', @token_id, group.id).update(:status => params[:status])
                answer(true, "add in group")

              else
                answer(false, "Request not found")
              end
            end
          else
            not_found
          end
        else
          wrong_params
        end
      end

      def invite
        group = Group.find_by_id(params[:id])
        if params[:user_id] && params[:description]
          if group.owner_id == @token_id
            user = User.find_by_id(params[:user_id])
            if user
              if group
                gu = GroupUser.where('user_id = ? AND group_id = ?', params[:user_id], group.id).take
                if gu
                  answer(false, "Already in group")
                else
                  request = GroupUserRequest.where('user_id = ? AND group_id = ? AND type_request = 0  AND hide = 0', params[:user_id], group.id).take
                  if request
                    answer(false, "You already send request")
                  else
                    gu = GroupUserRequest.new(:user_id => params[:user_id], :group_id => group.id, :status => 0, :type_request => 0, :description => params[:description], :owner_id => @token_id)
                    gu.save
                    answer(true, "add request")
                  end
                end
              else
                not_found
              end
            else
              answer(false, "User not found")
            end
          else
            answer(false, "You not owner")
          end
        else
          wrong_params
        end
      end

      def get_group_inbox_request
        requests = GroupUserRequest.where('user_id = ? AND type_request = 0', @token_id)
        inbox = []
        if requests
          requests.each do |row|
            group = Group.find_by_id(row.group_id)
            group.get_users
            inbox.push({'status' => row.status, 'description' => row.description, 'group' => render_group(group)})
          end
          GroupUserRequest.where('user_id = ? AND type_request = 0 AND status = 0', @token_id).update(:status => 1)
        end
        answer(true, inbox)
      end

      def get_group_outbox_request
        requests = GroupUserRequest.where('user_id = ? AND type_request = 1', @token_id)
        inbox = []
        if requests
          requests.each do |row|
            group = Group.find_by_id(row.group_id)
            # group.get_users
            inbox.push({'status' => row.status, 'group' => render_group(group)})
          end
        end
        answer(true, inbox)
      end

      private
      def not_found
        answer(false, "Group not found")
      end
      def group_params
        params.require(:group).permit(:name, :description, :photo)
      end
    end
  end
end
