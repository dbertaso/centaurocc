# encoding: utf-8
class Sistema::UsuarioController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:tabs, :locate_change]

  def index
    fill_oficinas
  end
  
  def list
    if @usuario.admin_empresa == true
      conditions = "usuario.id > 0"
    else
      conditions = "usuario.empresa_sistema_id = #{@usuario.empresa_sistema_id}"
    end
    params['sort'] = "usuario.nombre_usuario" unless params['sort']
    unless params[:nombre_usuario].blank?
      conditions << " AND LOWER(usuario.nombre_usuario) LIKE '%#{params[:nombre_usuario].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.usuario_contenga')} '#{params[:nombre_usuario]}'"
    end
    unless params[:primer_nombre].blank? && params[:primer_apellido].blank?
      params[:primer_nombre] = '' unless params[:primer_nombre]
      params[:primer_apellido] = '' unless params[:primer_apellido]
      conditions << " AND LOWER(usuario.primer_nombre) LIKE '%#{params[:primer_nombre].strip.downcase}%' AND LOWER(usuario.primer_apellido) LIKE '%#{params[:primer_apellido].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.primer_nombre_contenga')} '#{params[:primer_nombre]}'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Vistas.Helpers.Mensajes.primer_apellido_contenga')} '#{params[:primer_apellido]}'"
    end
    
    joins = ["INNER JOIN oficina ON usuario.oficina_id = oficina.id"]
    
    @list = Usuario.search(conditions, params[:page], params[:sort], joins)
    @total=@list.count
    form_list
  end

	def view
    @form_title = 'Usuarios'
    @usuario = Usuario.find(params[:id])
  end

  def new
    if @usuario.admin_empresa == true
      @empresa_sistema_list = EmpresaSistema.find(:all, :conditions => "activo = true", :order => 'nombre')
      @mostrar = 1
    else
      @mostrar = 0
    end
    fill_oficinas
    @form_title = 'Usuarios'
    @usuario = Usuario.new
    fill
  end

  def save_new
    unless @usuario.admin_empresa == true
      empresa_sistema_id = @usuario.empresa_sistema_id
    end
    params[:usuario][:nombre_usuario] = params[:usuario][:nombre_usuario].strip.downcase
    @usuario = Usuario.new(params[:usuario])
    clave = ''
    pass = ParametroGeneral.find(1).nombre_inntitucion
    if pass == ""
      pass = 'Protokol' + Time.today.year.to_s
    end
    clave = Digest::MD5.new.hexdigest(clave)
    @usuario.clave = clave
    @usuario.password = clave
    unless empresa_sistema_id.nil?
      @usuario.empresa_sistema_id = empresa_sistema_id
    end
    form_save_new @usuario
  end

  def delete
    @usuario = Usuario.destroy(params[:id])
    form_delete @usuario
  end

  def edit
    if @usuario.admin_empresa == true
      @empresa_sistema_list = EmpresaSistema.find(:all, :conditions => "activo = true", :order => 'nombre')
      @mostrar = 1
    else
      @mostrar = 0
    end
    fill_oficinas
    @form_title = 'Usuarios'
    @usuario = Usuario.find(params[:id])
    fill
  end

  def save_edit
    unless @usuario.admin_empresa == true
      empresa_sistema_id = @usuario.empresa_sistema_id
    end
    @usuario = Usuario.find(params[:id])
    unless empresa_sistema_id.nil?
      @usuario.empresa_sistema_id = empresa_sistema_id
    end
    logger.debug "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    logger.debug "empresa_sistema_id #{@usuario.empresa_sistema_id}"
    form_save_edit @usuario
  end

  # Clave
  def change_clave
    @form_title = 'Usuarios'
    @usuario = Usuario.find(params[:id])
  end

  def imprimir
    if params[:id].nil?
      @usuarios = Usuario.find(:all, :order=>'primer_nombre, primer_apellido')
    else
      @usuarios = Usuario.find(:all, :conditions=>['id = ?', params[:id]])
    end
  end
  
  def locate_change
    @usuario.lenguaje = params[:lenguaje]
    @usuario.save
    render :update do |page|
      page.<< "recargar();"
    end
    return false
  end

  
  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Usuario.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Usuario.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Usuario.FormTitles.form_title_records')
    @form_entity = 'usuario'
    @form_identity_field = 'nombre_usuario'
    @width_layout = '960'
  end

  private
  
  def fill_oficinas
    unless @usuario.empresa_sistema_id.blank?
      @oficinas_select = Oficina.find(:all, :conditions=>"empresa_sistema_id =  #{@usuario.empresa_sistema_id}", :order=>"ciudad_id, nombre")
    else
      @oficinas_select = []
    end
  end

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

end

