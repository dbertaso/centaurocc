# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::SectorController
# descripción: Migración a Rails 3
#
class Basico::SectorController < FormTabsController

  def index
    list
  end

  def list

    params['sort'] = "sector.nombre" unless params['sort']
    @condition = 'id > 0'

    
    @list = Sector.search(@condition, params[:page], params[:sort])
    @total=@list.count

    logger.info "List ======> #{@list.inspect}"
    form_list

  end


  def new
    @codigo_actual = Sector.find(:first, :order=>"codigo DESC")
    @sector = Sector.new
  end


  def cancel_new
    form_cancel_new
  end

  def save_new
    nombre = eliminar_acentos(params[:sector][:nombre])
    params[:sector][:nombre] = nombre.upcase
    @sector = Sector.new(params[:sector])
    form_save_new @sector
  end

  def delete
    @sector = Sector.find(params[:id])
     result = @sector.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @sector, 'sector'
      end
    end
    #form_delete @sector
  end

  def edit
    @sector = Sector.find(params[:id])
  end
#
#  def view
#    @sector = Sector.find(params[:id])
#  end

  def save_edit
    @sector = Sector.find(params[:id])
    nombre = params[:sector][:nombre].to_s
    nombre = eliminar_acentos(nombre)
    params[:sector][:nombre] = nombre.upcase
    eliminar_acentos(params)
    form_save_edit @sector
  end

  def cancel_edit
    @sector = Sector.find(params[:id])
    form_cancel_edit @sector
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Sector.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Sector.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Sector.FormTitles.form_title_records')
    @form_entity = 'sector'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end


end
