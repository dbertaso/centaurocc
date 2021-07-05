# encoding: utf-8

#
# autor: Luis Rojas
# clase: Basico::ImputacionesInternacionalController
# descripción: Migración a Rails 3
#
class Basico::ImputacionesInternacionalController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "id" unless params['sort']
    params[:sort] = "id desc"
    @condition = "indicador = 'I'"
    @list = ImputacionesMaquinaria.search(@condition, params[:page], params[:sort])
    @total=@list.count
    form_list
  end
	
  def new
    @imputaciones_maquinaria = ImputacionesMaquinaria.new
        @imputaciones = ImputacionesMaquinaria.find(:first, :order=>"id desc")
    #@imputaciones = ImputacionesMaquinaria.find_by_sql("select * from imputaciones_maquinaria order by id desc limit 1")
    if !@imputaciones.nil?
      @imputaciones_maquinaria = @imputaciones
    end
    @imputaciones_maquinaria.observacion = ''
		form_new @imputaciones_maquinaria
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    imputaciones = ImputacionesMaquinaria.find(:first, :order=>"id desc")
    fecha_r = Time.now.strftime("%Y-%m-%d")
    @imputaciones_maquinaria = ImputacionesMaquinaria.new(params[:imputaciones_maquinaria])
    @imputaciones_maquinaria.fecha_registro = fecha_r
    @imputaciones_maquinaria.indicador = 'I'
    @imputaciones_maquinaria.seguro_nacional = imputaciones.seguro_nacional
    @imputaciones_maquinaria.flete_nacional = imputaciones.flete_nacional
		form_save_new @imputaciones_maquinaria
  end
  
  def view
    @imputaciones_maquinaria = ImputacionesMaquinaria.find(params[:id])
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.ImputacionesMaquinaria.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.ImputacionesMaquinaria.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.ImputacionesMaquinaria.FormTitles.form_title_records')
    @form_entity = 'imputaciones_maquinaria'
    @form_identity_field = 'id'
    @width_layout = '1000'
  end
  
end
