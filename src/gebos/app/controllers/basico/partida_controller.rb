# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::PartidaController
# descripción: Migración a Rails 3
#
class Basico::PartidaController < FormTabTabsController
  def index
    @actividad = Actividad.find(params[:actividad_id])
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
    list
  end

  def list
    params['sort'] = "actividad.nombre, partida.nombre" unless params['sort']
    @condition = "actividad_id = #{params[:actividad_id]}"
    
    @list = Partida.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def new
    @actividad = Actividad.find(params[:actividad_id])
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
    @codigo_actual = Partida.find(:first, :order=>"codigo DESC")
    @partida = Partida.new
  end

  def cancel_new
    form_cancel_new
  end

  def save_new
    nombre = eliminar_acentos(params[:partida][:nombre])
    params[:partida][:nombre] = nombre.upcase
    @partida = Partida.new(params[:partida])
    @actividad = Actividad.find(params[:actividad_id])
    @partida.actividad_id = params[:actividad_id]
    @partida.sub_rubro_id = @actividad.sub_rubro_id
    @partida.rubro_id = @actividad.sub_rubro.rubro_id
    form_save_new @partida
  end

  def delete
    @partida = Partida.find(params[:id])
    result = @partida.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @partida, 'partida'
      end
    end
  end

  def edit
    @partida = Partida.find(params[:id])
    @actividad = @partida.actividad
    @sub_rubro = @actividad.sub_rubro
    @rubro = @sub_rubro.rubro
    @sub_sector = @rubro.sub_sector
    @sector = @sub_sector.sector
  end

  def save_edit
    nombre = eliminar_acentos(params[:partida][:nombre])
    params[:partida][:nombre] = nombre.upcase
    @partida = Partida.find(params[:id])
    form_save_edit @partida
  end

  def cancel_edit
    @partida = Partida.find(params[:id])
    form_cancel_edit @partida
  end

  protected

  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Partida.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Partida.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Partida.FormTitles.form_title_records')
    @form_entity = 'partida'
    @form_identity_field = 'nombre'
    @width_layout = 1100
  end

end
