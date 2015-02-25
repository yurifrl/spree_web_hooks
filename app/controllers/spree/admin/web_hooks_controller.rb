module Spree
  module Admin
    class WebHooksController < Spree::Admin::BaseController
      before_action :load_resource, except: [:show_notification, :retry_notification, :show_log]

      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      def new
        respond_with(@web_hook) do |format|
          format.html { render :layout => !request.xhr? }
          if request.xhr?
            format.js { render :layout => false }
          end
        end
      end

      def edit
        respond_with(@web_hook) do |format|
          format.html { render :layout => !request.xhr? }
          if request.xhr?
            format.js { render :layout => false }
          end
        end
      end

      def update
        if @web_hook.update_attributes(permitted_resource_params)
          flash[:success] = flash_message_for(@web_hook, :successfully_updated)
          respond_with(@web_hook) do |format|
            format.html { redirect_to admin_web_hooks_url }
            format.js { render :layout => false }
          end
        else
          respond_with(@web_hook) do |format|
            format.html do
              flash.now[:error] = @web_hook.errors.full_messages.join(", ")
              render action: 'edit'
            end
            format.js { render layout: false }
          end
        end
      end

      def create
        @web_hook.attributes = permitted_resource_params
        if @web_hook.save
          flash[:success] = flash_message_for(@web_hook, :successfully_created)
          respond_with(@web_hook) do |format|
            format.html { redirect_to admin_web_hooks_url }
            format.js { render :layout => false }
          end
        else
          respond_with(@web_hook) do |format|
            format.html do
              flash.now[:error] = @web_hook.errors.full_messages.join(", ")
              render action: 'new'
            end
            format.js { render layout: false }
          end
        end
      end

      def destroy
        if @web_hook.destroy
          respond_with(@web_hook) do |format|
            format.html { redirect_to admin_web_hooks_url }
            format.js   { render :partial => "spree/admin/shared/destroy" }
          end
        else
          respond_with(@web_hook) do |format|
            format.html { redirect_to admin_web_hooks_url }
          end
        end
      end

      def show_notification
        @notification = Spree::WebHooks::Notification.find(params[:id])
      end

      def show_log
        @web_hook_log = Spree::WebHooks::Log.find(params[:id])
      end

      def retry_notification
        notification = Spree::WebHooks::Notification.find(params[:id])
        notification.update_attributes(attempts: 0)
        notification.notify
        redirect_to notification_admin_web_hooks_path(notification)
      end

      protected
      def collection
        return @collection if @collection.present?
        params[:q] ||= {}
        params[:q][:deleted_at_null] ||= "1"

        params[:q][:s] ||= "name asc"
        @collection = Spree::WebHooks::Hook.accessible_by(current_ability, action)
        if params[:q].delete(:deleted_at_null) == '0'
          @collection = @collection.with_deleted
        end
        # @search needs to be defined as this is passed to search_form_for
        @search = @collection.ransack(params[:q])
        @collection = @search.result.
            page(params[:page]).
            per(params[:per_page] || Spree::Config[:admin_products_per_page])

        @collection
      end

      def load_resource
        @web_hook_notifications ||= Spree::WebHooks::Notification.order(created_at: :desc).first(20)
        @web_hook ||= load_resource_instance
        @collection ||= collection
      end

      def permitted_resource_params
        params.require(:web_hooks_hook).permit!
      end

      def load_resource_instance
        if [:new, :create].include?(action)
          Spree::WebHooks::Hook.new
        elsif params[:id]
          Spree::WebHooks::Hook.find(params[:id])
        end
      end
    end
  end
end
