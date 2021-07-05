# encoding: utf-8
class Sistema::OpcionAccionAutorizacionController < FormAjaxController

	def index
		list
	end
	
  def list
    params['sort'] = "opcion.nombre" unless params['sort']
    conditions = ["autorizacion = true"]
    joins = ["LEFT OUTER JOIN opcion ON opcion.id = opcion_accion.opcion_id LEFT OUTER JOIN accion ON accion.id = opcion_accion.accion_id"]
    
    @list = OpcionAccion.search(conditions, params[:page], params[:sort], joins)
    @total=@list.count
    form_list
    end
	    
  def edit
    @opcion_accion = OpcionAccion.find(params[:id])
    form_edit @opcion_accion
  end

  def save_edit
    @opcion_accion = OpcionAccion.find(params[:id])
    form_save_edit @opcion_accion
  end

  def cancel_edit
    @opcion_accion = OpcionAccion.find(params[:id])
    form_cancel_edit @opcion_accion
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.OpcionAccionAutorizacion.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.OpcionAccionAutorizacion.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.OpcionAccionAutorizacion.FormTitles.form_title_records')
    @form_entity = 'opcion_accion'
    @form_identity_field = 'autorizacion_nombre'
  end



end
