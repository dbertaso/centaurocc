# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::RubroController
# descripción: Migración a Rails 3

class Basico::RubroController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[:list]
  
  def index

    @sub_sector = SubSector.find(params[:sub_sector_id])
    @sector = Sector.find(@sub_sector.sector_id)
    list
  end

  def list

    params['sort'] = "rubro.nombre" unless params['sort']

    @condition = "sub_sector_id = #{params[:sub_sector_id]} and sector_id = #{@sector.id}"

    
    @list = Rubro.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list
  end

  def new
    @sub_sector = SubSector.find(params[:sub_sector_id])
    @sector = @sub_sector.sector
    @rubro = Rubro.new
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    nombre = eliminar_acentos(params[:rubro][:nombre])
    params[:rubro][:nombre] = nombre.upcase
    @rubro = Rubro.new(params[:rubro])
    @sub_sector = SubSector.find(params[:sub_sector_id])
    @rubro.sub_sector_id = params[:sub_sector_id]
    @rubro.sector_id = @sub_sector.sector.id
    form_save_new @rubro
  end

  def delete
    @rubro = Rubro.find(params[:id])
    result = @rubro.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @rubro, 'rubro'
      end
    end
  end

  def edit
    @rubro = Rubro.find(params[:id])
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
  end

#  def view
#    @sub_sector = SubSector.find(params[:id])
#  end

  def save_edit
    nombre = eliminar_acentos(params[:rubro][:nombre])
    params[:rubro][:nombre] = nombre.upcase
    @rubro = Rubro.find(params[:id])
    form_save_edit @rubro
  end

  def cancel_edit
    @rubro = Rubro.find(params[:id])
    form_cancel_edit @rubro
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Rubro.FormTitles.form_title_records')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Rubro.FormTitles.form_title_record')
    @form_title_records =  I18n.t('Sistema.Body.Controladores.Rubro.FormTitles.form_title_records')
    @form_entity = 'rubro'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end

end
