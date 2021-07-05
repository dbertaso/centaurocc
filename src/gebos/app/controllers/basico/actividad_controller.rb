# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::ActividadController
# descripción: Migración a Rails 3
#
class Basico::ActividadController < FormTabTabsController

  def index
    @sub_rubro = SubRubro.find(params[:sub_rubro_id])
    @rubro = @sub_rubro.rubro
    @sub_sector = @sub_rubro.rubro.sub_sector
    @sector = @sub_rubro.rubro.sector
    fill()
    list()
  end

  def list
    params['sort'] = "actividad.nombre" unless params['sort']
    @condition = "sub_rubro_id = #{params[:sub_rubro_id]}"
    
    @list = Actividad.search(@condition, params[:page], params[:sort])
    @total=@list.count

    form_list
  end

  def new
    @sub_rubro = SubRubro.find(params[:sub_rubro_id])
    @rubro = @sub_rubro.rubro
    @sub_sector = @sub_rubro.rubro.sub_sector
    @sector = @sub_rubro.rubro.sector
    fill()
    @codigo_actual = Actividad.find(:first, :order=>"codigo DESC")
    @actividad = Actividad.new
    @actividad.paquetizado = true
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    nombre = eliminar_acentos(params[:actividad][:nombre])
    params[:actividad][:nombre] = nombre.upcase
    @actividad = Actividad.new(params[:actividad])
    @sub_rubro = SubRubro.find(params[:sub_rubro_id])
    @actividad.sub_rubro_id = params[:sub_rubro_id]
    form_save_new @actividad
  end

  def delete
    @actividad = Actividad.find(params[:id])
    result = @actividad.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @actividad, 'actividad'
      end
    end
    #    result = @rubro.destroy
    #    # logger.debug "variable result " + result.class.name
    #    if result == false
    #      render :update do |page|
    #        page.alert "No se puede eliminar"
    #      end
    #      return
    #    else
    #      render :update do |page|
    #        page.form_delete @rubro, 'rubro'
    #      end
    #    end
    #form_delete @rubro
  end

  def edit
    fill()
    @actividad = Actividad.find(params[:id])
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @sub_rubro.rubro.sub_sector
    @sector = @sub_rubro.rubro.sector
    #@sector = @sub_sector.sector
  end

  def save_edit
    nombre = eliminar_acentos(params[:actividad][:nombre])
    params[:actividad][:nombre] = nombre.upcase
    @actividad = Actividad.find(params[:id])
    form_save_edit @actividad
  end

  def cancel_edit
    @actividad = Actividad.find(params[:id])
    form_cancel_edit @actividad
  end

  protected
  def fill
    @ciclo_productivo_select = CicloProductivo.find(:all, :order=>"nombre")
    if @ciclo_productivo_select.length == 0
      @ciclo_productivo_select = []
    end

  end

  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Actividad.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Actividad.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Actividad.FormTitles.form_title_record')
    @form_entity = 'actividad'
    @form_identity_field = 'nombre'
    @width_layout = '850'
  end

end
