# encoding: utf-8
class Sistema::RolController < FormTabsController
  
  skip_before_filter :set_charset, :only=>[:estado_change, :tabs ]

  def list
    params['sort'] = "nombre" unless params['sort']
    conditions = "empresa_sistema_id = #{@usuario.empresa_sistema_id}"
    unless params[:nombre].nil?
      conditions << " AND LOWER(rol.nombre) LIKE '%#{params[:nombre].strip.downcase}%'"
      @form_search_expression << "#{I18n.t('Sistema.Body.Controladores.SearchComun.nombre')} '#{params[:nombre]}'"
    end
    
    @list = Rol.search(conditions, params[:page], params[:sort])
    @total=@list.count
    form_list
  end

  def view
    @form_title = I18n.t('Sistema.Body.Controladores.Rol.FormTitles.form_title')
    @rol = Rol.find(params[:id])
  end

  def new
    @form_title = I18n.t('Sistema.Body.Controladores.Rol.FormTitles.form_title')
    @rol = Rol.new
  end

  def save_new
    params[:rol][:nombre] = params[:rol][:nombre].strip.upcase
    @rol = Rol.new(params[:rol])
    @rol.empresa_sistema_id = @usuario.empresa_sistema_id
    form_save_new @rol
  end

  def edit
    @form_title = I18n.t('Sistema.Body.Controladores.Rol.FormTitles.form_title')
    @rol = Rol.find(params[:id])
  end

  def save_edit
    @rol = Rol.find(params[:id])
    form_save_edit @rol
  end

  def imprimir
    if params[:id].nil?
      @rol = Rol.find(:all, :order=>'nombre')
    else
      @rol = Rol.find(:all, :conditions=>['id = ?', params[:id]])
    end
  end

  protected
  def common
    super
    @form_title = I18n.t('Sistema.Body.Controladores.Rol.FormTitles.form_title')
    @form_title_record = I18n.t('Sistema.Body.Controladores.Rol.FormTitles.form_title_record')
    @form_title_records = I18n.t('Sistema.Body.Controladores.Rol.FormTitles.form_title_records')
    @form_entity = 'rol'
    @form_identity_field = 'nombre'
    @width_layout = '960'
  end

  private
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

end

