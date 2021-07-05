# encoding: utf-8

#
# autor: Diego Bertaso
# clase: Basico::EstatusController
# descripción: Build in Rails 3
#
class Basico::EstatusController < FormAjaxController

	def index
		list
	end
	
  def list

    params['sort'] = "nombre" unless params['sort']

    @condition = ' activo = true '
    @form_search_expression = []

    logger.info "Params =========> #{params.inspect}"
    unless params[:nombre].nil? || params[:nombre].to_s.empty? || params[:nombre] == ' '

      unless @condition == ''
        @condition << " and lower(nombre) like '%#{params[:nombre][0].to_s.downcase}%'"
      else
        @condition = "nombre like '%#{params[:nombre].to_s}%'"
      end

      @form_search_expression << " #{I18n.t('Sistema.Body.Controladores.SearchComun.nombre')} #{params[:nombre].to_s}"

    end

    @list = Estatus.search(@condition, 
                          params[:page], 
                          params['sort'])

    if @list.nil? or
       @list.empty?

       render :update do |page|
        page.<< "varEnviado=false "
        page.alert "No hay registros que cumplan los criterios solicitados"
       end
       return

    end

    @total=@list.count    
    form_list

  end
	
  def new
    @causa_renuncia = Estatus.new
		form_new @estatus
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def save_new
    @estatus = Estatus.new(params[:estatus])
		form_save_new @estatus
  end
  
  def delete
    @estatus = Estatus.find(params[:id])
		form_delete @estatus
  end
  
  def edit
    @estatus = Estatus.find(params[:id])
		form_edit @estatus
  end
  def save_edit
    @estatus = Estatus.find(params[:id])
		form_save_edit @estatus
  end
  def cancel_edit
    @estatus = Estatus.find(params[:id])
		form_cancel_edit @estatus
  end
  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Estatus.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Estatus.FormTitles.form_title')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Estatus.FormTitles.form_title_records')
    @form_entity = 'estatus'
    @form_identity_field = 'nombre'
  end
  
end
