# encoding: utf-8
#
# autor: Luis Rojas
# clase: Clientes::ClienteEmpresaIntegrantePersonaController
# descripción: Migración a Rails 3
#
class Clientes::ClienteEmpresaIntegrantePersonaController < FormTabTabsController
  
  skip_before_filter :set_charset, :only=>[:check_new]

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
    
	def check_new
    @empresa = Empresa.find(params[:empresa_id])
	  if params[:cedula] && !params[:cedula].empty? && params[:cedula].to_i > 0
      persona = Persona.find_by_cedula(params[:cedula])
      unless persona
        render :update do |page|
          page.redirect_to :action=>'new', :cedula=>params[:cedula], :empresa_id=>@empresa.id, :popup=>params[:popup]
        end
      else
        empresa_integrante = EmpresaIntegrantePersona.find_by_persona_id_and_empresa_id(persona.id, @empresa.id)
        unless empresa_integrante
          empresa_integrante = EmpresaIntegrantePersona.find(:first, :conditions=>['persona_id = ?', persona.id])
          if empresa_integrante
            render :update do |page|
              page.alert("#{I18n.t('Sistema.Body.General.integrante')} #{persona.nombre_corto} #{I18n.t('Sistema.Body.Modelos.Errores.ya_registrado')} #{I18n.t('Sistema.Body.Vistas.General.en')} #{I18n.t('Sistema.Body.Vistas.General.la')} #{I18n.t('Sistema.Body.General.empresa')} #{empresa_integrante.empresa.nombre}.")
              page.redirect_to :action=>'new', :cedula=>params[:cedula], :empresa_id=>@empresa.id, :popup=>params[:popup]
            end
          else
            render :update do |page|
              page.redirect_to :action=>'new', :cedula=>params[:cedula], :empresa_id=>@empresa.id, :popup=>params[:popup]
            end
          end
        else
          render :update do |page|
            page.alert("#{I18n.t('Sistema.Body.General.integrante')} #{I18n.t('Sistema.Body.Vistas.General.con')} #{I18n.t('Sistema.Body.Vistas.General.la')} #{I18n.t('Sistema.Body.Vistas.General.cedula')}  #{params[:cedula].to_i.to_s} #{I18n.t('Sistema.Body.Modelos.Errores.ya_existe')}")
          end
        end
      end
    else
      render :update do |page|
        page.alert "#{I18n.t('Sistema.Body.Vistas.General.nro')} #{I18n.t('Sistema.Body.Vistas.General.cedula')} #{I18n.t('Sistema.Body.Modelos.Errores.es_requerido')}"
      end
    end
	end
	
	def view_detail
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_integrante_tipo = EmpresaIntegranteTipo.find(params[:id])
    @empresa_integrante = @empresa_integrante_tipo.empresa_integrante
  end
  
  def new
    @empresa = Empresa.find(params[:empresa_id])  
    @persona = Persona.find_by_cedula(params[:cedula])
    if !@persona
      @persona = Persona.new(:cedula=>params[:cedula])
    else
      @empresa_integrante = EmpresaIntegrantePersona.find_by_persona_id_and_empresa_id(@persona.id, @empresa.id)
    end
    @empresa_integrante = EmpresaIntegrantePersona.new unless @empresa_integrante
    @empresa_integrante_tipo = EmpresaIntegranteTipo.new
    fill
    nacionalidad_fill(nil)
    empresa_integrante_tipo_count = EmpresaIntegranteTipo.count(:conditions=>["tipo = 'R' and empresa_integrante_id in (select id from empresa_integrante where empresa_id = ?)", @empresa.id])
    if empresa_integrante_tipo_count > 0
      @disa = 1
    else
      @disa = 0
    end
  end
  
  def save_new
    @empresa = Empresa.find(params[:empresa_id])
    if params[:persona_id] && !params[:persona_id].empty?
      @persona = Persona.find(params[:persona_id])
      if params[:empresa_integrante_id] && !params[:empresa_integrante_id].empty?
        @empresa_integrante = EmpresaIntegrantePersona.find(params[:empresa_integrante_id])
      end
      @persona.attributes = params[:persona]
    end
    @empresa_integrante = EmpresaIntegrantePersona.new(params[:empresa_integrante]) unless @empresa_integrante  
    @persona = Persona.new(params[:persona]) unless @persona
    @empresa_integrante_tipo = EmpresaIntegranteTipo.new(params[:empresa_integrante_tipo])
    form_save_new @empresa_integrante_tipo,
      :value=>@empresa.add_integrante(@empresa_integrante_tipo, @persona, @empresa_integrante),
      :params=> { :empresa_id => @empresa.id }
  end
  
  def edit
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_integrante_tipo = EmpresaIntegranteTipo.find(params[:id])
    @empresa_integrante = @empresa_integrante_tipo.empresa_integrante
    @persona = @empresa_integrante.persona
    fill
    sexo = @persona.sexo

    if sexo == true
      nacionalidad = 'masculino'
    else
      nacionalidad = 'femenino'    
    end       
    nacionalidad_fill(nacionalidad)
    empresa_integrante_tipo_count = EmpresaIntegranteTipo.count(:conditions=>["tipo = 'R' and empresa_integrante_id in (select id from empresa_integrante where empresa_id = ? and persona_id <> ?)", @empresa.id, @persona.id])
    if empresa_integrante_tipo_count > 0
      @disa = 1
    else
      @disa = 0
    end
  end
  
  def save_edit
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_integrante_tipo = EmpresaIntegranteTipo.find(params[:id])
    @persona = Persona.find_by_cedula(params[:persona][:cedula])
    @empresa_integrante = @empresa_integrante_tipo.empresa_integrante
    @persona.update_attributes(params[:persona])
    @persona.save
    @empresa_integrante.update_attributes(params[:empresa_integrante])
    form_save_edit @empresa_integrante_tipo,
      :value=>@empresa_integrante_tipo.update_all(@persona, @empresa_integrante, params[:empresa_integrante_tipo]),
      :params=> { :id=>@empresa_integrante_tipo.id, :empresa_id => @empresa.id }
  end
  
  def delete
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_integrante_tipo = EmpresaIntegranteTipo.find(params[:id])
    @empresa_integrante_tipo.empresa_integrante.persona
    form_delete @empresa_integrante_tipo, @empresa_integrante_tipo.destroy_with_empresa_integrante
  end

  def estado_change
    estado_id = params[:estado_id]
    municipio_fill(estado_id)
    ciudad_fill(estado_id)
    render :update do |page|    
      page.replace_html 'municipio-select', :partial => 'municipio_select'
      page.replace_html 'ciudad-select', :partial => 'ciudad_select'
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end
  
  def municipio_change
    municipio_id = params[:municipio_id]
    parroquia_fill(municipio_id)
    render :update do |page|    
      page.replace_html 'parroquia-select', :partial => 'parroquia_select'
    end
  end
  
  def vinculo
    _vinculo
  end
  
  def vinculo_view
    _vinculo
  end

  def sexo_change
    sexo = params[:sexo]
    if sexo == 'true'
      nacionalidad = 'masculino'
    else
      nacionalidad = 'femenino'    
    end
 
    nacionalidad_fill(nacionalidad)
    render :update do |page|    
      page.replace_html 'nacionalidad-select', :partial => 'nacionalidad_select'
    end  
  end

  protected  
  def common
    super
    @form_title = "#{I18n.t('Sistema.Body.General.beneficiario')} #{I18n.t('Sistema.Body.Vistas.General.juridico')}"
    @form_title_record = I18n.t('Sistema.Body.General.integrante')
    @form_title_records = I18n.t('Sistema.Body.General.integrantes')
    @form_entity = 'empresa_integrante_tipo'
    @form_identity_field = 'empresa_integrante.persona.nombre_corto'
    @width_layout = '800'
  end
  
  private
  def _vinculo
    @empresa = Empresa.find(params[:empresa_id])
    @empresa_integrante_tipo = EmpresaIntegranteTipo.find(params[:id])
    persona_id = @empresa_integrante_tipo.empresa_integrante.persona.id
    @es_cliente = !ClientePersona.find_by_persona_id(persona_id).nil?
    @integrante_list = EmpresaIntegranteTipo.find(:all, :conditions=>["empresa_integrante.persona_id = ? AND empresa_integrante_tipo.id <> ? AND type = 'EmpresaIntegrantePersona' ", persona_id, @empresa_integrante_tipo.id], :include=>:empresa_integrante)
  end
  
  def _list
    @empresa = Empresa.find(params[:empresa_id])
    joins = 'INNER JOIN empresa_integrante ON empresa_integrante_tipo.empresa_integrante_id = empresa_integrante.id INNER JOIN persona ON empresa_integrante.persona_id = persona.id'
    conditions = ["empresa_integrante.empresa_id = ? AND type = 'EmpresaIntegrantePersona'", @empresa.id]
    params['sort'] = "persona.primer_nombre" unless params['sort']
    
    @list = EmpresaIntegranteTipo.search(conditions, params[:page], params[:sort])
    @total=@list.count
  end
  
  private
  def fill
    @profesion_select = Profesion.find(:all, :order=>'nombre')
    @instancia_select = InstanciaEmpresa.find(:all, :order => 'id')
    @pais_list = Pais.find(:all, :order=>'nombre')
  end

  def nacionalidad_fill(nacionalidad)
    unless nacionalidad.nil?
      @nacionalidad_select = Nacionalidad.find_by_sql("select id," + nacionalidad + " as descripcion from nacionalidad" )
    else
      @nacionalidad_select = Nacionalidad.find_by_sql("select id, femenino as descripcion from nacionalidad" )
    end
  end
  
end
