# encoding: utf-8
class Basico::TecnicoCampoController < FormTabsController
  
   skip_before_filter :set_charset, :only=>[:check_ci_new, :estado_change_index, :oficina_change, :estado_change, :municipio_change, :tabs ]
  
  layout 'form_basic'
  
  def index
    oficina = Oficina.find(session[:oficina])
    oficina_fill(0)
  end

   def list
    params['sort'] = "tecnico_campo.primer_nombre" unless params['sort']
    conditions = "tecnico_campo.id > 0"
    unless params[:cedula].blank?
      conditions << " and cedula = #{params[:cedula]} and letra_cedula ='#{params[:letra_cedula]}'"
    end

    unless params[:primer_nombre].blank?
      conditions << " AND LOWER(primer_nombre) LIKE '%#{params[:primer_nombre].strip.downcase}%'"
    end

    unless params[:primer_apellido].blank?
      conditions << " AND LOWER(primer_apellido) LIKE '%#{params[:primer_apellido].strip.downcase}%'"
    end


    unless params[:tecnico_campo][:estado_id].blank? || params[:tecnico_campo][:estado_id].to_i == 0
     conditions << " and (tecnico_campo.oficina_id in (select id from oficina where ciudad_id in (select id from ciudad where estado_id = #{params[:tecnico_campo][:estado_id]})))"
    end

    unless params[:tecnico_campo][:oficina_id].blank? || params[:tecnico_campo][:oficina_id].to_i == 0
      conditions << " AND oficina_id =#{params[:tecnico_campo][:oficina_id]}"
    end
    
    #@total = TecnicoCampo.count(:all,:conditions => @condition,:joins=>',oficina',:order=>'cedula',:select=>'distinct on (tecnico_campo.cedula) tecnico_campo.*')
    @list = TecnicoCampo.search(conditions, params[:page], params[:sort])
    @total=@list.count
#    @pages, @list = paginate(:tecnico_campo, :class_name => 'TecnicoCampo',
#      #:include => ['estado','Municipio','Parroquia','oficina'],
##      :joins=> ',oficina',
#      :conditions => @condition,
#      :per_page => @records_by_page,
##      :select=>'distinct on (tecnico_campo.cedula) tecnico_campo.*',
##      :order=>'tecnico_campo.cedula',
#      :order_by => 'tecnico_campo.carga_trabajo asc')
    form_list
  end

  def check_ci_new
   if (params[:cedula].nil? || params[:cedula].blank?)
      render :update do |page|
        page.alert "Debe introducir un Cédula"
      end
      return false
   else
       usu = Usuario.count(:all, :conditions=>"cedula_nacionalidad = '#{params[:letra_cedula]}' and cedula = #{params[:cedula]}")
        if usu == 0
          render :update do |page|
              page.alert "El Usuario no se encuentra registrado. Debe registrar el Usuario para continuar"
          end
          return false
        else
           tec = TecnicoCampo.count(:all, :conditions=>"letra_cedula = '#{params[:letra_cedula]}' and cedula = #{params[:cedula]}")
           if tec > 0
             render :update do |page|
              page.alert "El Técnico de campo ya se encuentra registrado"
             end
             return false
           else
             letra = params[:letra_cedula].to_s
             numero = params[:cedula]
           end
        end 
   end
   if letra && numero
        render :update do |page|
          page.redirect_to :action=>'new', :cedula=>numero, :letra=>letra, :popup=>params[:popup]
        end
    else
        render :update do |page|
          page.alert "Debe introducir un Cédula"
        end
    end
  end
  
  
  def view
    @tecnico_campo = TecnicoCampo.find(params[:id])
    fill_sector_tecnico
    fill_area_influencia_tecnico
  end
 
  def new
    @usuario = Usuario.find(:first, :conditions=>"cedula_nacionalidad = '#{params[:letra]}' and cedula = #{params[:cedula]} and activo = TRUE")
    @tecnico_campo = TecnicoCampo.new
    @tecnico_campo.letra_cedula = @usuario.cedula_nacionalidad
    @tecnico_campo.cedula = @usuario.cedula
    @tecnico_campo.primer_nombre = @usuario.primer_nombre
    @tecnico_campo.segundo_nombre = @usuario.segundo_nombre
    @tecnico_campo.primer_apellido = @usuario.primer_apellido
    @tecnico_campo.segundo_apellido = @usuario.segundo_apellido
    fill_tecnico_campo
  end

  def save_new
    @tecnico_campo = TecnicoCampo.new(params[:tecnico_campo])
    form_save_new @tecnico_campo 
  end
  
  def delete
    @tecnico_campo = TecnicoCampo.find(params[:id])
    result = @tecnico_campo.eliminar(params[:id])
    if result == false
      render :update do |page|
        page.form_error
      end
      return
    else
      render :update do |page|
        page.form_delete @tecnico_campo, 'tecnico_campo'
      end
    end
  end
  
  def edit
    @tecnico_campo = TecnicoCampo.find(params[:id])
    @estado = Estado.find(:all, :order=>'nombre')
    fill_tecnico_campo 
    fill_sector_tecnico
    fill_area_influencia_tecnico
  end
  
  def save_edit
    @tecnico_campo = TecnicoCampo.find(params[:id])
    form_save_edit @tecnico_campo
  end

  def estado_change_index
    oficina_fill(params[:estado_id])
    render :update do |page|
      page.replace_html 'oficina-search', :partial => 'oficina_search'
    end
  end

  def estado_change
    municipio_fill(params[:estado_id])
    render :update do |page|
      page.replace_html 'municipio-search', :partial => 'municipio_search'
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end

  def municipio_change
    parroquia_fill(params[:municipio_id])
    render :update do |page|
      page.replace_html 'parroquia-search', :partial => 'parroquia_search'
    end
  end

  def oficina_change
    oficina_fill(params[:estado_id])
    render :update do |page|
      page.replace_html 'oficina-search', :partial => 'oficina_search'
    end
  end

  def fill_sector_tecnico
    @sector_tecnico_select = SectorTecnico.find(:all, :order=>'sector_id')
  end

  def fill_area_influencia_tecnico
    @area_influencia_tecnico_select = AreaInfluenciaTecnico.find(:all)
  end

  protected
  def common
    super
    @form_title          = I18n.t('Sistema.Body.Controladores.TecnicoCampo.FormTitles.form_title')
    @form_title_record   = I18n.t('Sistema.Body.Controladores.TecnicoCampo.FormTitles.form_title_record')
    @form_title_records  = I18n.t('Sistema.Body.Controladores.TecnicoCampo.FormTitles.form_title_records')
    @form_entity         = 'tecnico_campo'
    @form_identity_field = 'complemento'
    @width_layout        = '800'
    fill_tecnico_campo_index
  end
  
  private
  def fill_tecnico_campo_index
    @estado = Estado.find(:all, :order=>'nombre')
    @oficina = Oficina.find(:all, :order=>'nombre')
    estado_id = @estado[0].id
    oficina_fill(estado_id)
  end

  def fill_tecnico_campo
    @estado = Estado.find(:all, :order=>'nombre')
    @profesion = Profesion.find(:all, :order=>'nombre')
    @oficina = Oficina.find(:all, :order=>'nombre')
    unless @tecnico_campo.nil?
      if @tecnico_campo.estado
        estado_id = @tecnico_campo.estado_id
      else
        estado_id = @estado[0].id
      end
    else
      estado_id = @estado[0].id
    end
    municipio_fill(estado_id)
  end
  
  def municipio_fill(estado_id)
    @municipio_list = Municipio.find(:all, :conditions=>['estado_id = ?', estado_id], :order=>'nombre')
    if @tecnico_campo && @tecnico_campo.municipio_id
      municipio_id = @tecnico_campo.municipio_id
    else
      municipio_id = @municipio_list.first.id
    end
    parroquia_fill(municipio_id)
  end

  def parroquia_fill(municipio_id)
    @parroquia_list = Parroquia.find(:all, :conditions=>['municipio_id = ?', municipio_id], :order=>'nombre')
    if @tecnico_campo && @tecnico_campo.parroquia_id
      parroquia_id = @tecnico_campo.parroquia_id
    else
      parroquia_id = @parroquia_list.first.id
    end
  end

  def oficina_fill(estado_id)
    @oficina_list = Oficina.find(:all, :conditions=>['ciudad_id in (select id from ciudad where estado_id = ?)', estado_id], :order=>'nombre')

  end

end
