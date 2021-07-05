# encoding: utf-8
class Sistema::RolOpcionController < FormAjaxTabsController

  skip_before_filter :set_charset, :only=>[:expand, :collapse, :opcion_grupo_change, :opcion_change, :tabs]
  
  def index
    list
  end

  def list
    _list
    form_list
  end	
  
  def view
    list_view
  end
  
  def list_view
    _list
    form_list_view
  end

  def new
    @rol = Rol.find(params[:rol_id])
    @opcion = Opcion.new
    fill_opcion
		form_new @opcion
  end
  
  def save_new
    @rol = Rol.find(params[:rol_id])
    result = @rol.check(params[:opcion][:opcion_grupo_id],params[:opcion][:id])
    if result == false
     render :update do |page|
      page.form_error 'form_new' 
      page.<< "varEnviado = false;"
      end
    else
      @opcion = Opcion.find(params[:opcion][:id])
    
      form_save_new @opcion, :value=>@rol.add_opcion(@opcion, params[:acciones])
      end
    
  end
  
  def save_edit
    @rol = Rol.find(params[:rol_id])
    @opcion = Opcion.find(params[:id])
    form_save_edit @opcion, :value=>@rol.update_opcion(@opcion, params[:acciones])  
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @rol = Rol.find(params[:rol_id])
    @opcion = Opcion.find(params[:id])
    form_delete @opcion, @rol.delete_opcion(@opcion)
  end
  def edit
    @rol = Rol.find(params[:rol_id])
    @opcion = Opcion.find(params[:id])
    @accion_list = OpcionAccion.find_all_by_opcion_id(@opcion.id)
    form_edit @opcion
  end
  
  def cancel_edit
    @rol = Rol.find(params[:rol_id])
    @opcion = Opcion.find(params[:id])
    form_cancel_edit @opcion
  end

  def opcion_grupo_change
    opcion_grupo_id = params[:opcion_grupo_id]
    opcion_fill(opcion_grupo_id)
    render :update do |page|    
      page.replace_html 'opcion-select', :partial => 'opcion_select'
      page.replace_html 'accion-list', :partial => 'accion_list', :locals=>{:edit=>false}
    end
  end
  
  def opcion_change
    opcion_id = params[:opcion_id]
    accion_fill(opcion_id)
    render :update do |page|    
      page.replace_html 'accion-list', :partial => 'sistema/rol_opcion/accion_list', :locals=>{:edit=>false}
    end
  end 
 
  def expand
    @rol = Rol.find(params[:rol_id])
    @opcion = Opcion.find(params[:id])
    form_expand @opcion
  end
  
  def collapse
    @rol = Rol.find(params[:rol_id])
    @opcion = Opcion.find(params[:id])
    form_collapse @opcion
  end
 

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Rol.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Rol.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.RolOpcion.FormTitles.form_title_records')
    @form_entity = 'opcion'
    @form_identity_field = 'nombre'
  end
  
  def protect
    action = super
    return action unless action.nil?
    case action_name
    when 'list'
      nil
    when /^_/
      'edit'
    end
  end

  private
  def fill_estacion
    @oficina_select = Oficina.find(:all, :order=>'nombre')
    if @estacion.oficina_departamento
      oficina_id = @estacion.oficina_departamento.oficina_id
    else
      oficina_id = @oficina_select.first.id
    end
    oficina_departamento_fill(oficina_id)
  end
  

  def oficina_departamento_fill(oficina_id)
    @oficina_departamento_select = OficinaDepartamento.find_all_by_oficina_id(oficina_id)
    if oficina_departamento = @oficina_departamento_select.first
      estacion_fill(oficina_departamento.id)
    end
  end
  def estacion_fill(oficina_departamento_id)
    @estacion_select = Estacion.find_all_by_oficina_departamento_id(oficina_departamento_id, :order=>'nombre')
  end


  def fill_opcion
    @opcion_grupo_select = OpcionGrupo.find(:all, :order=>'nombre')
    if @opcion.opcion_grupo
      opcion_grupo_id = @opcion.opcion_grupo.id
    else
      opcion_grupo_id = @opcion_grupo_select.first.id
    end
    opcion_fill(opcion_grupo_id)
  end
  
  def opcion_fill(opcion_grupo_id)
    @opcion_select = Opcion.find_all_by_opcion_grupo_id(opcion_grupo_id, :order=>'nombre')
    if opcion = @opcion_select.first
      accion_fill(opcion.id)
    end
  end
  
  def accion_fill(opcion_id)
    @accion_list = OpcionAccion.find_all_by_opcion_id(opcion_id)
  end
  
  def _list
    @rol = Rol.find(params[:rol_id])
    conditions = ["rol_opcion.rol_id = ?", @rol.id]
    joins = 'INNER JOIN rol_opcion ON rol_opcion.opcion_id = opcion.id INNER JOIN opcion_grupo ON opcion_grupo.id = opcion.opcion_grupo_id'
    
    params['sort'] = "opcion.nombre" unless params['sort']
    @list = Opcion.search(conditions, params[:page], params[:sort], joins)
    @total=@list.count
  end
  
  
end

