module Fae
  class BaseController < ApplicationController

    before_action :set_class_variables
    before_action :set_item, only: [:edit, :update, :destroy]

    helper FormHelper
    helper ViewHelper

    def index
      @items = @klass.for_admin_index
    end

    def new
      @item = @klass.new
      build_images
    end

    def edit
      build_images
    end

    def create
      @item = @klass.new(item_params)

      if @item.save
        redirect_to @index_path, notice: "#{@klass_humanized} was successfully created."
      else
        build_images
        render action: 'new'
      end
    end

    def update
      if @item.update(item_params)
        redirect_to @index_path, notice: "#{@klass_humanized} was successfully updated."
      else
        build_images
        render action: 'edit'
      end
    end

    def destroy
      @item.destroy
      redirect_to @index_path, notice: "#{@klass_humanized} was successfully destroyed."
    end

  private

    def set_class_variables(class_name=nil)
      klass_base = params[:controller].split('/').last
      @klass_name = class_name || klass_base
      @klass = klass_base.classify.constantize
      @klass_singular = @klass_name.singularize
      @klass_humanized = @klass_singular.humanize
      @index_path = '/'+params[:controller]
      @new_path = @index_path+'/new'
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = @klass.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(@klass_singular).permit!
    end

    # if model has images, build them here for nesting
    def build_images
    end

  end
end
