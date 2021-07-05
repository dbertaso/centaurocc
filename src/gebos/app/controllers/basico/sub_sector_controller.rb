# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::SubSectorController
# descripción: Migración a Rails 3

class Basico::SubSectorController < FormTabTabsController

  skip_before_filter :set_charset, :only=>[:list]
  
  def index
    @sector = Sector.find(params[:sector_id])
    list
  end

  def list

    params['sort'] = "sector.nombre, sub_sector.nombre" unless params['sort']
    @condition = "sector.id =#{params[:sector_id]}"

    
    @list = SubSector.search(@condition, params[:page], params[:sort])
    @total=@list.count

   form_list

  end

  def new
    @nemonico_list = Nemonico.find(:all, :order => "nemonico")
    @sector = Sector.find(params[:sector_id])
    @sub_sector = SubSector.new
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    @sub_sector = SubSector.new(params[:sub_sector])
    @sub_sector.sector_id = params[:sector_id]
    form_save_new @sub_sector
  end

  def delete
    @sub_sector = SubSector.find(params[:id])
    form_delete @sub_sector
  end

  def edit
    @nemonico_list = Nemonico.find(:all, :order => "nemonico")
    @sub_sector = SubSector.find(params[:id])
    @sector = @sub_sector.sector
  end

  def view
    @sub_sector = SubSector.find(params[:id])
  end

  def save_edit
    nombre = eliminar_acentos(params[:sub_sector][:nombre])
    params[:sub_sector][:nombre] = nombre.upcase
    @sub_sector = SubSector.find(params[:id])
    form_save_edit @sub_sector
  end

  def cancel_edit
    @sub_sector = SubSector.find(params[:id])
    form_cancel_edit @sub_sector
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.SubSector.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.SubSector.FormTitles.form_title_record')
    @form_title_records =  I18n.t('Sistema.Body.Controladores.SubSector.FormTitles.form_title_records')
    @form_entity = 'sub_sector'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end

end
