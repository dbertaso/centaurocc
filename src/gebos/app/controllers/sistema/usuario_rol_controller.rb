# encoding: utf-8
class Sistema::UsuarioRolController < FormAjaxTabsController
  
  skip_before_filter :set_charset, :only=>[:tabs ]

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
    @usuario = Usuario.find(params[:usuario_id])
    @rol = Rol.new
    fill_rol
		form_new @rol
  end
  
  def save_new
    @usuario = Usuario.find(params[:usuario_id])
    @rol = Rol.find(params[:rol][:id])
    form_save_new @rol, :value=>@usuario.add_rol(@rol)
  end
  
  def cancel_new
		form_cancel_new
  end
  
  def delete
    @usuario = Usuario.find(params[:usuario_id])
    @rol = Rol.find(params[:id])
    form_delete @rol, @usuario.roles.delete(@rol)
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.UsuarioRol.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.UsuarioRol.FormTitles.form_title_record') 
    @form_title_records = I18n.t('Sistema.Body.Controladores.UsuarioRol.FormTitles.form_title_records')
    @form_entity = 'rol'
    @form_identity_field = 'nombre'
  end

  private  
  def fill
    @departamento_list = Departamento.find(:all, :order=>'nombre')
  end

  def fill_oficina
    @estado_select = Estado.find(:all, :order=>'nombre')
    if @oficina.ciudad
      estado_id = @oficina.ciudad.estado_id
    else
      estado_id = @estado_select.first.id
    end
    ciudad_fill(estado_id)
  end
  

  def ciudad_fill(estado_id)
    @ciudad_select = Ciudad.find_all_by_estado_id(estado_id, :order=>'nombre')
    if ciudad = @ciudad_select.first
      oficina_fill(ciudad.id)
    end
  end
  def oficina_fill(ciudad_id)
    @oficina_select = Oficina.find_all_by_ciudad_id(ciudad_id, :order=>'nombre')
  end
  
  def fill_rol
    @rol_select = Rol.find(:all, :order=>'nombre')
  end

  def _list
    @usuario = Usuario.find(params[:usuario_id])
    conditions = ["usuario_rol.usuario_id = ?", @usuario.id]
    joins = 'INNER JOIN usuario_rol ON usuario_rol.rol_id = rol.id'
    params['sort'] = "rol.nombre" unless params['sort']
    
    @list = Rol.search_usuario(conditions, params[:page], params[:sort], joins)
    @total=@list.count
  end
end

